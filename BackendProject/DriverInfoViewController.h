//
//  DriverInfoViewController.h
//  BackendProject
//
//  Created by Marcos Vilela on 23/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEUser.h"
#import "CarTypeViewController.h"
#import "RadiusViewController.h"
#import "Car.h"

@interface DriverInfoViewController : UITableViewController <UITextFieldDelegate, CarTypeViewControllerDelegate,RadiusViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationItem *addedNavigationItem;

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *carDescription;
@property (weak, nonatomic) IBOutlet UITextField *servedMetro;

@property (weak, nonatomic) IBOutlet UISwitch *activeStatus;
@property (weak, nonatomic) IBOutlet UITableViewCell *carCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *radiusCell;

@property (strong,nonatomic) Car* car;


- (void)retrieveDriverInformation;
- (void) cancelPressed;
- (void)revealMenu:(id)sender;


@end
