//
//  InitViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 22/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "InitPassengerViewController.h"

@interface InitPassengerViewController ()

@end

@implementation InitPassengerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Passenger"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
