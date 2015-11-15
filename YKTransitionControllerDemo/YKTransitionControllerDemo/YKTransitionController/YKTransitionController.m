//
//  YKTransitionController.m
//  YKTransitionControllerDemo
//
//  Created by Yang Kai on 15/11/15.
//  Copyright © 2015年 lamewing. All rights reserved.
//

#import "YKTransitionController.h"

@interface YKTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@end


@interface YKTransitionContext : NSObject <UIViewControllerContextTransitioning>

// animated
@property (nonatomic, assign, getter=isAnimated) BOOL animated;

// interactive
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;

// YES when pushing, NO when poping.
@property (nonatomic, assign) BOOL pushing;

// from controller's view transforms
@property (nonatomic, assign) CGAffineTransform initialFromViewTransform;
@property (nonatomic, assign) CGAffineTransform finalFromViewTransform;

// to controller's view transforms
@property (nonatomic, assign) CGAffineTransform initialToViewTransform;
@property (nonatomic, assign) CGAffineTransform finalToViewTransform;


@property (nonatomic, copy) void(^completionBlock)(BOOL completed);

// designated initializer
- (instancetype)initWithFromViewController:(UIViewController *)fromController toViewController:(UIViewController *)toController isPushing:(BOOL)pushing;

@end

@interface YKInteractionTransition : UIPercentDrivenInteractiveTransition

@end

@interface YKTransitionController ()

//@property (nonatomic, strong) NSMutableArray *controllerArray;

@end

@implementation YKTransitionController

- (instancetype)initWithRootViewController:(UIViewController *)viewController
{
    if (self = [super init]) {

        [self pushViewController:viewController];
    }
    return self;
}

- (void)pushViewController:(UIViewController *)viewController
{
    NSAssert(viewController, @"target view controller can not be null.");
    
    UIViewController *fromController = self.childViewControllers.lastObject;
    
    if ([fromController isEqual:viewController]) {
        return;
    }
    
    UIView *toView = viewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.frame = self.view.bounds;
    
    if (!fromController) {
        [self.view addSubview:toView];
        [self addChildViewController:viewController];
        return;
    }
    
    [self animateFromViewController:fromController toViewController:viewController isPushing:YES];
}

- (void)popViewController
{
    if (self.childViewControllers.count < 2) {
        return;
    }
    
    UIViewController *fromController = self.childViewControllers.lastObject;
    UIViewController *toController = self.childViewControllers[self.childViewControllers.count - 2];
    
    UIView *toView = toController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.frame = self.view.bounds;
    
    [self animateFromViewController:fromController toViewController:toController isPushing:NO];
}

- (void)animateFromViewController:(UIViewController *)fromController toViewController:(UIViewController *)toController isPushing:(BOOL)pushing
{
    if (pushing) {
        [self addChildViewController:toController];
    }
    
    YKTransitionAnimator *animator = [[YKTransitionAnimator alloc] init];
    YKTransitionContext *transitionContext = [[YKTransitionContext alloc] initWithFromViewController:fromController toViewController:toController isPushing:pushing];
    transitionContext.animated = YES;
    transitionContext.interactive  = NO;
    transitionContext.completionBlock = ^(BOOL completed) {
        [fromController.view removeFromSuperview];
        if (pushing) {
            
        } else {
            [fromController removeFromParentViewController];
        }
        
        [animator animationEnded:completed];
        self.view.userInteractionEnabled = YES;
    };
    self.view.userInteractionEnabled = NO;
    
    [animator animateTransition:transitionContext];
}


@end


@implementation YKTransitionAnimator

#pragma mark - UIViewControllerAnimatedTransitioning methods
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    YKTransitionContext *ctx= (YKTransitionContext *)transitionContext;
    UIViewController *fromController = [ctx viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toController = [ctx viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [[ctx containerView] addSubview:toController.view];
    if (!ctx.pushing) {
        [[ctx containerView] bringSubviewToFront:fromController.view];
    }
    
//    fromController.view.transform = CGAffineTransformIdentity;
    fromController.view.frame = [ctx initialFrameForViewController:fromController];
    fromController.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    fromController.view.transform = ctx.initialFromViewTransform;
    
    toController.view.transform = CGAffineTransformIdentity;
    toController.view.frame = [ctx initialFrameForViewController:toController];
    toController.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
    toController.view.transform = ctx.initialToViewTransform;
    
    [UIView animateWithDuration:[self transitionDuration:ctx] delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
//        fromController.view.frame = [ctx finalFrameForViewController:fromController];
        fromController.view.transform = ctx.finalFromViewTransform;
//        toController.view.frame = [ctx finalFrameForViewController:toController];
        toController.view.transform = ctx.finalToViewTransform;
        
    } completion:^(BOOL finished) {
        
        [ctx completeTransition:![ctx transitionWasCancelled]];
    }];
    
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    
}


