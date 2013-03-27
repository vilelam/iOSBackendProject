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




#import "MEUser.h"

@implementation MEUser

#pragma mark - user

+ (MEUser *)user{
    
    MEUser *meUser;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MEUser.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *MEUserplistfile = [[NSDictionary alloc] initWithContentsOfFile:path];
        meUser = [[MEUser alloc] init];
        meUser.jsessionid = [MEUserplistfile objectForKey:@"jsessionid"];
    }    
    return meUser;
}

#pragma mark - SignIn

+ (MEUser *)signInWithUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Type:(NSString *)type{
    
    MEUser *meUser;
    
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
                    
                    NSLog(@"%@",message);
                    
                    if ([code isEqualToString:@"SUCCESS"]) {
                        
                        meUser = [[MEUser alloc] init];
                        meUser.jsessionid = jsessionid;

                        [meUser writeUserLoginInformationToPlistFile];
                        
                    }else if ([code isEqualToString:@"ERROR"]){
                        if ([type isEqualToString:@"USER"]) {
                            [Helper showErrorMEUser:message];
                        }
                        else{
                            [Helper showErrorMEUser:[NSString stringWithFormat:@"Unexpected error. Please try again."]];
                        }
                    }
                    
                }
            }else{
                [Helper showErrorMEUser:[NSString stringWithFormat:@"Unexpected error. Please try again."]];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            [Helper showErrorMEUser:error.localizedDescription];
        }
    }
    return meUser;
}

#pragma mark - SignUp

+ (MEUser *)signUpWithUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Email:(NSString *)email FirstName:(NSString *)firstName LastName:(NSString *)lastName PhoneNumber:(NSString *)phoneNumber Locale:(NSString *)locale{
    

    MEUser *meUser;
    
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
                        
                        meUser = [MEUser signInWithUsername:username Password:password TenantName:@"WorldTaxi" Type:@"self"];
                        
                    }else if ([code isEqualToString:@"ERROR"]){
                        if ([type isEqualToString:@"USER"]) {
                            [Helper showErrorMEUser:message];
                        }
                        else{
                            [Helper showErrorMEUser:[NSString stringWithFormat:@"Unexpected error. Please try again."]];
                        }
                    }
                    
                }
            }else{
                [Helper showErrorMEUser:[NSString stringWithFormat:@"Unexpected error. Please try again."]];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            [Helper showErrorMEUser:error.localizedDescription];
        }
    }

    return meUser;
}

+ (MEUser *)signUpWithDriverUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Email:(NSString *)email FirstName:(NSString *)firstName LastName:(NSString *)lastName PhoneNumber:(NSString *)phoneNumber Locale:(NSString *)locale CarType:(NSString *)carType ServedMetro:(NSString *)servedMetro ActiveStatus:(NSString *)activeStatus{
    
    MEUser *meUser;
    
    NSError *error;
    
    NSMutableDictionary *driverExtraInformation = [[NSMutableDictionary alloc] init];
    
    [driverExtraInformation setObject:carType forKey:@"carType"];
    [driverExtraInformation setObject:servedMetro forKey:@"servedMetro"];
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
                        
                        meUser = [MEUser signInWithUsername:username Password:password TenantName:@"WorldTaxi" Type:@"self"];
                        
                    }else if ([code isEqualToString:@"ERROR"]){
                        if ([type isEqualToString:@"USER"]) {
                            [Helper showErrorMEUser:message];
                        }
                        else{
                            [Helper showErrorMEUser:[NSString stringWithFormat:@"Unexpected error. Please try again."]];
                        }
                    }
                    
                }
            }else{
                [Helper showErrorMEUser:[NSString stringWithFormat:@"Unexpected error. Please try again."]];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            //empty replay
        }
        else if (error != nil){
            [Helper showErrorMEUser:error.localizedDescription];
        }
    }
    
    return meUser;
    
}

#pragma mark - loggedUser Details

+(void)retrieveLoggedUserDetails:(void (^)(MEUser *, NSError *))handler{
        
    NSError *error;
    
    NSMutableDictionary *retrieveLoggedUserDetails = [[NSMutableDictionary alloc] init];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:retrieveLoggedUserDetails options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@", [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding]);
    
    if (error == nil) {
        
        NSURL *url = loggedUserDetails;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSString *jsessiond = [MEUser user].jsessionid;
        
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
                        
                        if ([user objectForKey:@"driver"]) {
                            
                            //to-do 
                            //buscar informações do driver....
                            

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

#pragma mark - PlistFile

- (void) writeUserLoginInformationToPlistFile{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MEUser.plist"];
    
    
    NSDictionary *userDetails = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 self.jsessionid, @"jsessionid",
                                 nil];
    [userDetails writeToFile:path atomically:YES];
}


@end
