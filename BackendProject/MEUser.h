//
//  MEUser.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

//#import "ItemsHandler.h"
#import "Helper.h"

@interface MEUser : NSObject
    

@property (strong, nonatomic) NSString *userType; //"driver" or "passenger"
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *jsessionid;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *tenant;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phoneNumber;



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

@end
