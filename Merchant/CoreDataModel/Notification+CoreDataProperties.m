//
//  Notification+CoreDataProperties.m
//  Merchant
//
//  Created by Alex on 6/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "Notification+CoreDataProperties.h"

@implementation Notification (CoreDataProperties)

+ (NSFetchRequest<Notification *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Notification"];
}

@dynamic title;
@dynamic date;

@end
