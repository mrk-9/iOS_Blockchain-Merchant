//
//  Notify.m
//  Merchant
//
//  Created by Alex on 6/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "Notify.h"

@implementation Notify

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.title forKey:KEY_TITLE];
    [aCoder encodeObject:self.date forKey:KEY_DATE];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.title = [aDecoder decodeObjectForKey:KEY_TITLE];
        self.date = [aDecoder decodeObjectForKey:KEY_DATE];
    }
    return self;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self)
    {
        [self initNotifyData:dict];
    }
    return self;
}

- (void)initNotifyData:(NSDictionary *)dict {
    self.title = [dict objectForKey:KEY_TITLE];
    self.date = [dict objectForKey:KEY_DATE];
}

@end
