//
//  MessageDetailViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "GlobleData.h"
#import "BasicConfigPath.h"

@interface MessageDetailViewController ()
{
    
}

@property (nonatomic, weak) IBOutlet UIImageView *img;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIWebView *webView;

@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    _titleLabel.text = _messageEntity.title;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    _webView.scalesPageToFit = YES;
    
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size: %f;  color: %@;}\n"
                          "</style> \n"
                          "<script> \n"
                          "function clickfont(str){ \n"
                          "window.location.href=\"%@/api/apply/download/\"+str; \n"
                          "} \n"
                          "</script> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>", 30.0,@"#686868",[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"], _messageEntity.content];
    [_webView loadHTMLString:jsString baseURL:nil];
    [_webView setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    //    NSLog(@"webViewDidStartLoad");
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    //    NSLog(@"webViewDidFinishLoad");
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //    NSLog(@"didFailLoadWithError:%@", error);
}

@end
