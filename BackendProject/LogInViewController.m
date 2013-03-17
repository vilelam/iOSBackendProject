//
//  AuthenticationViewController.m
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//



#import "LogInViewController.h"

@interface LogInViewController ()



@end

@implementation LogInViewController

- (void)viewWillAppear:(BOOL)animated{
    self.userName.text = @"";
    self.password.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //capture every time the tableView is touched and call method hideKeyboard
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
   

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

//hide the keyboard from UITextField every time tableView is touched
- (void)hideKeyboard{
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
  
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        NSString *email = (NSString*)[alertView textFieldAtIndex:0].text;

//        if (!error) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset" message: [NSString stringWithFormat:@"An email with reset instructions has been sent to %@",email] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [alert show];
//        }else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Reset" message: [NSString stringWithFormat:@"%@",[[error userInfo]objectForKey:@"error"]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            [alert show];
//        }

    }else if (buttonIndex == 0){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    //SignIn
    if (indexPath.section == 1 &&
        indexPath.row == 0) {
        
        MEUser *meUser;
        meUser = [MEUser signInWithUsername:self.userName.text Password:self.password.text TenantName:@"WorldTaxi" Type:@"self"];
        
        if (meUser) {
            UIViewController *firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstView"];
            [self presentViewController:firstViewController animated:YES completion:nil];
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    //SignUp - Passager
    if (indexPath.section == 2 &&
        indexPath.row == 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    //SignUp - driver
    if (indexPath.section == 2 &&
        indexPath.row == 1) {
        
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }

    
    //reset password
    if (indexPath.section == 3 &&
        indexPath.row == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] init];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        alert.delegate = self;
        alert.title = @"Enter Email";
        [alert addButtonWithTitle:@"Cancel"];
        [alert addButtonWithTitle:@"Ok"];
        alert.message = @"Please enter the email address for your account.";
        [alert show];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)passengerSignUpViewControllerHasDone:(PassengerSignUpViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)driverSignUpViewControllerHasDone:(DriverSignUpViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"SignUpPassenger"]) {
        PassengerSignUpViewController *destViewControler = segue.destinationViewController;
        destViewControler.delegate = self;
    }else if([segue.identifier isEqualToString:@"SignUpDriver"]){
        DriverSignUpViewController *destViewControler = segue.destinationViewController;
        destViewControler.delegate = self;
    }
}

@end
