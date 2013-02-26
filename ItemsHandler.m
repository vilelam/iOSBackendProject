//
//  ItemsHandler.m
//  BackendProject
//
//  Created by Marcos Vilela on 11/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "ItemsHandler.h"


@implementation ItemsHandler

@synthesize delegate=_delegate;


- (void)retrieveItemsByTypeAndRecency:(NSString *)type{
    
    //body string content
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc] init];
    [requestDictionary setObject:type forKey:@"type"];
    
    NSError *JSONSerializationError;
    
    //convert body string content into JSON NSDATA
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:requestDictionary options:NSJSONWritingPrettyPrinted error:&JSONSerializationError];
    
    //service URL
    NSURL *url = [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/item/retrieveItemsByTypeAndRecency"];
    
    //create and configure the request object that will have the http package content
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
    
    //set method POST
    [request setHTTPMethod:@"POST"];
    
    //set body
    [request setHTTPBody:bodyData];
    
    //set http package content-type
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    //prepare the cookie string (JSESSION ID got from the authentica user step)
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@",[UserHandler currentJSESSIONID]];
    
    //set cookie
    [request addValue:cookie forHTTPHeaderField:@"Cookie"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse* response, NSData *data, NSError *error) {
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        NSLog(@"Http returned code: %i", [httpResponse statusCode]);
        
        NSLog(@"error code: %i", error.code);
        
        NSError *returnedDataNSJSONSerializationError;
        
        NSDictionary *returnedData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONWritingPrettyPrinted error:&returnedDataNSJSONSerializationError];
        
        if ([data length] > 0 && error == nil){
            
            if ([httpResponse statusCode] >= 400) {
                
                if ([httpResponse statusCode] == 403) {
                    NSString *msg = [returnedData objectForKey:@"msg"];
                    NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
                    [details setValue:msg forKey:@"error"];
                    NSError *httpError = [NSError errorWithDomain:@"retrieveItemsByTypeAndRecency" code:1 userInfo:details];
                    [self.delegate downloadError:httpError];
                }else{
                    NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
                    [details setValue:@"HTTP Error" forKey:@"error"];
                    NSError *httpError = [NSError errorWithDomain:@"retrieveItemsByTypeAndRecency" code:1 userInfo:details];
                    [self.delegate downloadError:httpError];
                }
            }else{
                
                
                NSError *JSONSerializationError;
                
                //convert json data to NSDictionary
                NSDictionary *returnedDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONSerializationError];
                
                //get an array of items from the returned dictionary
                NSArray *items = [returnedDictionary objectForKey:@"items"];
                
                
                //create a cache identification for this query
                NSMutableDictionary *itemsDictionary = [[NSMutableDictionary alloc] init];
                
                [itemsDictionary setObject:items forKey:@"items"];
                [itemsDictionary setObject:@"recency" forKey:@"orderedBy"];
                [itemsDictionary setObject:[NSDate date] forKey:@"downloadDateAndTime"];
                
                [self.delegate receivedItems:items];
            }
        }
        
        else if ([data length] == 0 && error == nil){
            [self.delegate emptyReply];
        }
        
        else if (error != nil){
                NSMutableDictionary *details = [[NSMutableDictionary alloc] init];
                [details setValue:[error description] forKey:@"error"];
                NSError *error = [NSError errorWithDomain:@"retrieveItemsByTypeAndRecency" code:1 userInfo:details];
                [self.delegate downloadError:error];
                            
        }
        
    }];
    
}




@end
