//
//  AuthenticationViewController.h
//  InventoryManager
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEUser.h"
#import "FirstViewController.h"
#import "PassengerSignUpViewController.h"
#import "DriverSignUpViewController.h"



@interface LogInViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate, PassengerSignUpViewControllerDelegate, DriverSignUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end


