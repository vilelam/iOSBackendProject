//
//  TaxiStandAddressViewController.h
//  BackendProject
//
//  Created by Marcos Vilela on 06/04/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "Helper.h"


@protocol LocationViewControllerDelegate;

@interface LocationViewController : UIViewController <UISearchBarDelegate>


@property (strong, nonatomic) NSArray *zeroLocations;
@property (strong,nonatomic) NSArray *searchedLocations;
@property (strong,nonatomic) NSMutableArray *bookmark;

@property (strong, nonatomic) id<LocationViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
- (IBAction)cancelPressed:(id)sender;


@end


@protocol LocationViewControllerDelegate <NSObject>

-(void) locationViewControllerCancelled:(LocationViewController *) viewController;
-(void) locationSelected:(Location *) location atViewControler:(LocationViewController *) viewController;


@end