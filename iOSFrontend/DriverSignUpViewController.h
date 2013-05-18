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
#import "CarTypeViewController.h"
#import "Car.h"
#import "LocationViewController.h"
#import "Location.h"

@protocol DriverSignUpViewControllerDelegate;

@interface DriverSignUpViewController : UITableViewController <UITextFieldDelegate,CarTypeViewControllerDelegate, LocationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *carDescription;
@property (weak, nonatomic) IBOutlet UITextField *taxiStand;
@property (weak, nonatomic) IBOutlet UISwitch *activeStatus;


@property (weak, nonatomic) IBOutlet UITableViewCell *signUpCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *carCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *taxiStandCell;


@property (strong, nonatomic) Location *taxiStandLocation;
@property (strong,nonatomic) Car *car;


@property (nonatomic, assign) id<DriverSignUpViewControllerDelegate>delegate;




@end


@protocol DriverSignUpViewControllerDelegate <NSObject>

- (void) driverSignUpViewControllerHasDone: (DriverSignUpViewController *) viewController;

@end
