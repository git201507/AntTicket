//
//  UserMoneyAccountUpdater.m
//  AntTicket
//
//  Created by Mac on 16/8/25.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "UserMoneyAccountUpdater.h"
#import "BasicMessageInterFace.h"
#import "BasicUserDef.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "AFNRequestData.h"
#import "BasicUserNet.h"
#import "BasicMoneyAccountDef.h"
#import "BasicDriver.h"
#import "BasicToastInterFace.h"
#import "BasicWindowInterFace.h"
#import "LoadingView.h"
#import "BasicUserInterFace.h"
#import "BasicUserMangerLogIn.h"

@implementation UserMoneyAccountUpdater

+ (UserMoneyAccountUpdater *)instance
{
    static UserMoneyAccountUpdater *obj;
    @synchronized ([UserMoneyAccountUpdater class])
    {
        if (obj == nil)
        {
            obj = [[UserMoneyAccountUpdater alloc] init];
        }
    }
    return obj;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        NSLog(@"Updater Create Successful!");
    }
    
    return self;
}

+ (void)getUserMoneyAccountByToken:(NSString *)token
{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:keywindow];
    
    //请求参数
    NSMutableDictionary *params = [@{@"token":token} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Mine_FindAccountInfoURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         [loadingView removeFromSuperview];

         
         MyAccountDetailReceiveInfo *info = [[MyAccountDetailReceiveInfo alloc] init];
         
         //登录状态异常，进入登录界面
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"] || !info.data)
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             
             if([info.msg isEqualToString:@"当前用户登录状态异常"] || [info.msg isEqualToString:@"unknown exception"])
             {
                 [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
                 [BasicUserInterFace doLogIn];
             }
             return;
         }
         
         //自动登录成功，设置账户信息页
         //1、发通知
         [UserMoneyAccountUpdater instance]->userMoneyAccountDetail = (MyAccountDetail *)info.data;
         
         NSDictionary *myDictionary = [NSDictionary dictionaryWithObject:info.data forKey:@"MoneyAccountDetail"];
         [[NSNotificationCenter defaultCenter] postNotificationName:NSSUSERMONEYACCOUNTCHANGEDMESSAGE_MainThread object:nil userInfo:myDictionary];
     }
                          failure:^(NSError *error)
     {
         [loadingView removeFromSuperview];
         
         //登录过期
         if (error.code == NSSNETRltState_OVERDUE)
         {
             [BasicToastInterFace showToast:@"登录已过期，请重新登录!  "];
             [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
             [BasicUserInterFace doLogIn];
             return;
         }
         
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         [BasicUserInterFace doLogIn];
     }];
}
+ (MyAccountDetail *)fetchUserMoneyAccountDetail
{
    return [UserMoneyAccountUpdater instance]->userMoneyAccountDetail;
}

@end
