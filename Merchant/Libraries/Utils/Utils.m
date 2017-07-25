//
//  HomeTableViewCell.h
//  WUG
//
//  Created by Thomas Maas on 23/09/16.
//  Copyright © 2016 Thomas Maas. All rights reserved.
//

#import "Utils.h"

@implementation Utils

#pragma mark - NSUserDefaults - MT
+ (void)setObjectToUserDefaults:(id)object inUserDefaultsForKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getObjectFromUserDefaultsForKey:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

#pragma mark - Image

+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - NSDate->NSString
//    NSDate *date = [Utils dateFromString:dict[@"date"] format:@"yyyy-MM-dd HH:mm:ss" timezone:@"UTC"];
//format: @"dd-MM-yyyy",
+ (NSDate*)dateFromString:(NSString*)datestring format:(NSString*)format timezone:(NSString *)timezone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timezone]];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:datestring];
    
    return dateFromString;
}
+ (NSString*)dateToString:(NSDate*)date format:(NSString*)format timezone:(NSString *)timezone{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:timezone]];
    NSString *stringDate = [dateFormatter stringFromDate:date];
    
    return stringDate;
}

#pragma mark - Other - MT
+ (BOOL)NSStringIsValidEmail:(NSString *)checkString{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - Customise view - MT
+(void)CustomiseView:(UIView *)view withColor:(UIColor*)color withWidth:(float)width withCorner:(float)corner{
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = width;
    view.layer.cornerRadius = corner;
    view.layer.masksToBounds = YES;
}

+(void)CustomViewWithGrey:(UIView *)view{
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.0f;
}

+(void)CustomViewWithBlack:(UIView *)view{
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = 1.0f;
}

+(void)RoundAvatarImageView:(UIView *)view{
    view.layer.borderColor = COLOR_GREEN.CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = view.frame.size.width / 2;
    view.layer.masksToBounds = YES;
}

+(void)RoundViewWithWhite:(UIView *)view{
    view.layer.borderColor = [UIColor whiteColor].CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = view.frame.size.width / 2;
    view.layer.masksToBounds = YES;
}

+(void)RoundViewWithLightGrey:(UIView *)view{
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = 8.0f;
    view.layer.masksToBounds = YES;
}

+(void)RoundViewWithClear:(UIView *)view{
    view.layer.borderColor = [UIColor clearColor].CGColor;
    view.layer.borderWidth = 1.0f;
    view.layer.cornerRadius = 8.0f;
    view.layer.masksToBounds = YES;
}

+(void)addBottomView:(UIView *)view withText:(NSString*)string withSuperView:(UIView*)supeview{
    view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor blueColor]];
    view.frame = CGRectMake(0, supeview.superview.bounds.size.height - 44, supeview.bounds.size.width, 44);
    [supeview addSubview:view];
    
    UILabel *tle = [[UILabel alloc]initWithFrame:CGRectMake(0,0, view.frame.size.width, 44)];
    tle.text = string;
    tle.textColor = [UIColor whiteColor];
    tle.textAlignment = NSTextAlignmentCenter;
    [tle setFont:[UIFont boldSystemFontOfSize:21]];
    [tle setBackgroundColor:[UIColor clearColor]];
    tle.layer.shadowColor = [[UIColor darkGrayColor] CGColor];
    tle.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    tle.layer.shadowOpacity = 1.0f;
    tle.layer.shadowRadius = 1.0f;
    [view addSubview:tle];
}

#pragma mark - UIAlertView - MT
+(void)createAlert:(NSString *)title withMessage:(NSString*)message{
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//    [alertController addAction:ok];
//    
//    [self presentViewController:alertController animated:YES completion:nil];
}

@end

@implementation NSString (containsCategory)
- (BOOL) containsString:(NSString *)substring{
    NSRange range = [self rangeOfString:substring];
    BOOL found = (range.location != NSNotFound);
    return found;
}

@end
