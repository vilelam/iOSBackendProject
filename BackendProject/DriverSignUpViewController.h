//
//  DriverSignUpViewController.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import "MEUser.h"
#import "FirstViewController.h"


@protocol DriverSignUpViewControllerDelegate;

@interface DriverSignUpViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *carType;
@property (weak, nonatomic) IBOutlet UITextField *servedMetro;
@property (weak, nonatomic) IBOutlet UISwitch *activeStatus;


@property (nonatomic, assign) id<DriverSignUpViewControllerDelegate>delegate;

- (IBAction)cancelPressed:(id)sender;


@end


@protocol DriverSignUpViewControllerDelegate <NSObject>

- (void) driverSignUpViewControllerHasDone: (DriverSignUpViewController *) viewController;

@end
