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
#import "RadiusViewController.h"
#import "Car.h"
#import "LocationViewController.h"
#import "Location.h"

@protocol DriverSignUpViewControllerDelegate;

@interface DriverSignUpViewController : UITableViewController <UITextFieldDelegate,CarTypeViewControllerDelegate, RadiusViewControllerDelegate,LocationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *carDescription;
@property (weak, nonatomic) IBOutlet UITextField *taxiStand;
@property (weak, nonatomic) IBOutlet UISwitch *activeStatus;
@property (weak, nonatomic) IBOutlet UITextField *radiusServed;

@property (weak, nonatomic) IBOutlet UITableViewCell *signUpCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *carCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *taxiStandCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *radiusCell;

@property (strong, nonatomic) Location *taxiStandLocation;
@property (strong,nonatomic) Car *car;
@property (strong,nonatomic) Radius *radius; //radius served

@property (nonatomic, assign) id<DriverSignUpViewControllerDelegate>delegate;

- (IBAction)cancelPressed:(id)sender;


@end


@protocol DriverSignUpViewControllerDelegate <NSObject>

- (void) driverSignUpViewControllerHasDone: (DriverSignUpViewController *) viewController;

@end
