//
//  Notify.h
//  Merchant
//
//  Created by Alex on 6/18/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notify : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *date;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
