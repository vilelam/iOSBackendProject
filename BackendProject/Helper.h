//
//  Helper.h
//  BackendProject
//
//  Created by Marcos Vilela on 23/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "Car.h"
#import "ActiveStatus.h"


@class Car;
@class Radius;
@class Location;

@interface Helper : NSObject

+(NSError *)createErrorForMEUserClass:(NSString *) message;

+(void)showErrorMEUserWithErrorString: (NSString *) errorMessage;

+(void)showErrorMEUserWithError: (NSError *) error;

+(void)showSuccessMEUser: (NSString *) message;

+(NSMutableDictionary *) createLocationDictionary: (NSString *) locationName
                                    politicalName: (NSString *) politicalName
                                         latitude: (double) latitude
                                        longitude: (double) longitude
                                     locationType: (NSString *) locationType;


+(Car *) createCarObject:(NSMutableDictionary *) car;

+(Location *) createLocationObject: (NSMutableDictionary *) location;

+(ActiveStatus *) createActiveStatusObject:(NSMutableDictionary *) activeStatus;



+ (BOOL)validateEmail:(NSString*)email;

+ (BOOL) checkIfThereAreWhiteSpace:(NSString *)string;

@end
