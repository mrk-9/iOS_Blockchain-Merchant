//
//  Payment.h
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payment : NSObject

@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) NSString *subtotal;
@property (nonatomic, strong) NSString *tip;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *bitcoin;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *senderWallet;
@property (nonatomic, strong) NSString *wallet;
@property (nonatomic, strong) NSDate *date;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
