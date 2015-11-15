//
//  ViewController.m
//  YKTransitionControllerDemo
//
//  Created by Yang Kai on 15/11/15.
//  Copyright © 2015年 lamewing. All rights reserved.
//

#import "FirstViewController.h"

#import "YKTransitionController.h"
#import "SecondViewController.h"

@interface FirstViewController () 

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"First view controller will move to %@", NSStringFromClass([parent class]));
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"First view controller did move to %@", NSStringFromClass([parent class]));
}

#pragma mark - UITableViewControllerDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"test";
    return cell;
}

#pragma mark - UITableViewControllerDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SecondViewController *svc = [[SecondViewController alloc] init];
    [self.transController pushViewController:svc];
}
@end
