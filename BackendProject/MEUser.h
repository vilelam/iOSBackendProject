//
//  MEUser.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "Helper.h"
#import "Car.h"

@interface MEUser : NSObject
    
//Session info
@property (strong, nonatomic) NSString *jsessionid;


@property (strong, nonatomic) NSString *userType; //driver or passenger
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;




+(MEUser *) user;

//logIn methods


+(MEUser *)signInWithUsername: (NSString *)username
                     Password: (NSString *)password
                   TenantName: (NSString *)tenantName
                         Type: (NSString *)type;

+(MEUser *)signUpWithUsername: (NSString *)username
                     Password: (NSString *)password
                   TenantName: (NSString *)tenantName
                        Email: (NSString *)email
                    FirstName: (NSString *)firstName
                     LastName: (NSString *)lastName
                  PhoneNumber: (NSString *)phoneNumber
                       Locale: (NSString *)locale;

+(MEUser *)signUpWithDriverUsername: (NSString *)username
                           Password: (NSString *)password
                         TenantName: (NSString *)tenantName
                              Email: (NSString *)email
                          FirstName: (NSString *)firstName
                           LastName: (NSString *)lastName
                        PhoneNumber: (NSString *)phoneNumber
                             Locale: (NSString *)locale
                            CarType: (NSString *)carType
                        ServedMetro: (NSString *)servedMetro
                       ActiveStatus: (NSString *)activeStatus;

+(void)retrieveLoggedUserDetails: (void (^)(MEUser *meUser, NSError* error))handler;

@end
