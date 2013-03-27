//
//  Car.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"

@interface Car : NSObject

@property (strong,nonatomic) NSString *code;
@property (strong,nonatomic) NSString *description;


//retrieve a list of car types from the server
+(void)retrieverCarTypes: (void (^)(NSArray *carTypes, NSError* error))handler;

@end
