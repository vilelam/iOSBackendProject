//
//  MEUser.m
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "MEUser.h"

@implementation MEUser


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
        meUser.user = [MEUserplistfile objectForKey:@"user"];
        meUser.type = [MEUserplistfile objectForKey:@"type"];
        meUser.tenant = [MEUserplistfile objectForKey:@"tenant"];
        meUser.email = [MEUserplistfile objectForKey:@"email"];
    }
    
    return meUser;
}


+ (void)logInWithUsername:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Type:(NSString *)type CompletionHandler:(void (^)(MEUser *, NSError *))handler{
        
    NSError *error;
    
    NSMutableDictionary *authenticateDictionary = [[NSMutableDictionary alloc] init];
    
    [authenticateDictionary setObject:type forKey:@"type"];
    [authenticateDictionary setObject:tenantName forKey:@"tenantname"];
    [authenticateDictionary setObject:username forKey:@"username"];
    [authenticateDictionary setObject:password forKey:@"password"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:authenticateDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error == nil) {
        
        NSURL *url = [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/login/authenticateUser"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            MEUser *meUser;
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            NSLog(@"HTTP response status code: %i", httpResponse.statusCode);
            
            if ([data length] > 0 && error == nil){
                
                if (httpResponse.statusCode == 200) {
                    
                    //convert json data to NSDictionary
                    NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    
                    if (error == nil) {
                        
                        NSString *code = [returnedDictionary objectForKey:@"code"];
                        NSString *msg = [returnedDictionary objectForKey:@"msg"];
                        NSString *jsessionid = [returnedDictionary objectForKey:@"JSESSIONID"];
                        
                        if ([code isEqualToString:@"SUCCESS"]) {
                            
                            meUser = [[MEUser alloc] init];
                            meUser.user = username;
                            meUser.jsessionid = jsessionid;
                            meUser.tenant = tenantName;
                            meUser.type = type;
                            
                            [meUser writeUserLoginInformationToPlistFile];
                        
                        }else if ([code isEqualToString:@"ERROR"]){
                            error = [Helper createErrorForMEUserClass:msg];
                        }

                    }
                }else{
                    error = [Helper createErrorForMEUserClass:@"Unexpected error try again"];
                }
            }
            
            else if ([data length] == 0 && error == nil){
                //empty replay
            }
            
            else if (error != nil){
                error = [Helper createErrorForMEUserClass:error.localizedDescription];
            }

            handler(meUser, error);
        }];
    }
 
}


- (void) writeUserLoginInformationToPlistFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"MEUser.plist"];
    
    
    NSDictionary *userDetails = [[NSDictionary alloc] initWithObjectsAndKeys:self.jsessionid, @"jsessionid", self.user, @"user", self.email, @"email", self.tenant, @"tenant", self.type, @"type", nil];
    [userDetails writeToFile:path atomically:YES];
}


@end
