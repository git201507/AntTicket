//
//  ProductAmplifiedImageViewController.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/10.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "ProductAmplifiedImageViewController.h"
#import "BasicConfigPath.h"
#import "GlobleURL.h"
#import "AFNRequestData.h"
#import <objc/runtime.h>
#import "UserMoneyAccountUpdater.h"
#import "BasicUserDef.h"
#import "BasicAccountInterFace.h"
#import "BasicWindowInterFace.h"

@interface ProductAmplifiedImageViewController ()
{
    
}

@end

@implementation ProductAmplifiedImageViewController

- (void)dealloc
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.webView.scrollView.showsVerticalScrollIndicator = YES;
    
    if([_imgUrlStr containsString:@"."])
    {
        NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:_imgUrlStr];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:urlRequest];
    }
    else
    {
        //编码图片
        UIImage *selectedImage = [UIImage imageNamed:_imgUrlStr];
        NSString *stringImage = [self htmlForJPGImage:selectedImage];
        
        //构造内容
        NSString *contentImg = [NSString stringWithFormat:@"%@", stringImage];
        NSString *content =[NSString stringWithFormat:
                            @"<html>"
                            "<style type=\"text/css\">"
                            "<!--"
                            "body{font-size:40pt;line-height:60pt;}"
                            "-->"
                            "</style>"
                            "<body>"
                            "%@"
                            "</body>"
                            "</html>"
                            , contentImg];
        
        //让self.contentWebView加载content
        [_webView loadHTMLString:content baseURL:nil];
    }
    _webView.scalesPageToFit = YES;
}

#pragma mark -- 自己的方法
//编码图片
- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64Encoding]];
    return [NSString stringWithFormat:@"<img src = \"%@\" />", imageSource];
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
//    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat height = [[UIScreen mainScreen] bounds].size.height;
//    
//    NSString *jsStr = [NSString stringWithFormat:@"var script = document.createElement('script');"
//                       "script.type = 'text/javascript';"
//                       "script.text = \"function ResizeImages() { "
//                       "var myimg,oldwidth,oldheight;"
//                       "var maxwidth = '%f';" //自定义宽度
//                       "var maxheight = '%f';" //自定义高度
//                       "for(i=0;i <document.images.length;i++){"
//                       "myimg = document.images[i];"
//                       "if(myimg.width > maxwidth){"
//                       "oldwidth = myimg.width;"
//                       "myimg.width = maxwidth;"
//                       "}"
//                       "if(height > maxheight){"
//                       "oldheight = myimg.height;"
//                       "myimg.height = maxheight;"
//                       "}"
//                       "}"
//                       "}\";"
//                       "document.getElementsByTagName('head')[0].appendChild(script);",width,height];
//    [_webView stringByEvaluatingJavaScriptFromString:jsStr];
//    [_webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
}
- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}

@end
