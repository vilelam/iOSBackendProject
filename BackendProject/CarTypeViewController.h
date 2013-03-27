//
//  CarTypeViewController.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Car.h"
#import "Helper.h"


@protocol CarTypeViewControllerDelegate;

@interface CarTypeViewController : UITableViewController


@property (strong, nonatomic) NSArray *carTypeArray;


@property (nonatomic, assign) id<CarTypeViewControllerDelegate>delegate;

- (IBAction)cancelPressed:(id)sender;

@end


@protocol CarTypeViewControllerDelegate <NSObject>

- (void) carTypeViewControllerHasDone: (CarTypeViewController *) viewController;
- (void) carTypeSelected: (Car*)car  AtViewController:(CarTypeViewController *) viewController;

@end



