//
//  UIViewController+Utilities.m
//  Merchant
//
//  Created by User on 10/31/14.
//  Copyright (c) 2014 com. All rights reserved.
//

#import "UIViewController+Utilities.h"

@implementation UIViewController (Utilities)

- (BOOL)isModal
{
    return self.presentingViewController.presentedViewController == self
    || self.navigationController.presentingViewController.presentedViewController == self.navigationController
    || [self.tabBarController.presentingViewController isKindOfClass:[UITabBarController class]];
}

@end
