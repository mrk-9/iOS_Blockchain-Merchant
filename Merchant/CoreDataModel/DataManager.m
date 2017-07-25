//
//  DataManager.m
//  Merchant
//
//  Created by Alex on 6/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize context;

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self managedObjectContext];
    }
    
    return self;
}

- (void)managedObjectContext
{
    context = nil;
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
}

-(void)saveTransaction:(NSDictionary*)dic {
    Transaction *entityDict=(Transaction*)[NSEntityDescription insertNewObjectForEntityForName:@"Transaction" inManagedObjectContext:context];
    [entityDict setValue:[dic objectForKey:KEY_SUBTOTAL] forKey:KEY_SUBTOTAL];
    [entityDict setValue:[dic objectForKey:KEY_TIP] forKey:KEY_TIP];
    [entityDict setValue:[dic objectForKey:KEY_TOTAL] forKey:KEY_TOTAL];
    [entityDict setValue:[dic objectForKey:KEY_BTC] forKey:KEY_BTC];
    [entityDict setValue:[dic objectForKey:KEY_CURRENCY] forKey:KEY_CURRENCY];
    [entityDict setValue:[dic objectForKey:KEY_TYPE] forKey:KEY_TYPE];
    [entityDict setValue:[dic objectForKey:KEY_DATE] forKey:KEY_DATE];
    [entityDict setValue:[dic objectForKey:KEY_SENDER] forKey:KEY_SENDER];
    [entityDict setValue:[dic objectForKey:KEY_WALLET] forKey:KEY_WALLET];
    
    NSError *error;
    [context save:&error];
    if(error)
    {
        NSLog(@"error description is : %@",error.localizedDescription);
    }
    else{
        NSLog(@"Saved");
        
    }
}

-(NSArray*)getTransaction {
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Transaction" inManagedObjectContext:context];
    [request setEntity:entity];
    NSArray *fetchArray=  [context executeFetchRequest:request error:nil];
    for (Transaction *obj in fetchArray) {
        NSLog(@"Dict is : %@",obj);
    }
    
    return fetchArray;
}

-(void)saveNotification:(NSDictionary*)dic {
    Notification *entityDict=(Notification*)[NSEntityDescription insertNewObjectForEntityForName:@"Notification" inManagedObjectContext:context];
    [entityDict setValue:[dic objectForKey:KEY_TITLE] forKey:KEY_TITLE];
    [entityDict setValue:[dic objectForKey:KEY_DATE] forKey:KEY_DATE];
    
    NSError *error;
    [context save:&error];
    if(error)
    {
        NSLog(@"error description is : %@",error.localizedDescription);
    }
    else{
        NSLog(@"Saved");
        
    }
}

-(NSArray*)getNotifications {
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Notification" inManagedObjectContext:context];
    [request setEntity:entity];
    NSArray *fetchArray=  [context executeFetchRequest:request error:nil];
//    for (Notification *obj in fetchArray) {
//        NSLog(@"Dict is : %@",obj);
//    }
    
    return fetchArray;
}

@end
