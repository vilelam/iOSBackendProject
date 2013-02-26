//
//  FirstViewController.m
//  BackendProject
//
//  Created by Marcos Vilela on 23/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
    self.jsessionid.text = [MEUser user].jsessionid;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
