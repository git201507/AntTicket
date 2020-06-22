//
//  CheckMyPlannerView.m
//  MedicareButler
//
//  Created by Wangxy on 16/3/8.
//  Copyright © 2016年 Neusoft. All rights reserved.
//
#import "CheckMyPlannerView.h"
#import "BasicViewCellManger.h"
#import "BasicToastInterFace.h"
#import "BasicWindowInterFace.h"

@interface CheckMyPlannerView ()
{
    
}

@end

@implementation CheckMyPlannerView
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

- (IBAction)toPlannerList:(id)sender
{
    [self endEditing:NO];
    
    [self.viewCellManger popToLastViewCell:nil];
    
    UIViewController *topCon = [BasicWindowInterFace getCurTopController];
    
    [topCon performSegueWithIdentifier:@"PlannerList" sender:nil];
}

- (IBAction)toVIP:(id)sender
{
    [self endEditing:NO];
    
    [self.viewCellManger popToLastViewCell:nil];
    
    UIViewController *topCon = [BasicWindowInterFace getCurTopController];
    if ([topCon respondsToSelector:@selector(applyVipBid)])
    {
        [topCon performSelector:@selector(applyVipBid)];
    }
}
#pragma mark - 自己的方法

#pragma mark - 消息方法

#pragma mark - 代理方法

@end
