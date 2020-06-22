//
//  PrizeViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "PrizeViewController.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "BasicUserDef.h"
#import "BasicAccountInterFace.h"
#import "AFNRequestData.h"
#import "GlobleURL.h"
#import "GlobleData.h"
#import "BasicToastInterFace.h"

@interface PrizeViewController ()
{
    
}

@property (nonatomic, strong) UIActivityIndicatorView *act;
@property (nonatomic, copy) NSString *prizeId;

@end

@implementation PrizeViewController

- (void)dealloc
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *backBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(getPrizeId) forControlEvents:UIControlEventTouchUpInside];
    //设置图片
    UIImage *imageForButton=[UIImage imageNamed:@"pic_nav_back"];
    [backBtn setImage:imageForButton forState:UIControlStateNormal];
    
    //设置文字
    NSString *buttonTitleStr=@"返回";
    [backBtn setTitle:buttonTitleStr forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont systemFontOfSize:18];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    backBtn.frame=CGRectMake(0,0,60,30);//#1#硬编码设置UIButton位置、大小
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    if ([_isCommon boolValue])
    {
         [self getPrize];
    }
    else
    {
        [self loadVip];
    }
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    //这里调用获取分享地址的方法。
//    [self.navigationController popToRootViewControllerAnimated:NO];
//
//    NSArray *array= [self.navigationController viewControllers];
//    UITabBarController *rootVC = [array objectAtIndex:0];
//    
//    UIViewController *parentVC = [rootVC.viewControllers objectAtIndex:1];
//    
//    if ([parentVC respondsToSelector:@selector(sharePrize)])
//    {
//        [parentVC performSelector:@selector(sharePrize)];
//    }
//}

#pragma mark -- 自己的方法
- (void)getPrize
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    //请求参数
    NSMutableDictionary *params = [@{@"memberId":accountInfo.userId} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Prize_GetPrizeId];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         NSLog(@"%@",respData);
         
         VerifyVipCodeReceiveInfo *info = [[VerifyVipCodeReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             return;
         }
         _prizeId = info.msg;
         
         if (!_prizeId || _prizeId.length == 0)
         {
             return;
         }
         [self loadCommon];
     }
                          fail:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
     }];
}

- (void)loadVip
{
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.webView.scrollView setBounces:NO];
    
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
        [self.view addSubview:_act];
    }
    [_act startAnimating];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Prize_GetVIPURL(accountInfo.userId)];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [urlRequest setHTTPMethod:@"GET"];
    //    [urlRequest setHTTPBody: [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil]];
    //    [urlRequest setHTTPBody: [params dataUsingEncoding:NSUTF8StringEncoding]];
    
    [_webView loadRequest:urlRequest];
    _webView.scalesPageToFit = YES;
}

- (void)loadCommon
{
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    [self.webView.scrollView setBounces:NO];
    
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/3)];
        [self.view addSubview:_act];
    }
    [_act startAnimating];
    
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Prize_GetCommonURL(_prizeId)];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    [_webView loadRequest:urlRequest];
    _webView.scalesPageToFit = YES;
}

- (void)getSharedCoupon
{
    //请求参数
    NSMutableDictionary *params = [@{@"prizeId":_prizeId} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Prize_GetSharedCoupon];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         NSLog(@"%@",respData);
     }
                          fail:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
     }];
}

- (void)shareCoupon
{
    //请求参数
    NSMutableDictionary *params = [@{@"prizeId":_prizeId} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Prize_ShareCoupon];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         NSLog(@"%@",respData);
         [self.navigationController popViewControllerAnimated:NO];
     }
                          fail:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
         [self.navigationController popViewControllerAnimated:NO];
     }];
}

- (void)getPrizeId
{
    if (!_prizeId || _prizeId.length == 0)
    {
        [self.navigationController popViewControllerAnimated:NO];
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"必须分享才能获得奖励" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil] ;
    [alert show];
}

- (void)validateCommonPrizeShare
{
    //请求参数
    NSMutableDictionary *params = [@{@"prizeId":_prizeId} mutableCopy];
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Prize_ValidateCommonPrizeShare];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         NSLog(@"%@",respData);
         
         ShareReceiveInfo *info = [[ShareReceiveInfo alloc] init];
         
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [self.navigationController popViewControllerAnimated:NO];
             return;
         }
         
         NSString *textToShare = [NSString stringWithFormat:@"%@\r\n%@", [info.data.title substringWithRange:NSMakeRange(0, (info.data.title.length > 10) ? 11 : info.data.title.length)], [info.data.desc substringWithRange:NSMakeRange(0, (info.data.desc.length > 11) ? 12 : info.data.desc.length)]];
         NSArray *activityItems = @[textToShare, [UIImage imageNamed:@"ico_logo"], [NSURL URLWithString:info.data.link]];
         
         _activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
         //不出现在活动项目
         if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
         {
             _activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypeOpenInIBooks];
         }
         else
         {
             _activityController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,UIActivityTypePostToVimeo];
         }
         
         //给activityVC的属性completionHandler写一个block。
         //用以UIActivityViewController执行结束后，被调用，做一些后续处理。
         _activityController.completionHandler = ^(NSString *activityType,BOOL completed)
         {
             NSLog(@"activityType :%@", activityType);
             if (completed)
             {
                 [BasicToastInterFace showToast:@"分享成功!  "];
                 
                 if([info.data.link containsString:@"appShare"])
                 {
                     [self shareCoupon];
                 }
                 else
                 {
                     [self getSharedCoupon];
                 }
             }
             else
             {
                 NSLog(@"cancel");
                 [self.navigationController popViewControllerAnimated:NO];
             }
             [self getPrize];
         };
         
         [self presentViewController:_activityController animated:TRUE completion:nil];
     }
                          fail:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
         [self.navigationController popViewControllerAnimated:NO];
     }];
}


#pragma mark - 代理方法
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [_act stopAnimating];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_act stopAnimating];
}

#pragma mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self validateCommonPrizeShare];
    }
}

@end
