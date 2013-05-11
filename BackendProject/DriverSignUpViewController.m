//
//  DriverSignUpViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 17/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "DriverSignUpViewController.h"

@interface DriverSignUpViewController ()

@end

@implementation DriverSignUpViewController{
    
    CGFloat animatedDistance;
    
}

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
}

- (void)viewWillAppear:(BOOL)animated{
//    self.username.text = @"";
//    self.password.text = @"";
//    self.email.text = @"";
//    self.firstName.text = @"";
//    self.lastName.text = @"";
//    self.phoneNumber.text = @"";
//    self.carType.text = @"";
//    self.servedMetro.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Configuration

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.password resignFirstResponder];
    [self.username resignFirstResponder];
    [self.email resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.carDescription resignFirstResponder];
    [self.taxiStand resignFirstResponder];
}

- (void)hideKeyboard{
    [self.password resignFirstResponder];
    [self.username resignFirstResponder];
    [self.email resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.carDescription resignFirstResponder];
    [self.taxiStand resignFirstResponder];
}


- (IBAction)cancelPressed:(id)sender {
    [[self delegate] driverSignUpViewControllerHasDone:self];
}


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


#pragma mark - tableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //SignUp
    if ([self.tableView cellForRowAtIndexPath:indexPath] == self.signUpCell) {
        
        NSError *error;
        NSString *activeStatus;
        if (self.activeStatus.on) {
            activeStatus = @"ENABLED";
        }else{
            activeStatus = @"DISABLED";
        }
        
        error = [MEUser signUpWithDriverUsername:self.username.text
                                        Password:self.password.text
                                      TenantName:@"WorldTaxi"
                                           Email:self.email.text
                                       FirstName:self.firstName.text
                                        LastName:self.lastName.text
                                     PhoneNumber:self.phoneNumber.text
                                          Locale:@"en_US"
                                         CarType:self.car
                                  ServedLocation:self.taxiStandLocation
                                    ActiveStatus:activeStatus
                                    RadiusServed:self.radius];
        
        if (!error){
           
            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InitDriver" ];
            [self presentViewController:controller animated:YES completion:nil];
            
        }else{
            [Helper showErrorMEUserWithError:error];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }else if ([self.tableView cellForRowAtIndexPath:indexPath] == self.carCell){
        
        CarTypeViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CarTypeList"];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }else if ([self.tableView cellForRowAtIndexPath:indexPath] == self.taxiStandCell){
        
        LocationViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Location"];
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        
    }

}


#pragma mark - implemented protocols

- (void)carTypeViewControllerHasDone:(CarTypeViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)carTypeSelected:(Car *)car AtViewController:(CarTypeViewController *)viewController{
    self.car = car;
    self.carDescription.text = car.description;
    [viewController dismissViewControllerAnimated:YES completion:nil];
    
}





- (void)locationSelected:(Location *)location atViewControler:(LocationViewController *)viewController{
    self.taxiStandLocation = location;
    self.taxiStand.text = location.locationName;
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationViewControllerCancelled:(LocationViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end


