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
    self.username.text = @"";
    self.password.text = @"";
    self.email.text = @"";
    self.firstName.text = @"";
    self.lastName.text = @"";
    self.phoneNumber.text = @"";
    self.carType.text = @"";
    self.servedMetro.text = @"";
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
    [self.carType resignFirstResponder];
    [self.servedMetro resignFirstResponder];
}
- (void)hideKeyboard{
    [self.password resignFirstResponder];
    [self.username resignFirstResponder];
    [self.email resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.carType resignFirstResponder];
    [self.servedMetro resignFirstResponder];
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
    if (indexPath.section == 2 &&
        indexPath.row == 0) {
        
        MEUser *meUser;
        NSString *activeStatus;
        if (self.activeStatus.on) {
            activeStatus = @"ENABLED";
        }else{
            activeStatus = @"DISABLED";
        }
        
        meUser = [MEUser signUpWithDriverUsername:self.username.text Password:self.password.text TenantName:@"WorldTaxi" Email:self.email.text FirstName:self.firstName.text LastName:self.lastName.text PhoneNumber:self.phoneNumber.text Locale:@"en_US" CarType:self.carType.text ServedMetro:self.servedMetro.text ActiveStatus:activeStatus];
        
        if (meUser){
            FirstViewController *fViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstView"];
            [self presentViewController:fViewController animated:YES completion:nil];
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}


@end


