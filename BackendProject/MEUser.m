//
//  MEUser.m
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#define loggedUserDetails [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/user/retrieveLoggedUserDetails"]
#define signInURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/login/authenticateUser"]
#define signUpURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/user/createUser"]
#define updateLoggedUserURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/user/updateLoggedUser"]




#import "MEUser.h"

@implementation MEUser



#pragma mark - SignIn

+ (NSError *)signInWithUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Type:(NSString *)type UserType:(NSString *__autoreleasing *) userType{
    
    NSError *error;
    
    
    
    NSMutableDictionary *authenticateDictionary = [[NSMutableDictionary alloc] init];
    
    [authenticateDictionary setObject:type forKey:@"type"];
    [authenticateDictionary setObject:tenantName forKey:@"tenantname"];
    [authenticateDictionary setObject:username forKey:@"username"];
    [authenticateDictionary setObject:password forKey:@"password"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:authenticateDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error == nil) {
        
        NSURL *url = signInURL;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSURLResponse *response;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([data length] > 0 && error == nil){
            
            if (httpResponse.statusCode == 200) {
                
                //convert json data to NSDictionary
                NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error == nil) {
                    
                    NSString *code = [returnedDictionary objectForKey:@"code"];
                    NSString *message = [returnedDictionary objectForKey:@"message"];
                    NSString *jsessionid = [returnedDictionary objectForKey:@"JSESSIONID"];
                    NSString *type = [returnedDictionary objectForKey:@"type"];
                    NSString *returnedUserType = [returnedDictionary objectForKey:@"userType"];
                    
                    NSLog(@"%@",message);
                    
                    if ([code isEqualToString:@"SUCCESS"]) {
                        CurrentSession *currentSession = [[CurrentSession alloc] init];
                        currentSession.jsessionID = jsessionid;
                        *userType = returnedUserType;
                        [CurrentSession writeCurrentSessionInformationToPlistFile:currentSession];
                        
                    }else if ([code isEqualToString:@"ERROR"]){
                        if ([type isEqualToString:@"USER"]) {
                            error = [Helper createErrorForMEUserClass:message];
                        }
                        else{
                            error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
                        }
                    }
                    
                }
            }else{
                error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            error = [Helper createErrorForMEUserClass:error.localizedDescription];
        }
    }
    return error;
}

#pragma mark - SignUp

+ (NSError *)signUpWithUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Email:(NSString *)email FirstName:(NSString *)firstName LastName:(NSString *)lastName PhoneNumber:(NSString *)phoneNumber Locale:(NSString *)locale{
    
    
    NSError *error;
    
    NSMutableDictionary *passengerSignUpDictionary = [[NSMutableDictionary alloc] init];
    
    [passengerSignUpDictionary setObject:tenantName forKey:@"tenantname"];
    [passengerSignUpDictionary setObject:email forKey:@"email"];
    [passengerSignUpDictionary setObject:username forKey:@"username"];
    [passengerSignUpDictionary setObject:password forKey:@"password"];
    [passengerSignUpDictionary setObject:firstName forKey:@"firstName"];
    [passengerSignUpDictionary setObject:lastName forKey:@"lastName"];
    [passengerSignUpDictionary setObject:phoneNumber forKey:@"phone"];
    [passengerSignUpDictionary setObject:locale forKey:@"locale"];
   
    //to-do
    NSMutableDictionary *passengerExtraInformation = [[NSMutableDictionary alloc] init];
    [passengerSignUpDictionary setObject:passengerExtraInformation forKey:@"passenger"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:passengerSignUpDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error == nil) {
        
        NSURL *url = signUpURL;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSURLResponse *response;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([data length] > 0 && error == nil){
            
            if (httpResponse.statusCode == 200) {
                
                //convert json data to NSDictionary
                NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error == nil) {
                    
                    NSString *code = [returnedDictionary objectForKey:@"code"];
                    NSString *message = [returnedDictionary objectForKey:@"message"];
                    NSString *type = [returnedDictionary objectForKey:@"type"];
                    
                    NSLog(@"%@",message);
                    
                    if ([code isEqualToString:@"SUCCESS"]) {
                        
                        //to-do
                        //remove the signIn method from here
                        NSString *returnedUser;
                        error = [MEUser signInWithUsername:username Password:password TenantName:@"WorldTaxi" Type:@"self" UserType:&returnedUser];
                        
                        
                    }else if ([code isEqualToString:@"ERROR"]){
                        if ([type isEqualToString:@"USER"]) {
                            error = [Helper createErrorForMEUserClass:message];
                        }
                        else{
                            error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
                        }
                    }
                    
                }
            }else{
                error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            error = [Helper createErrorForMEUserClass:error.localizedDescription];
        }
    }else{
        error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
    }

    return error;
}