@end

@interface YKTransitionContext ()


// container view
@property (nonatomic, weak) UIView *containerView;

// modal presentation style
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

// from controller
@property (nonatomic, weak) UIViewController *fromViewController;

// to controller
@property (nonatomic, weak) UIViewController *toViewController;


@end

@implementation YKTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromController toViewController:(UIViewController *)toController isPushing:(BOOL)pushing
{
    NSAssert(fromController && toController, @"Neither fromComtroller nor toController could be null.");
    NSAssert([fromController isViewLoaded] && fromController.view.superview, @"The fromController's view must be in the container view when transition context is being initializing.");
    
    if (self = [super init]) {
        
        self.pushing= pushing;
        self.containerView = fromController.view.superview;
        self.presentationStyle = UIModalPresentationCustom;
        self.fromViewController = fromController;
        self.toViewController = toController;
        
        CGAffineTransform shrunkTransform = CGAffineTransformMakeScale(0.8, 0.8);
        CGAffineTransform offsetTransform = CGAffineTransformMakeTranslation(self.containerView.bounds.size.width, 0.0);
        self.initialFromViewTransform = CGAffineTransformIdentity;
        self.finalToViewTransform = CGAffineTransformIdentity;
        if (pushing) {
            self.initialToViewTransform = offsetTransform;
            self.finalFromViewTransform = shrunkTransform;
        } else {
            self.initialToViewTransform = shrunkTransform;
            self.finalFromViewTransform = offsetTransform;
        }
    }
    return self;
}


#pragma mark - UIViewControllerContextTransitioning methods
- (CGRect)initialFrameForViewController:(UIViewController *)vc
{
//    CGRect initialRect = CGRectZero;
//    
//    if ([vc isEqual:self.fromViewController]) {
//        // when pushing & poping
//        initialRect = self.containerView.bounds;
//        
//    } else if ([vc isEqual:self.toViewController]) {
//        if (self.pushing) {
//            // when pushing
//            initialRect = CGRectOffset(self.containerView.bounds, self.containerView.bounds.size.width, 0.0);
//        } else {
//            // when poping
//            initialRect = self.shrunkRect;
//        }
//    }
//    
//    return initialRect;
    
    return self.containerView.bounds;
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc
{
//    CGRect finalRect = CGRectZero;
//    
//    if ([vc isEqual:self.toViewController]) {
//        // when poping & pushing
//        finalRect = self.containerView.bounds;
//        
//    } else {
//        if (self.pushing) {
//            finalRect = self.shrunkRect;
//        } else {
//            finalRect = CGRectOffset(self.containerView.bounds, self.containerView.bounds.size.width, 0.0);
//        }
//    }
//    
//    return finalRect;
    
    return self.containerView.bounds;
}

- (CGAffineTransform)targetTransform
{
    return CGAffineTransformIdentity;
}

- (UIViewController *)viewControllerForKey:(NSString *)key
{
    if ([key isEqualToString:UITransitionContextFromViewControllerKey]) {
        return self.fromViewController;
    } else if ([key isEqualToString:UITransitionContextToViewControllerKey]) {
        return self.toViewController;
    }
    return nil;
}

- (UIView *)viewForKey:(NSString *)key
{
    if ([key isEqualToString:UITransitionContextFromViewKey]) {
        return self.fromViewController.view;
    } else if ([key isEqualToString:UITransitionContextToViewKey]) {
        return self.toViewController.view;
    }
    return nil;
}

- (void)completeTransition:(BOOL)didComplete
{
    if (self.completionBlock) {
        self.completionBlock(didComplete);
    }
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{

}

- (void)cancelInteractiveTransition
{

}

- (void)finishInteractiveTransition
{

}

- (BOOL)transitionWasCancelled
{
    // can not be cancelled in this version
    return NO;
}

@end
