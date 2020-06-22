//
//  PlannerShareViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "PlannerShareViewController.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "BasicUserDef.h"
#import "BasicAccountInterFace.h"

@interface PlannerShareViewController ()
{
    
}

@property (nonatomic, strong) UIActivityIndicatorView *act;

@end

@implementation PlannerShareViewController

- (void)dealloc
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];

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
    NSString *urlPath = @"http://www.ypbill.com/views/weixin/wxlogin/shareFinancial.jsp";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
    
    [urlRequest setHTTPMethod:@"POST"];
    //    [urlRequest setHTTPBody: [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil]];
    
    
    [urlRequest setHTTPBody: [_paramStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    [_webView loadRequest:urlRequest];
    _webView.scalesPageToFit = YES;
}

#pragma mark -- 自己的方法
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
