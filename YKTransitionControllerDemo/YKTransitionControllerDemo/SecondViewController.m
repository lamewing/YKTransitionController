//
//  SecondViewController.m
//  YKTransitionControllerDemo
//
//  Created by Yang Kai on 15/11/15.
//  Copyright © 2015年 lamewing. All rights reserved.
//

#import "SecondViewController.h"

#import "YKTransitionController.h"

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backBtn = ({
        CGFloat width = 100;
        CGFloat height = 30;
        CGFloat x = (self.view.bounds.size.width - width) * 0.5;
        CGFloat y = (self.view.bounds.size.height - height) * 0.5;
        
        UIButton * b = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        [b setTitle:@"Back" forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
        b;
    });
    [self.view addSubview:backBtn];
    
    UIButton *nextBtn = ({
        CGFloat width = 100;
        CGFloat height = 30;
        CGFloat x = (self.view.bounds.size.width - width) * 0.5;
        CGFloat y = CGRectGetMaxY(backBtn.frame) + 30;
        
        UIButton * b = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        [b setTitle:@"Next" forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [b addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
        b;
    });
    [self.view addSubview:nextBtn];
    
    self.view.backgroundColor = [UIColor colorWithRed:rand()%255/255.0 green:rand()%255/255.0 blue:rand()%255/255.0 alpha:1.0];
}

- (void)back
{
    [self.transController popViewController];
}

- (void)next
{
    [self.transController pushViewController:[[SecondViewController alloc] init]];
}


- (void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"Second view controller will move to %@", NSStringFromClass([parent class]));
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"Second view controller did move to %@", NSStringFromClass([parent class]));
}

@end
