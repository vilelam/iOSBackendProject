//
//  SignUpViewController.m
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import "PassengerSignUpViewController.h"

@interface PassengerSignUpViewController ()

@end

@implementation PassengerSignUpViewController{
    
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
}
- (void)hideKeyboard{
    [self.password resignFirstResponder];
    [self.username resignFirstResponder];
    [self.email resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
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
    
    
    //validate email address
    if ([textField isEqual:self.email]) {
        if (![Helper validateEmail:textField.text]) {
            [Helper showErrorMEUserWithErrorString:@"Invalid e-mail address. Please type it again."];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //username validation
    if ([textField isEqual:self.username]) {
        
        //do not allow user to add whitespace to the text
        if ([Helper checkIfThereAreWhiteSpace:string]) {
            return NO;
        }
    }
    
    
    //email validation
    else if([textField isEqual:self.email]){
        
        //do not allow user to add whitespace to the text
        if ([Helper checkIfThereAreWhiteSpace:string]) {
            return NO;
        }
    }
    
    return YES;

}


#pragma mark - tableView

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //SignUp
    if (indexPath.section == 2 &&
        indexPath.row == 0) {
        
        NSError *error;
        
        error = [MEUser signUpWithUsername:self.username.text Password:self.password.text TenantName:@"WorldTaxi" Email:self.email.text FirstName:self.firstName.text LastName:self.lastName.text PhoneNumber:self.phoneNumber.text Locale:@"en_US"];
        
        if (!error){
            UIViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"InitPassenger"];
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            [Helper showErrorMEUserWithError:error];
        }
     
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}


@end
