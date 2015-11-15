//
//  UIViewController+YKTransition.m
//  YKTransitionControllerDemo
//
//  Created by Yang Kai on 15/11/15.
//  Copyright © 2015年 lamewing. All rights reserved.
//

#import "UIViewController+YKTransition.h"

#import "YKTransitionController.h"

@implementation UIViewController (YKTransition)

- (YKTransitionController *)transController
{
    UIViewController *vc = self.parentViewController;
    while (vc) {
        if ([vc isKindOfClass:[YKTransitionController class]]) {
            return (YKTransitionController *)vc;
        }
        vc = vc.parentViewController;
    }
    return nil;
}

@end
