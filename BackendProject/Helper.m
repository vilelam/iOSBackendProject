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

+(void)showErrorMEUser: (NSString *) error{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}









@end
