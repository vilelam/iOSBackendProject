//
//  Location.h
//  BackendProject
//
//  Created by Marcos Vilela on 07/04/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helper.h"

@interface Location : NSObject

@property (strong,nonatomic) NSString *locationName;
@property (strong,nonatomic) NSString *politicalName;
@property  double latitude;
@property double longitude;
@property (strong, nonatomic) NSString *locationType;


+ (void) searchLocations:(NSString*)enteredLocation completionHandler:(void (^)(NSError* error, NSArray *))handler;





@end
