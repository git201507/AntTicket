//
//  BasicUserAgreementView.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicUserAgreementView.h"
#import "UIImage+EX.h"
#import "BasicConfigPath.h"
#import "BasicViewCellAdmin.h"
#import "BasicAccountLib.h"

@implementation BasicUserAgreementView

- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    
    self.agreeBtn.layer.masksToBounds = YES;
    self.agreeBtn.layer.cornerRadius = 5.f;
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
//    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:@"license/license.htm"];
    
//    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    //    [_webView loadRequest:urlRequest];
    
    NSString *docPath = [BasicAccountLib getDocumentsPath];
    NSString *txtFilePath = [NSString stringWithFormat:@"%@/agreement.txt", docPath];
    
    NSData* data = [[NSData alloc] init];
    data = [NSData dataWithContentsOfFile:txtFilePath];
    
    if (!data)
    {
        NSString *txtFilePath = [[NSBundle mainBundle] pathForResource:@"Agreement" ofType:@"txt"];
        data = [NSData dataWithContentsOfFile:txtFilePath];
    }
    
    NSString *jsString = [NSString stringWithFormat:@"<html> \n"
                          "<head> \n"
                          "<style type=\"text/css\"> \n"
                          "body {font-size: %f;  color: %@;}\n"
                          "</style> \n"
                          "</head> \n"
                          "<body>%@</body> \n"
                          "</html>", 12.0,@"#686868",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    [_webView loadHTMLString:jsString baseURL:nil];
    _webView.scalesPageToFit = YES;
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
- (IBAction)back:(UIButton *)sender
{
    [self endEditing:NO];
    [self.viewCellManger popToLastViewCell:[BasicViewCellAdmin class]];
}

- (IBAction)agree:(id)sender
{
    [self endEditing:NO];
    [self.viewCellManger popToLastViewCell:[BasicViewCellAdmin class]];
}
#pragma mark - 自己的方法


#pragma mark - 消息方法


#pragma mark - 代理方法


@end
