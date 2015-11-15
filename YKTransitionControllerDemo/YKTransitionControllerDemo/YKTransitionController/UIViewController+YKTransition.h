//
//  UIViewController+YKTransition.h
//  YKTransitionControllerDemo
//
//  Created by Yang Kai on 15/11/15.
//  Copyright © 2015年 lamewing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YKTransitionController;

@interface UIViewController (YKTransition)

@property (nonatomic, weak, readonly) YKTransitionController *transController;

@end
