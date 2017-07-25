//
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "Payment.h"

@implementation Payment

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.total forKey:KEY_TOTAL];
    [aCoder encodeObject:self.subtotal forKey:KEY_SUBTOTAL];
    [aCoder encodeObject:self.tip forKey:KEY_TIP];
    [aCoder encodeObject:self.currency forKey:KEY_CURRENCY];
    [aCoder encodeObject:self.bitcoin forKey:KEY_BTC];
    [aCoder encodeObject:self.type forKey:KEY_TYPE];
    [aCoder encodeObject:self.wallet forKey:KEY_WALLET];
    [aCoder encodeObject:self.senderWallet forKey:KEY_SENDER];
    [aCoder encodeObject:self.date forKey:KEY_DATE];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.total = [aDecoder decodeObjectForKey:KEY_TOTAL];
        self.subtotal = [aDecoder decodeObjectForKey:KEY_SUBTOTAL];
        self.tip = [aDecoder decodeObjectForKey:KEY_TIP];
        self.currency = [aDecoder decodeObjectForKey:KEY_CURRENCY];
        self.bitcoin = [aDecoder decodeObjectForKey:KEY_BTC];
        self.type = [aDecoder decodeObjectForKey:KEY_TYPE];
        self.wallet = [aDecoder decodeObjectForKey:KEY_WALLET];
        self.senderWallet = [aDecoder decodeObjectForKey:KEY_SENDER];
        self.date = [aDecoder decodeObjectForKey:KEY_DATE];
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self)
    {
        [self initPaymentData:dict];
    }
    return self;
}

- (void)initPaymentData:(NSDictionary *)dict {
    self.total = [dict objectForKey:KEY_TOTAL];
    self.subtotal = [dict objectForKey:KEY_SUBTOTAL];
    self.tip = [dict objectForKey:KEY_TIP];
    self.currency = [dict objectForKey:KEY_CURRENCY];
    self.bitcoin = [dict objectForKey:KEY_BTC];
    self.type = [dict objectForKey:KEY_TYPE];
    self.wallet = [dict objectForKey:KEY_WALLET];
    self.senderWallet = [dict objectForKey:KEY_SENDER];
    self.date = [dict objectForKey:KEY_DATE];
}

@end
