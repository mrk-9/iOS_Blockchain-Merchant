//
//  DataManager.h
//  Merchant
//
//  Created by Alex on 6/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface DataManager : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSManagedObjectContext *context;

-(void)saveTransaction:(NSDictionary*)dic;
-(NSArray*)getTransaction;
-(void)saveNotification:(NSDictionary*)dic;
-(NSArray*)getNotifications;

- (instancetype)init;

@end
