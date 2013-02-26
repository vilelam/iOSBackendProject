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

    
    //logIn
    if (indexPath.section == 1 &&
        indexPath.row == 0) {
    
        [MEUser logInWithUsername:self.userName.text Password:self.password.text TenantName:@"naSavassi" Type:@"self" CompletionHandler:^(MEUser *meUser, NSError *error) {
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIViewController *firstViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstView"];
                    [self presentViewController:firstViewController animated:YES completion:nil];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] objectForKey:@"error"]  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                });
            }
        }];
     
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
    //SignUp
    if (indexPath.section == 2 &&
        indexPath.row == 0) {
        
        
        
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
        
    }
}





@end
