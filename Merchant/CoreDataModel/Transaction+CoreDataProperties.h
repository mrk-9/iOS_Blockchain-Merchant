//
//  Transaction+CoreDataProperties.h
//  Merchant
//
//  Created by Alex on 6/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "Transaction+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Transaction (CoreDataProperties)

+ (NSFetchRequest<Transaction *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *total;
@property (nullable, nonatomic, copy) NSString *subtotal;
@property (nullable, nonatomic, copy) NSString *tip;
@property (nullable, nonatomic, copy) NSString *currency;
@property (nullable, nonatomic, copy) NSString *bitcoin;
@property (nullable, nonatomic, copy) NSString *senderWallet;
@property (nullable, nonatomic, copy) NSString *wallet;
@property (nullable, nonatomic, copy) NSString *type;
@property (nullable, nonatomic, copy) NSDate *date;

@end

NS_ASSUME_NONNULL_END
