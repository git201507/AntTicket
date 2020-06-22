//
//  FinancialPlannerView.m
//  MedicareButler
//
//  Created by Wangxy on 16/3/8.
//  Copyright © 2016年 Neusoft. All rights reserved.
//
#import "FinancialPlannerView.h"
#import "BasicViewCellManger.h"
#import "BasicToastInterFace.h"
#import "BasicWindowInterFace.h"

@interface FinancialPlannerView ()
{
    
}

@end

@implementation FinancialPlannerView
- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
}

- (void)viewCellWillAppear
{
    [super viewCellWillAppear];
}

- (void)viewCellDidAppear
{
    [super viewCellDidAppear];
}

- (void)viewCellWillDisappear
{
    [super viewCellWillDisappear];
}

- (void)viewCellDidDisappear
{
    [super viewCellDidDisappear];
}

#pragma mark - 需要子类继承的

#pragma mark - 与XIB绑定事件
- (IBAction)back:(id)sender
{
    [self endEditing:NO];
    
    [self.viewCellManger popToLastViewCell:nil];
    
}

- (IBAction)financialPlanner:(id)sender
{
    [self endEditing:NO];
    
    [self.viewCellManger popToLastViewCell:nil];
    

    UITabBarController *topCon = (UITabBarController *)[BasicWindowInterFace getCurTopController];
    
    UIViewController *MyAccountVC = [topCon.viewControllers objectAtIndex:1];
    
    if ([MyAccountVC isKindOfClass:NSClassFromString(@"MyAccountViewController")])
    {
        [MyAccountVC performSegueWithIdentifier:@"plannerInstruction" sender:nil];
    }
}
#pragma mark - 自己的方法

#pragma mark - 消息方法

#pragma mark - 代理方法

@end
