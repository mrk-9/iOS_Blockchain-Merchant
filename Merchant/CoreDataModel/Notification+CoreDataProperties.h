//
//  Notification+CoreDataProperties.h
//  Merchant
//
//  Created by Alex on 6/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "Notification+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Notification (CoreDataProperties)

+ (NSFetchRequest<Notification *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSDate *date;

@end

NS_ASSUME_NONNULL_END
