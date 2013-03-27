//
//  RadiusViewController.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Radius.h"
#import "Helper.h"


@protocol RadiusViewControllerDelegate;

@interface RadiusViewController : UITableViewController


@property (strong, nonatomic) NSArray *radiusArray;


@property (nonatomic, assign) id<RadiusViewControllerDelegate>delegate;

- (IBAction)cancelPressed:(id)sender;

@end


@protocol RadiusViewControllerDelegate <NSObject>

- (void) radiusViewControllerHasDone: (RadiusViewController *) viewController;
- (void) radiusSelected: (Radius*)radius  AtViewController:(RadiusViewController *) viewController;

@end
