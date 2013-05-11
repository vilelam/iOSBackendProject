//
//  MEUser.h
//  BackendProject
//
//  Created by Marcos Vilela on 17/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import "Helper.h"
#import "Car.h"
#import "CurrentSession.h"
#import "Location.h"
#import "ActiveStatus.h"


@interface MEUser : NSObject


@property (strong, nonatomic) NSString *userType; //driver or passenger
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *email;

//driver information
@property (strong, nonatomic) Location *servedLocation;
@property (strong, nonatomic) ActiveStatus *activeStatus;
@property (strong, nonatomic) Radius *radiusServed;
@property (strong, nonatomic) Car *carType;


//logIn methods


+(NSError *)signInWithUsername: (NSString *)username
                      Password: (NSString *)password
                    TenantName: (NSString *)tenantName
                          Type: (NSString *)type
                      UserType: (NSString **) userType;

+(NSError *)signUpWithUsername: (NSString *)username
                     Password: (NSString *)password
                   TenantName: (NSString *)tenantName
                        Email: (NSString *)email
                    FirstName: (NSString *)firstName
                     LastName: (NSString *)lastName
                  PhoneNumber: (NSString *)phoneNumber
                       Locale: (NSString *)locale;

+(NSError *)signUpWithDriverUsername: (NSString *)username
                            Password: (NSString *)password
                          TenantName: (NSString *)tenantName
                               Email: (NSString *)email
                           FirstName: (NSString *)firstName
                            LastName: (NSString *)lastName
                         PhoneNumber: (NSString *)phoneNumber
                              Locale: (NSString *)locale
                             CarType: (Car *)carType
                      ServedLocation: (Location *)location
                        ActiveStatus: (NSString *)activeStatus
                        RadiusServed: (Radius *)radiusServed;

+(void)retrieveLoggedUserDetails: (void (^)(MEUser *meUser, NSError* error))handler;

+(void)updateLoggedUserDetails:(MEUser *)user completionHandler: (void (^)(NSError* error, NSString *))handler;


@end
