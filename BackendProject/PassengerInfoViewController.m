    //
//  PassengerInfoViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 18/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "PassengerInfoViewController.h"


@interface PassengerInfoViewController ()


@property (strong,nonatomic) UIBarButtonItem *cancelLeftBarButton;
@property (strong,nonatomic) UIBarButtonItem *menuLeftBarButton;


@end

@implementation PassengerInfoViewController{
    
    CGFloat animatedDistance;
    BOOL cancelPressed;
    
}

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    [self retrievePassengerInformation];
    

   
}



#pragma mark - retrieveData
- (void)retrievePassengerInformation{
    
    [MEUser retrieveLoggedUserDetails:^(MEUser *meUser, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                
                
                self.meUser = meUser;
                
                self.email.text = meUser.email;
                self.firstName.text = meUser.firstName;
                self.lastName.text = meUser.lastName;
                self.phone.text = meUser.phone;
                self.meUser = meUser;
                
                //logged user info is displayed so prepare navigattion bar buttons
                
                //prepare navigation bar button
                self.cancelLeftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
                
                
                //add buttons to the navigation bar
                self.navigationItem.rightBarButtonItem = self.editButtonItem;

                
            }else{

                [Helper showErrorMEUserWithError:error];
            }
            
        });
        
    }];
}


#pragma mark - updateData

- (void)updatePassengerInformation{
    
    self.meUser.email = self.email.text;
    self.meUser.firstName = self.firstName.text;
    self.meUser.lastName = self.lastName.text;
    self.meUser.phone = self.phone.text;
    
    [MEUser updateLoggedUserDetails:self.meUser completionHandler:^(NSError *error, NSString *successMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                [Helper showSuccessMEUser:successMessage];
            }
        });
    }];
    
}


#pragma mark - configure textField
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.firstName resignFirstResponder];
    
    [self.lastName resignFirstResponder];
    [self.phone resignFirstResponder];
}
- (void)hideKeyboard{
    [self.firstName resignFirstResponder];
    
    [self.lastName resignFirstResponder];
    [self.phone resignFirstResponder];
}


#pragma mark - configure table view


//
//////set all table rows to a non editable state
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
   return NO;
}




#pragma mark - fired actions

// cancel pressed fired method
- (void)cancelPressed{
    cancelPressed = YES;
    [self setEditing:NO animated:YES];
}


- (void)setEditing:(BOOL)flag animated:(BOOL)animated{
    
    [super setEditing:flag animated:animated];
    if (flag == YES){
        // Change views to edit mode.
        self.firstName.enabled = YES;
        self.lastName.enabled = YES;
        self.phone.enabled = YES;
        
        
        //add cancel button to the navigation bar
        self.navigationItem.leftBarButtonItem = self.cancelLeftBarButton;
        
        //to-do
        //add some look n feel into the edit mode screen
        
    }
    else {
        self.firstName.enabled = NO;
        [self.firstName resignFirstResponder];
        self.lastName.enabled = NO;
        [self.lastName resignFirstResponder];
        self.phone.enabled = NO;
        [self.phone resignFirstResponder];
        
        
        
        
        if (!cancelPressed) {
            
            //to-do
            // Save the changes on the server
            [self updatePassengerInformation];
        }
        
        self.navigationItem.leftBarButtonItem = self.menuLeftBarButton;
        cancelPressed = NO;
    }
}

 
@end