+ (NSError *)signUpWithDriverUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Email:(NSString *)email FirstName:(NSString *)firstName LastName:(NSString *)lastName PhoneNumber:(NSString *)phoneNumber Locale:(NSString *)locale CarType:(Car *)carType ServedLocation:(Location *)location ActiveStatus:(NSString *)activeStatus RadiusServed:(Radius *)radiusServed{
    
    
    NSError *error;
    
    NSMutableDictionary *driverExtraInformation = [[NSMutableDictionary alloc] init];
    
    [driverExtraInformation setObject:carType.code forKey:@"carType"];
    
    NSMutableDictionary *servedLocation = [Helper createLocationDictionary:location.locationName politicalName:location.politicalName latitude:location.latitude longitude:location.longitude locationType:location.locationType];
  
    [driverExtraInformation setObject:servedLocation forKey:@"servedLocation"];
    
    [driverExtraInformation setObject:activeStatus forKey:@"activeStatus"];
    
    
    NSMutableDictionary *driverSignUpDictionary = [[NSMutableDictionary alloc] init];
    
    [driverSignUpDictionary setObject:tenantName forKey:@"tenantname"];
    [driverSignUpDictionary setObject:email forKey:@"email"];
    [driverSignUpDictionary setObject:username forKey:@"username"];
    [driverSignUpDictionary setObject:password forKey:@"password"];
    [driverSignUpDictionary setObject:firstName forKey:@"firstName"];
    [driverSignUpDictionary setObject:lastName forKey:@"lastName"];
    [driverSignUpDictionary setObject:phoneNumber forKey:@"phone"];
    [driverSignUpDictionary setObject:locale forKey:@"locale"];
    [driverSignUpDictionary setObject:driverExtraInformation forKey:@"driver"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:driverSignUpDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    
    if (error == nil) {
        
        NSURL *url = signUpURL;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSURLResponse *response;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([data length] > 0 && error == nil){
            
            if (httpResponse.statusCode == 200) {
                
                //convert json data to NSDictionary
                NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                
                if (error == nil) {
                    
                    NSString *code = [returnedDictionary objectForKey:@"code"];
                    NSString *message = [returnedDictionary objectForKey:@"message"];
                    NSString *type = [returnedDictionary objectForKey:@"type"];
                    
                    NSLog(@"%@",message);
                    
                    if ([code isEqualToString:@"SUCCESS"]) {
                        
                        //to-do
                        //remove signIn from here
                        NSString *returnedUserType;
                        error = [MEUser signInWithUsername:username Password:password TenantName:@"WorldTaxi" Type:@"self" UserType:&returnedUserType];
                        
                    }else if ([code isEqualToString:@"ERROR"]){
                        if ([type isEqualToString:@"USER"]) {
                            error = [Helper createErrorForMEUserClass:message];
                        }
                        else{
                            error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
                            
                        }
                    }
                    
                }
            }else{
                error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            error = [Helper createErrorForMEUserClass:error.localizedDescription];
        }
    }else{
        error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
    }
    
    return error;
    
}

#pragma mark - loggedUser Details

+(void)retrieveLoggedUserDetails:(void (^)(MEUser *, NSError *))handler{
        
    NSError *error;
    
    NSMutableDictionary *retrieveLoggedUserDetails = [[NSMutableDictionary alloc] init];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:retrieveLoggedUserDetails options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error == nil) {
        
        NSURL *url = loggedUserDetails;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSString *jsessiond = [CurrentSession currentSessionInformation].jsessionID;
        
        [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jsessiond] forHTTPHeaderField:@"Cookie"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            MEUser *meUser;
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            if ([data length] > 0 && error == nil){
                
                NSLog(@"Http response status code: %i",httpResponse.statusCode);
                
                if (httpResponse.statusCode == 200) {
                    
                    //convert json data to NSDictionary
                    NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    
                    if (error == nil) {
                    
                        meUser  = [[MEUser alloc] init];
                        
                        NSDictionary *user = [returnedDictionary objectForKey:@"user"];
                        
                        meUser.userId = [user objectForKey:@"id"];
                        meUser.version = [user objectForKey:@"version"];
                        meUser.username = [user objectForKey:@"username"];
                        meUser.firstName = [user objectForKey:@"firstName"];
                        meUser.lastName = [user objectForKey:@"lastName"];
                        meUser.phone = [user objectForKey:@"phone"];
                        meUser.email = [user objectForKey:@"email"];
                        id driver = [user objectForKey:@"driver"];
                        if (driver) {
                            meUser.userType = @"driver";
                            //to-do
                            //buscar informações do driver....
                            
                            NSDictionary *driverExtraInformation = driver;
                            
                            //servedLocation
                            NSMutableDictionary *driverServedLocation = [driverExtraInformation objectForKey:@"servedLocation"];
                            meUser.servedLocation = [Helper createLocationObject:driverServedLocation];
                            
                            
                            //activeStatus
                            NSMutableDictionary *activeStatus = [driverExtraInformation objectForKey:@"activeStatus"];
                            meUser.activeStatus = [Helper createActiveStatusObject:activeStatus];
                   
                            
                            
                            //carType
                            NSMutableDictionary *carType = [driverExtraInformation objectForKey:@"carType"];
                            meUser.carType = [Helper createCarObject:carType];

                        }
                        else{
                            meUser.userType = @"passenger";
                        }
                        NSLog(@"Returned String: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                    }
                    
                }
                else if (httpResponse.statusCode == 403){
                    
                    // to-do
                    ///Implementar código em caso de Unauthorized access
                    ///
                    
                    error = [Helper createErrorForMEUserClass:@"Unauthorized access."];
                    
                    
                }
                else{
                    error = [Helper createErrorForMEUserClass:@"Unexpected error."];
                }
            }else if ([data length] == 0 && error == nil){
                //empty replay
            }
            else if (error != nil){
                error = [Helper createErrorForMEUserClass:error.localizedDescription];
            }
            
            handler(meUser,error);
            
        }];
        
    }

}

#pragma mark - update loogedUser

+(void)updateLoggedUserDetails:(MEUser *)user completionHandler:(void (^)(NSError *, NSString *))handler{
    
    NSError *error;
    
    NSMutableDictionary *updateLoggedUser = [[NSMutableDictionary alloc] init];
    
    [updateLoggedUser setObject:user.version forKey:@"version"];
    [updateLoggedUser setObject:user.firstName forKey:@"firstName"];
    [updateLoggedUser setObject:user.lastName forKey:@"lastName"];
    [updateLoggedUser setObject:user.phone forKey:@"phone"];
    [updateLoggedUser setObject:user.username forKey:@"username"];

//    [updateLoggedUser setObject:user.version forKey:@"password"];

    [updateLoggedUser setObject:user.email forKey:@"email"];

//    [updateLoggedUser setObject:user.version forKey:@"locale"];
    
    if ([user.userType isEqualToString:@"driver"]) {
     
        NSMutableDictionary *driverInfo = [[NSMutableDictionary alloc] init];
        
        [driverInfo setObject:user.carType.code forKey:@"carType"];
        
        NSMutableDictionary *servedLocation = [Helper createLocationDictionary:user.servedLocation.locationName politicalName:user.servedLocation.politicalName latitude:user.servedLocation.latitude longitude:user.servedLocation.longitude locationType:user.servedLocation.locationType];
        
        [driverInfo setObject:servedLocation forKey:@"servedLocation"];
        
        [driverInfo setObject:user.activeStatus.code forKey:@"activeStatus"];
        
        [updateLoggedUser setObject:driverInfo forKey:@"driver"];
    }
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:updateLoggedUser options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    
    if (error == nil) {
        
        NSURL *url = updateLoggedUserURL;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSString *jsessiond = [CurrentSession currentSessionInformation].jsessionID;
        
        [request setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jsessiond] forHTTPHeaderField:@"Cookie"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            NSString *successMessage;
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            if ([data length] > 0 && error == nil){
                
                NSLog(@"Http response status code: %i",httpResponse.statusCode);
                
                if (httpResponse.statusCode == 200) {
                    
                    //convert json data to NSDictionary
                    NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    
                    if (error == nil) {
                        
                        NSString *code = [returnedDictionary objectForKey:@"code"];
                        NSString *message = [returnedDictionary objectForKey:@"message"];
                        NSString *type = [returnedDictionary objectForKey:@"type"];
                        
                        NSLog(@"%@",message);
                        
                        if ([code isEqualToString:@"SUCCESS"]) {
                            successMessage = [[NSString alloc] init];
                            successMessage = message;
                            
                        }else if ([code isEqualToString:@"ERROR"]){
                            if ([type isEqualToString:@"USER"]) {
                                error = [Helper createErrorForMEUserClass:message];
                            }
                            else{
                                error = [Helper createErrorForMEUserClass:@"Unexpected error. Please try again."];
                            }
                        }
                    }
                    
                }
                else if (httpResponse.statusCode == 403){
                    
                    // to-do
                    ///Implementar código em caso de Unauthorized access
                    ///
                    
                    error = [Helper createErrorForMEUserClass:@"Unauthorized access."];
                    
                    
                }
                else{
                    error = [Helper createErrorForMEUserClass:@"Unexpected error."];
                }
            }else if ([data length] == 0 && error == nil){
                //empty replay
            }
            else if (error != nil){
                error = [Helper createErrorForMEUserClass:error.localizedDescription];
            }
            
            handler(error,successMessage);
            
        }];
        
    }
    
}




@end
