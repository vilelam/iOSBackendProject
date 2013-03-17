//
//  Created by Marcos Vilela on 24/01/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "UserHandler.h"

@implementation UserHandler

//+ (void)createNewUser:(NSString *)username Password:(NSString *)password Email:(NSString *)email Tenant:(NSString *)tenant{
//    
//    
//    NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
//    
//    //build an info object and convert to json
//    
//    NSMutableDictionary *firstLogonData = [[NSMutableDictionary alloc]init];
//    
//  //  [firstLogonData setObject:companyName forKey:@"companyname"];
//    [firstLogonData setObject:username forKey:@"username"];
//    [firstLogonData setObject:email forKey:@"email"];
//    [firstLogonData setObject:password forKey:@"password"];
//    
//    //convert object to data
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:firstLogonData options:NSJSONWritingPrettyPrinted error:error];
//    
//    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
//    
//    NSURL *url = [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/user/save"];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setHTTPBody:jsonData];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
//    
//    //Start your connection and handle any UI components you need to such as removing a loading view after the transaction is complete.
//    
//    NSHTTPURLResponse *response;
//    
//    NSError *URLConnectionError;
//    
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];
//    
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
//    
//    NSLog(@"Http returned code: %i", [httpResponse statusCode]);
//    
//    NSLog(@"error code: %i", *error.code);
//    
//    if ([data length] > 0 && error == nil){
//        
//        if ([httpResponse statusCode] >= 400) {
//            
//            if ([httpResponse statusCode] == 403) {
//                NSString *msg = [returnedData objectForKey:@"msg"];
//                NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
//                [details setValue:msg forKey:@"error"];
//                NSError *httpError = [NSError errorWithDomain:@"retrieveItemsByTypeAndRecency" code:1 userInfo:details];
//                [self.delegate downloadError:httpError];
//            }else{
//                NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
//                [details setValue:@"HTTP Error" forKey:@"error"];
//                NSError *httpError = [NSError errorWithDomain:@"retrieveItemsByTypeAndRecency" code:1 userInfo:details];
//                [self.delegate downloadError:httpError];
//            }
//        }else{
//            
//            
//            NSError *JSONSerializationError;
//            
//            //convert json data to NSDictionary
//            NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONSerializationError];
//            
//            //get an array of items from the returned dictionary
//            NSArray *items = [returnedDictionary objectForKey:@"items"];
//            
//            
//            //create a cache identification for this query
//            NSMutableDictionary *itemsDictionary = [[NSMutableDictionary alloc] init];
//            
//            [itemsDictionary setObject:items forKey:@"items"];
//            [itemsDictionary setObject:@"recency" forKey:@"orderedBy"];
//            [itemsDictionary setObject:[NSDate date] forKey:@"downloadDateAndTime"];
//            
//            [self.delegate receivedItems:items];
//        }
//    }
//    
//    else if ([data length] == 0 && error == nil){
//        [self.delegate emptyReply];
//    }
//    
//    else if (error != nil){
//        NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
//        [details setValue:[error description] forKey:@"error"];
//        NSError *error = [NSError errorWithDomain:@"retrieveItemsByTypeAndRecency" code:1 userInfo:details];
//        [self.delegate downloadError:error];
//        
//    }
//    
//
//
//}

//+ (void)authenticateWithUser:(NSString *)username Password:(NSString *)password TenantName:(NSString *)tenantName Type:(NSString *)type Error:(NSError **)error{
//    
//    //convert string to data
//    
//    NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
//    
//    NSMutableDictionary *authenticateDictionary = [[NSMutableDictionary alloc] init];
//    
//    [authenticateDictionary setObject:type forKey:@"type"];
//    [authenticateDictionary setObject:tenantName forKey:@"tenantname"];
//    [authenticateDictionary setObject:username forKey:@"username"];
//    [authenticateDictionary setObject:password forKey:@"password"];
//    
//    NSError *JSONSerializationError;
//    
//    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:authenticateDictionary options:NSJSONWritingPrettyPrinted error:&JSONSerializationError];
//    
//    NSURL *url = [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/login/authenticateUser"];
//    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
//    
//    [request setHTTPMethod:@"POST"];
//    
//    [request setHTTPBody:bodyData];
//    
//    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
//    
//    NSHTTPURLResponse *response;
//    
//    NSError *URLConnectionError;
//    
//    NSData *returnedJSONData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&URLConnectionError];
//    
//    if ([returnedJSONData length] > 0) {
//        int statusCode = response.statusCode;
//        if (statusCode < 400) {
//            NSError *JSONSerializationError;
//            NSDictionary *returnedData = [NSJSONSerialization JSONObjectWithData:returnedJSONData options:NSJSONWritingPrettyPrinted error:&JSONSerializationError];
//            NSString *code = [returnedData objectForKey:@"code"];
////            NSString *msg = [returnedData objectForKey:@"msg"];
//            NSString *JSESSIONID = [returnedData objectForKey:@"JSESSIONID"];
//            
//            if ([code isEqualToString:@"SUCCESS"]) {
//                [self writeUserLoginInformationToPlistFile:username JSESSIONID:JSESSIONID];
//            }else if([code isEqualToString:@"ERROR"]){
//                [details setValue:@"O usuário ou o password informado não é válido" forKey:@"error"];
//                *error = [NSError errorWithDomain:@"authenticateUser" code:1 userInfo:details];
//            }else{
//                [details setValue:@"Erro ao efetuar login tentar novamente" forKey:@"error"];
//                *error = [NSError errorWithDomain:@"authenticateUser" code:1 userInfo:details];
//                
//            }
//            
//        }
//        else{
//            [details setValue:@"Erro durante o processo de login" forKey:@"error"];
//            *error = [NSError errorWithDomain:@"authenticateUser" code:1 userInfo:details];
//        }
//    }
//    else{
//        [details setValue:[URLConnectionError localizedDescription] forKey:@"error"];
//        *error = [NSError errorWithDomain:@"authenticateUser" code:1 userInfo:details];
//    }
//}
//
//+(void) writeUserLoginInformationToPlistFile: (NSString *) username JSESSIONID: (NSString *)JSESSIONID {
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"AppConfiguration.plist"];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    if (![fileManager fileExistsAtPath: path])
//    {
//        NSError *filemanagerError;
//        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"AppConfiguration" ofType:@"plist"];
//        [fileManager copyItemAtPath:bundle toPath:path error:&filemanagerError];
//    }
//    
//    NSDictionary *appConfiguration = [[NSDictionary alloc] initWithObjectsAndKeys:JSESSIONID, @"JSESSIONID", username, @"USER",  nil];
//    
//    [appConfiguration writeToFile:path atomically:YES];
//
//}



@end
