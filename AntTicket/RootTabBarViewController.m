//
//  RootTabBarViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "BasicUserInterFace.h"
#import "BasicUserMangerLogIn.h"
#import "UserMoneyAccountUpdater.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"

@interface RootTabBarViewController ()
{
@private
    NSString *_curAccountName;
    NSString *_curAccountToken;
}

@end

@implementation RootTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //获取版本号
//    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_GetAppVersionURL];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:System_GetAppVersionURL];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:nil
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         NSLog(@"%@",respData);
         
         NSString *newVersion = [respData objectForKey:@"msg"];
         
         if (!newVersion || newVersion.length == 0)
         {
             return;
         }
         
         NSString *curVersion = [BasicConfigPath getConfigPathWithKey:@"APPVERSION"];
         if([curVersion isEqualToString:newVersion])
         {
             return;
         }
         UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"当前版本已过期" message:@"无法继续，请下载最新版本" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
         [alert show];
     }
                          fail:^(NSError *error)
     {
         return;
     }];
     [self startNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startNormal
{
    // 土黄色
    UIColor *selectedColor = [UIColor colorWithRed:165.f/255.f green:134.f/255.f blue:58.f/255.f  alpha:0.8f];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.title = @"我的账户";
    self.delegate = self;
    
    //设置默认字体的颜色为灰色
    UIColor *itemColor = [UIColor lightGrayColor];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f], NSForegroundColorAttributeName : itemColor} forState:UIControlStateNormal];
    
    //设置Tab被选中时的图片颜色和字体颜色为土黄色
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:10.0f], NSForegroundColorAttributeName : selectedColor} forState:UIControlStateSelected];
    self.tabBar.tintColor = selectedColor;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    self.selectedIndex = 0;
    self.selectedIndex = 1;
    
    //获取本地缓存的用户名
    NSArray *array = [BasicAccountInterFace getAccountForm];
    
    if (array && ([array count] > 0))
    {
        NSDictionary *accountDic = [array objectAtIndex:0];
        NSArray *valArray = [accountDic allValues];
        _curAccountName = [valArray objectAtIndex:0];
    }
    
    //如果获取缓存失败，则进入登录页面
    if (!_curAccountName || [_curAccountName length]==0)
    {
        [BasicUserInterFace doLogIn];
        return;
    }
    
    NSNumber *autoLogin = (NSNumber *)[BasicAccountInterFace getAccountSettingInfo:_curAccountName key:ACCOUNTSETTING_ISREMMBERPASSWORD_NSNUMBER_BOOL];
    if(![autoLogin boolValue])
    {
        [BasicUserInterFace doLogIn];
        return;
    }
    
    //如果获取缓存User附加信息失败，则进入登录页面
    NSDictionary *addDictionary = [BasicAccountInterFace getAdditionalInfoWithAccountName:_curAccountName];
    if (!addDictionary)
    {
        [BasicUserInterFace doLogIn];
        return;
    }
    //如果获取user缓存的token失败，则进入登录页面
    _curAccountToken = [addDictionary objectForKey:@"token"];
    if (!_curAccountToken || [_curAccountToken length]==0)
    {
        [BasicUserInterFace doLogIn];
        return;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:addDictionary options:NSJSONWritingPrettyPrinted error:nil];
    //如果获取缓存User附加信息转换失败，则进入登录页面
    if (!data)
    {
        [BasicUserInterFace doLogIn];
        return;
    }
    
    //自动登录
    if(![[BasicUserMangerLogIn Instance] dealLogInSuccess:data accountName:_curAccountName])
        //如果自动登录失败，则进入登录页面
    {
        [BasicUserInterFace doLogIn];
        return;
    }
    
    //自动登录后验证token是否过期
    [UserMoneyAccountUpdater getUserMoneyAccountByToken:_curAccountToken];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//实现协议方法，用于切换Tab时，更改页面的标题
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSInteger index = tabBarController.selectedIndex;
    
    switch (index)
    {
        case 0:
            self.title = @"理财产品";
            break;
        case 1:
            self.title = @"我的账户";
            break;
        case 2:
            self.title = @"我有票据";
            break;
        case 3:
            self.title = @"精彩活动";
            break;
        default:
            break;
    }
}

#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        exit(0);
    }
}

@end
