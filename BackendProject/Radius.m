//
//  Radius.m
//  BackendProject
//
//  Created by Marcos Vilela on 26/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#define radiusURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/driver/getRadiusServedEnum"]

#import "Radius.h"

@implementation Radius


+ (void)retrieverRadiusServed:(void (^)(NSArray *, NSError *))handler{
    
    NSURL *url = radiusURL;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSMutableArray *radiusArray;
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        
        if ([data length] > 0 && error == nil){
            
            NSLog(@"Http response status code: %i",httpResponse.statusCode);
            
            if (httpResponse.statusCode == 200) {
                
                //convert json data to NSDictionary
                NSArray *returnedArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                if (error == nil) {
                    
                    radiusArray = [[NSMutableArray alloc] init];
                    
                    for (NSDictionary *dictionary in returnedArray) {
                        Radius* radius = [[Radius alloc]init];
                        radius.code = [dictionary objectForKey:@"code"];
                        radius.description = [dictionary objectForKey:@"description"];
                        [radiusArray addObject:radius];
                    }
                    
                }
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
        handler(radiusArray,error);
    }];
    
}



@end
