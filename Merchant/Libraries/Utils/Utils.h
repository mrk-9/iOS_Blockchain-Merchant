//
//  HomeTableViewCell.h
//  WUG
//
//  Created by Thomas Maas on 23/09/16.
//  Copyright © 2016 Thomas Maas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (void)setObjectToUserDefaults:(id)object inUserDefaultsForKey:(NSString*)key;
+ (id)getObjectFromUserDefaultsForKey:(NSString *)key;

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (BOOL)NSStringIsValidEmail:(NSString *)checkString;

+ (NSDate*)dateFromString:(NSString*)datestring format:(NSString*)format timezone:(NSString *)timezone;
+ (NSString*)dateToString:(NSDate*)date format:(NSString*)format timezone:(NSString *)timezone;

+(void)CustomiseView:(UIView *)view withColor:(UIColor*)color withWidth:(float)width withCorner:(float)corner;
+(void)CustomViewWithGrey:(UIView *)view;
+(void)CustomViewWithBlack:(UIView *)view;
+(void)RoundViewWithWhite:(UIView *)view;
+(void)RoundViewWithClear:(UIView *)view;
+(void)RoundAvatarImageView:(UIView *)view;
+(void)RoundViewWithLightGrey:(UIView *)view;

+(void)addBottomView:(UIView *)view withText:(NSString*)string withSuperView:(UIView*)supeview;
+(void)createAlert:(NSString *)title withMessage:(NSString*)message;

@end


@interface NSString (containsCategory)
- (BOOL) containsString:(NSString *)substring;
@end
