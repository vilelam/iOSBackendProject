//
//  DriverInfoViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 18/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "DriverInfoViewController.h"
#import "ECSlidingViewController.h"
#import "DriverMenuViewController.h"

@interface DriverInfoViewController ()


@property (strong,nonatomic) UIBarButtonItem *cancelLeftBarButton;
@property (strong,nonatomic) UIBarButtonItem *menuLeftBarButton;


@end

@implementation DriverInfoViewController{
    
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
    
    [self retrieveDriverInformation];
    
    //prepare navigation bar button
    
    self.cancelLeftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed)];
    
    self.menuLeftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
    
    //prepare menu
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[DriverMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DriverMenu"];
    }
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    
    
    //add buttons to the navigation bar
    
    self.addedNavigationItem.rightBarButtonItem = self.editButtonItem;
    self.addedNavigationItem.leftBarButtonItem = self.menuLeftBarButton;
    
}



#pragma mark - retrieveData
- (void)retrieveDriverInformation{
    
    [MEUser retrieveLoggedUserDetails:^(MEUser *meUser, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                self.email.text = meUser.email;
                self.firstName.text = meUser.firstName;
                self.lastName.text = meUser.lastName;
                self.phone.text = meUser.phone;
            }else{
                
                [Helper showErrorMEUser:[[error userInfo] objectForKey:@"error"]];
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


#pragma mark - table view delegate


//
//////set all table rows to a non editable state
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.editing){
        
        if ([tableView cellForRowAtIndexPath:indexPath] == self.carCell) {
            CarTypeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CarTypeList"];
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }else if ([tableView cellForRowAtIndexPath:indexPath] == self.radiusCell) {
            RadiusViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"RadiusList"];
            controller.delegate = self;
            [self presentViewController:controller animated:YES completion:nil];
        }
        
    }
    
}


#pragma mark - fired actions

// cancel pressed fired method
- (void)cancelPressed{
    cancelPressed = YES;
    [self setEditing:NO animated:YES];
}

- (void)revealMenu:(id)sender {
    
    [self.slidingViewController anchorTopViewTo:ECRight];
    
}

- (void)setEditing:(BOOL)flag animated:(BOOL)animated{
    
    [super setEditing:flag animated:animated];
    if (flag == YES){
        // Change views to edit mode.
        self.firstName.enabled = YES;
        self.lastName.enabled = YES;
        self.phone.enabled = YES;
        
        self.tableView.allowsSelectionDuringEditing = YES;
        
        
        self.carCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.radiusCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        //add cancel button to the navigation bar
        self.addedNavigationItem.leftBarButtonItem = self.cancelLeftBarButton;
        
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
        
        self.carCell.accessoryType = UITableViewCellAccessoryNone;
        self.radiusCell.accessoryType = UITableViewCellAccessoryNone;
        
        if (!cancelPressed) {
            
            //to-do
            // Save the changes on the server
        }
        
        self.addedNavigationItem.leftBarButtonItem = self.menuLeftBarButton;
        cancelPressed = NO;
    }
}

#pragma mark - CarTypeList View Controller delegate methods

- (void)carTypeViewControllerHasDone:(CarTypeViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)carTypeSelected:(Car *)car AtViewController:(CarTypeViewController *)viewController{
    self.car = car;
    self.carDescription.text = car.description;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Radius View Controller delegate methods

- (void) radiusViewControllerHasDone:(RadiusViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)radiusSelected:(Radius *)radius AtViewController:(RadiusViewController *)viewController{
    
}

@end