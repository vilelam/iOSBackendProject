//
//  Helper.m
//  BackendProject
//
//  Created by Marcos Vilela on 23/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//



#import "Helper.h"


@implementation Helper

+(NSError *)createErrorForMEUserClass:(NSString *) message{
    NSMutableDictionary *errorDetails = [[NSMutableDictionary alloc] init];
    [errorDetails setValue:message forKey:@"error"];
    NSError  *error = [NSError errorWithDomain:@"MEUser" code:1 userInfo:errorDetails];
    return error;
}

+ (void)showErrorMEUserWithError:(NSError *)error{
    
    NSString *errorMessage = [[error userInfo] objectForKey:@"error"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
    
}

+(void)showErrorMEUserWithErrorString: (NSString *) errorMessage{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

+(void)showSuccessMEUser: (NSString *) message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:message  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}


#pragma mark Location object

+ (NSMutableDictionary *)createLocationDictionary:(NSString *)locationName politicalName:(NSString *)politicalName latitude:(double)latitude longitude:(double)longitude locationType:(NSString *)locationType{
    
    NSMutableDictionary *location = [[NSMutableDictionary alloc]init];
    
    [location setObject:locationName forKey:@"locationName"];
    [location setObject:politicalName forKey:@"politicalName"];
    [location setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [location setObject:[NSNumber numberWithDouble:longitude] forKey:@"longitude"];
    [location setObject:locationType forKey:@"locationType"];
    
    return location;
}

+ (Location *)createLocationObject:(NSMutableDictionary *)location{
    Location *object = [[Location alloc]init];
    object.locationName = [location objectForKey:@"locationName"];
    object.politicalName = [location objectForKey:@"politicalName"];
    object.latitude = [[location objectForKey:@"latitude"] doubleValue];
    object.longitude = [[location objectForKey:@"longitude"] doubleValue];
    object.locationType =[location objectForKey:@"locationType"];
    
    return object;
}


#pragma mark Car object
+ (Car *)createCarObject:(NSMutableDictionary *)car{
    Car *object = [[Car alloc]init];
    object.code = [car objectForKey:@"code"];
    object.description = [car objectForKey:@"description"];
    return object;
}

#pragma mark Radius object

+ (Radius *)createRadiusObject:(NSMutableDictionary *)radius{
    Radius *object = [[Radius alloc]init];
    object.code = [radius objectForKey:@"code"];
    object.description = [radius objectForKey:@"description"];
    return object;
}



#pragma mark ActiveStatus object

+ (ActiveStatus *)createActiveStatusObject:(NSMutableDictionary *)activeStatus{
    ActiveStatus *object = [[ActiveStatus alloc]init];
    object.code = [activeStatus objectForKey:@"code"];
    object.description = [activeStatus objectForKey:@"description"];
    return object;
}

@end
