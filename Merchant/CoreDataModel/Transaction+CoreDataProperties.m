//
//  Transaction+CoreDataProperties.m
//  Merchant
//
//  Created by Alex on 6/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "Transaction+CoreDataProperties.h"

@implementation Transaction (CoreDataProperties)

+ (NSFetchRequest<Transaction *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Transaction"];
}

@dynamic total;
@dynamic subtotal;
@dynamic tip;
@dynamic currency;
@dynamic bitcoin;
@dynamic senderWallet;
@dynamic wallet;
@dynamic type;
@dynamic date;

@end
