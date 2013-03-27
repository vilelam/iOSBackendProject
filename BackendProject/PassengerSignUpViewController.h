//
//  PassengerSignUpViewController.h
//  
//
//  Created by Marcos Vilela on 28/12/12.
//  Copyright (c) 2012 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MEUser.h"



@protocol PassengerSignUpViewControllerDelegate;

@interface PassengerSignUpViewController : UITableViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;


@property (nonatomic, assign) id<PassengerSignUpViewControllerDelegate>delegate;

- (IBAction)cancelPressed:(id)sender;



@end


@protocol PassengerSignUpViewControllerDelegate <NSObject>

- (void) passengerSignUpViewControllerHasDone: (PassengerSignUpViewController *) viewController;

@end