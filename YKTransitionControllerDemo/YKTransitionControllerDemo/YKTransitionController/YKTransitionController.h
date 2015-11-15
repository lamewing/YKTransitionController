//
//  YKTransitionController.h
//  YKTransitionControllerDemo
//
//  Created by Yang Kai on 15/11/15.
//  Copyright © 2015年 lamewing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+YKTransition.h"

@interface YKTransitionController : UIViewController

- (instancetype)initWithRootViewController:(UIViewController *)viewController;

- (void)pushViewController:(UIViewController *)viewController;

- (void)popViewController;

@end
