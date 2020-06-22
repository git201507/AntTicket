//
//  PlannerEditViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "PlannerEditViewController.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "AFNRequestData.h"
#import "BasicToastInterFace.h"
#import "BasicUserInterFace.h"
#import "MJRefresh.h"
#import "GlobleData.h"
#import "LoadingView.h"
#import "UIImageView+WebCache.h"

@interface PlannerEditViewController ()
{

}

@end

@implementation PlannerEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _contextTextView.text = _contextStr;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写或继承base中的方法
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

#pragma mark - 与xib关联的方法
- (IBAction)savePlanner:(id)sender
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSMutableDictionary *params = [@{@"memberId":accountInfo.userId, @"adviserIntroduction":_contextTextView.text} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:FinancePlanner_UpdateIntroductionURL];

    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         [loadingView removeView];
         NSLog(@"%@",respData);
         
         VerifyVipCodeReceiveInfo *info = [[VerifyVipCodeReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData])
         {
             return;
         }
         [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
         
         if ([info.state isEqualToString:@"1"])
         {
             NSArray *array= [self.navigationController viewControllers];
             UIViewController *parentVC = [array objectAtIndex:[array count] - 2];
             
             if ([parentVC respondsToSelector:@selector(getFinancePlannerDetail)])
             {
                 [parentVC performSelector:@selector(getFinancePlannerDetail)];
             }
         }
         [self.navigationController popViewControllerAnimated:YES];
     } failure:^(NSError *error)
     {
         [loadingView removeView];
         NSLog(@"%@",[error description]);
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

#pragma mark - 自己的方法

#pragma mark - 代理方法

@end
