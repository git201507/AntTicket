//
//  HttpUtil.m
//  XQQ
//
//  Created by leehom on 14-11-26.
//  Copyright (c) 2014年 leehom. All rights reserved.
//

#import "HttpUtil.h"
#import "BasicToastInterFace.h"

@interface HttpUtil()
{
    NSHTTPURLResponse *_httpURLResponse;
}
@end


@implementation HttpUtil

//该方法同步请求服务器,需要在主线程中创建其它线程完成请求,否则会阻塞主线程导致UI卡住
+(NSString*) httpAsynchronousRequestUrl:(NSString*) spec postStr:(NSString *)sData
{
    NSURL *url = [NSURL URLWithString:spec];
    NSMutableURLRequest *requst = [NSMutableURLRequest requestWithURL:url];
    [requst setHTTPMethod:@"POST"];
    NSData *postData = [sData dataUsingEncoding:NSUTF8StringEncoding];
    [requst setHTTPBody:postData];
    [requst setTimeoutInterval:15.0];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    //如果使用局部变量指针需要传指针的地址
    NSData *data = [NSURLConnection sendSynchronousRequest:requst returningResponse:&urlResponse error:&error];
    NSString *returnStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"code:%d",[urlResponse statusCode]);
    if ([urlResponse statusCode] == 200) {
        return returnStr;
    }
    return nil;
}

//该方法为异步请求服务器，不用在主线程创建其它线程
+(void) httpNsynchronousRequestUrl:(NSString*) spec postStr:(NSString*)sData finshedBlock:(FinishBlock)block
{
    HttpUtil *http = [[HttpUtil alloc]init];
    http.finishBlock = block;
    //初始HTTP
    NSURL *url = [NSURL URLWithString:spec];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    //set headers
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //create the body
    NSMutableData *postBody = [NSMutableData data];
    //    [postBody appendData:[[NSString stringWithFormat:@"<xml>"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [postBody appendData:[[NSString stringWithFormat:@"<yourcode/>"] dataUsingEncoding:NSUTF8StringEncoding]];
    //    [postBody appendData:[[NSString stringWithFormat:@"</xml>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Begin Request
    [postBody appendData:[[NSString stringWithFormat:@"<Request version=\"2.1\">"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Begin Head
    [postBody appendData:[[NSString stringWithFormat:@"<Head>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Begin Txcode
    [postBody appendData:[[NSString stringWithFormat:@"<TxCode>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"123456"] dataUsingEncoding:NSUTF8StringEncoding]];
    //End Txcode
    [postBody appendData:[[NSString stringWithFormat:@"</TxCode>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //End Head
    [postBody appendData:[[NSString stringWithFormat:@"</Head>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Begin Body
    [postBody appendData:[[NSString stringWithFormat:@"<Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //End Body
    [postBody appendData:[[NSString stringWithFormat:@"</Body>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //End Request
    [postBody appendData:[[NSString stringWithFormat:@"</Request>"] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *str = [[NSString alloc] initWithData:postBody encoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    //post
    [request setHTTPBody:postBody];
    
    //连接
    NSURLConnection *con = [[NSURLConnection alloc]initWithRequest:request delegate:http];
    NSLog(con ? @"连接创建成功" : @"连接创建失败");
}

//收到服务器传输数据的时候调用，此方法根据数据大小执行若干次
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    [self.resultData appendData:data];
}

//接收到服务器回应的时回调
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    if (self.resultData == nil) {
        self.resultData = [[NSMutableData alloc]init];
    }else{
        [self.resultData setLength:0];
    }
    
    //get response
    _httpURLResponse = (NSHTTPURLResponse *)response;
}

//数据传完之后调用此方法
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    
    NSLog(@"Response Code: %ld", (long)[_httpURLResponse statusCode]);
    
    NSString *retStr = [[NSString alloc]initWithData:self.resultData encoding:NSUTF8StringEncoding];
    NSLog(@"Response: %@", retStr);
    
    if ([_httpURLResponse statusCode] >= 200 && [_httpURLResponse statusCode] < 300)
    {
        
        if(self.finishBlock != nil)
            self.finishBlock(retStr);
    }
    else
    {
        [BasicToastInterFace showToast:@"无法连接中金服务器!  "];
    }
    
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    if(self.finishBlock != nil)
        self.finishBlock(nil);
}

@end
