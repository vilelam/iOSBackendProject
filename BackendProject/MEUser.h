//
//  MEUser.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "ItemsHandler.h"
#import "Helper.h"

@interface MEUser : NSObject
    

@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *jsessionid;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *tenant;
@property (strong, nonatomic) NSString *type;
 



+(MEUser *) user;

//logIn methods

+(void)logInWithUsername:(NSString *)username
                    Password: (NSString *) password
                  TenantName: (NSString *)tenantName
                        Type: (NSString *) type
                        CompletionHandler: (void (^)(MEUser *meUser, NSError* error))handler;



@end
