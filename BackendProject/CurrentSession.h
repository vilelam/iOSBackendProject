//
//  CurrentSession.h
//  BackendProject
//
//  Created by Marcos Vilela on 28/03/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentSession : NSObject

@property (strong,nonatomic) NSString *jsessionID;
@property (strong, nonatomic) NSDate *signInDate;



+ (CurrentSession *)currentSessionInformation;
+ (void) writeCurrentSessionInformationToPlistFile: (CurrentSession *)currentSession;

@end
