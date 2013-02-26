//
//  ItemsHandler.h
//  BackendProject
//
//  Created by Marcos Vilela on 11/02/13.
//  Copyright (c) 2013 Marcos Vilela. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserHandler.h"

@protocol ItemsHandlerDelegate <NSObject>


- (void) receivedItems:(NSArray *)items;
- (void) emptyReply;
- (void) downloadError:(NSError*)error;

@end

@interface ItemsHandler : NSObject <NSURLConnectionDelegate>

@property (nonatomic, assign) id<ItemsHandlerDelegate>delegate;

- (void) retrieveItemsByTypeAndRecency: (NSString*) type;

@end

