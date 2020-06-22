//
//  ZhongJinViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "ZhongJinViewController.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "AFNRequestData.h"
#import <objc/runtime.h>
#import "UserMoneyAccountUpdater.h"
#import "BasicUserDef.h"
#import "BasicAccountInterFace.h"
#import "BasicWindowInterFace.h"

@interface ZhongJinViewController ()
{
    
}

@property (nonatomic, strong) UIActivityIndicatorView *act;

@end

@implementation ZhongJinViewController

- (void)dealloc
{
//    [UserMoneyAccountUpdater getUserMoneyAccountByToken:[BasicAccountInterFace getTokenWithAccountName:[BasicAccountInterFace getCurAccountName]]];
//    UIViewController *topCon = [BasicWindowInterFace getCurTopController];
//    if ([topCon isKindOfClass:NSClassFromString(@"BuyBidViewController")])
//    {
        //[self.navigationController popToRootViewControllerAnimated:NO];
//        return;
//    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self.navigationItem setHidesBackButton:YES];
    
    UIButton *backBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(popToRootViewController:) forControlEvents:UIControlEventTouchUpInside];
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
    
    _amount = [NSString stringWithFormat:@"%0.2f", [_amount doubleValue] * 100];
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
    [_webView loadRequest:[self getRequestByTrade]];
    _webView.scalesPageToFit = YES;
}

- (IBAction)popToRootViewController:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- 自己的方法
- (NSMutableURLRequest *)getRequestByTrade
{
    NSArray *array= [self.navigationController viewControllers];
    UIViewController *parentVC = [array objectAtIndex:[array count] - 2];
    
    NSString *url = @"";
    //    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithCapacity:0];
    NSString *params;
    
    //充值的情况
    if ([parentVC isKindOfClass:NSClassFromString(@"AccountFillinViewController")])
    {
        url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Mine_FillinMoneyURL];
        //        params = [@{@"paymentAccountNumber":_ipsAccount, @"amount":_amountFillin} mutableCopy];
        //设置请求体
        params=[NSString stringWithFormat:@"amount=%lld&paymentAccountNumber=%@",[_amount longLongValue],_ipsAccount];
    }
    
    //提现的情况
    else if ([parentVC isKindOfClass:NSClassFromString(@"AccountCashViewController")])
    {
        url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Mine_CashMoneyURL];
        params=[NSString stringWithFormat:@"amount=%lld&paymentAccountNumber=%@",[_amount longLongValue],_ipsAccount];
    }
    
    //买标的情况
    else if ([parentVC isKindOfClass:NSClassFromString(@"BuyBidViewController")])
    {
        url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Mine_BuyBidURL];
        params=[NSString stringWithFormat:@"amount=%lld&gmUserID=%@&draftID=%@",[_amount longLongValue],_gmUserID, _draftID];
    }
    
    //实名认证
    else if ([parentVC isKindOfClass:NSClassFromString(@"CertificationViewController")])
    {
        url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Mine_CertificationURL];
        AccountInfo *accountInfo = [[AccountInfo alloc] init];
        [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
        
        params=[NSString stringWithFormat:@"pRealName=%@&pMobileNo=%@&pIdentNo=%@&usertype=11",_realName,accountInfo.mobile, _identNo];
    }
    //账户签约
    else if ([parentVC isKindOfClass:NSClassFromString(@"SettingsViewController")])
    {
        url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Mine_SignContractURL];
        AccountInfo *accountInfo = [[AccountInfo alloc] init];
        [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
        
        params=[NSString stringWithFormat:@"agreementType=20&paymentaccountnumber=%@",_ipsAccount];
    }
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    [urlRequest setHTTPMethod:@"POST"];
    //    [urlRequest setHTTPBody: [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil]];
    [urlRequest setHTTPBody: [params dataUsingEncoding:NSUTF8StringEncoding]];
    return urlRequest;
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

@end
