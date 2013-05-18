//
//  Location.m
//  BackendProject
//
//  Created by Marcos Vilela on 07/04/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "Location.h"
#define locationSearchURL [NSURL URLWithString:@"http://ec2-54-235-108-25.compute-1.amazonaws.com:8080/moovt/location/search"]



@implementation Location



+ (void)searchLocations:(NSString *)enteredLocation completionHandler:(void (^)(NSError *, NSArray *))handler{
    
    NSError *error;
    
    NSMutableDictionary *locationSearchDictionary = [[NSMutableDictionary alloc] init];
    
    [locationSearchDictionary setObject:enteredLocation forKey:@"location"];
    
    NSData *bodyData = [NSJSONSerialization dataWithJSONObject:locationSearchDictionary options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error == nil) {
        
        NSURL *url = locationSearchURL;
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
        
        [request setHTTPMethod:@"POST"];
        
        [request setHTTPBody:bodyData];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
        
        //to-do
        //adicionar security para o serviço de location search
        //NSString *jsessiond = [CurrentSession currentSessionInformation].jsessionID;
        //[request setValue:[NSString stringWithFormat:@"JSESSIONID=%@",jsessiond] forHTTPHeaderField:@"Cookie"];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            NSMutableArray *locations;
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            
            if ([data length] > 0 && error == nil){
                
                NSLog(@"Http response status code: %i",httpResponse.statusCode);
                
                if (httpResponse.statusCode == 200) {
                    
                    //convert json data to NSDictionary
                    NSDictionary *returnedContent = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                    
                    if (error == nil) {
                        
                        
                        //to-do
                        //implementar tratamento do erro retornado
                        
                        NSArray *locationsContent = [returnedContent objectForKey:@"locations"];
                        
                        locations = [[NSMutableArray alloc] init];
                        
                        for (id location in locationsContent) {
                            NSDictionary *dictionaryLocation = (NSDictionary *) location;
                            Location *tempLocation = [[Location alloc] init];
                            tempLocation.locationName = [dictionaryLocation objectForKey:@"locationName"];
                            NSLog(@"location Name: %@", tempLocation.locationName);
                            tempLocation.politicalName = [dictionaryLocation objectForKey:@"politicalName"];
                            tempLocation.latitude = [[dictionaryLocation objectForKey:@"latitude"] doubleValue];
                            tempLocation.longitude = [[dictionaryLocation objectForKey:@"longitude"] doubleValue];
                            tempLocation.locationType = [dictionaryLocation objectForKey:@"locationType"];
                            [locations addObject:tempLocation];
                            
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
            
            handler(error, locations);
            
        }];
        
    }
    
}

@end
