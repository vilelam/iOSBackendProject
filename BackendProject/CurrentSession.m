//
//  CurrentSession.m
//  BackendProject
//
//  Created by Marcos Vilela on 28/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "CurrentSession.h"

@implementation CurrentSession


#pragma mark - CurrentSessionInformation

+ (CurrentSession *)currentSessionInformation{
    
    CurrentSession *currentSession;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"CurrentSession.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *currentSessionPlistfile = [[NSDictionary alloc] initWithContentsOfFile:path];
        currentSession = [[CurrentSession alloc] init];
        currentSession.jsessionID = [currentSessionPlistfile objectForKey:@"jsessionid"];
    }
    return currentSession;
}


#pragma mark - PlistFile

+ (void) writeCurrentSessionInformationToPlistFile: (CurrentSession *)currentSession{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"CurrentSession.plist"];
    
    
    NSDictionary *currentSessionDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                              currentSession.jsessionID, @"jsessionid",
                                              nil];
    [currentSessionDictionary writeToFile:path atomically:YES];
}

@end
