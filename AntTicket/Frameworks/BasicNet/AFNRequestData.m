//
//  AFNRequestData.m
//  AFN
//
//  Created by cherish on 15/8/31.
//  Copyright (c) 2015年 杨飞龙 . All rights reserved.
//

#import "AFNRequestData.h"
#import "AFNetworking.h"

#define LoginCookie @"cashCookie"


@implementation AFNRequestData

+ (void)requestURL:(NSString *)requestURL
        httpMethod:(NSString *)method
            params:(NSMutableDictionary *)parmas
              file:(NSDictionary *)files
           success:(void (^)(id respData, NSInteger statusCode))success
              fail:(void (^)(NSError *error))fail
{
    //增加这几行代码；
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:YES];
    
    //1.构造操作对象管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //这里进行设置；
    [manager setSecurityPolicy:securityPolicy];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//                [manager.requestSerializer setValue:@"application/json;text/html;text/plain;text/xml;text/javascript" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"text/html; application/json" forHTTPHeaderField:@"Content-Type"];
    
    //    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:LoginCookie];
    //    if([cookiesdata length])
    //    {
    //        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
    //        NSHTTPCookie *cookie;
    //        for (cookie in cookies) {
    //            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    //        }
    //    }
    
    //2.设置解析格式，默认json
    //    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
    //        manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    manager.requestSerializer.timeoutInterval = 15;
    
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [manager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    //    [manager.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    
    //3.判断网络状况
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager startMonitoring];  //开始监听
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            
            //showAlert
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络链接错误,请检查网络链接" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil]show];
            
            //NSLog(@"没有网络");
            
            return;
            
        }else if (status == AFNetworkReachabilityStatusUnknown){
            
            //NSLog(@"未知网络");
            
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            //NSLog(@"WiFi");
            
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
            
            //NSLog(@"手机网络");
        }
        
        
        
    }];
    
    
    
    // 4.get请求
    if ([[method uppercaseString] isEqualToString:@"GET"]) {
        
        
        [manager GET:requestURL
          parameters:parmas
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 
                 if (success != nil)
                 {
                     NSLog(@"operation: %@", operation.responseString);
                     
                     if ([responseObject isKindOfClass:[NSData class]])
                     {
                         responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                         if (!responseObject) {
                             responseObject = operation.responseString;
                         }
                     }
                     
                     success(responseObject, operation.response.statusCode);
                 }
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 
                 
                 if (fail != nil) {
                     fail(error);
                 }
             }];
        
        
        // 5.post请求不带文件 和post带文件
    }else if ([[method uppercaseString] isEqualToString:@"POST"]) {
        
        
        if (files == nil) {
            
            
            [manager POST:requestURL
               parameters:parmas
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      
                      
                      if (success)
                      {
                          //NSLog(@"operation: %@", operation.responseString);
                          
                          /**
                           *  从response的HeaderField获得头文件，从头文件中通过NSHTTPCookie的cookiesWithResponseHeaderFields组成cookie的NSArray，将生成cookie的array，使用NSHttpCookie的reqeustHeaderFieldsWithCookies方法拼接成合法的http header field。最后set到request中即可。
                           [manager.requestSerializer setValue:[requestFields objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
                           */
                          /*
                           NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:requestURL]];
                           NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                           if ([data length]) {
                           [[NSUserDefaults standardUserDefaults] setObject:data forKey:LoginCookie];
                           }*/
                          
                          
                          //                          NSDictionary *fields= [operation.response allHeaderFields];
                          //                          
                          //                          if (<#condition#>) {
                          //                              <#statements#>
                          //                          }
                          //                          NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:requestURL]];
                          //                              NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
                          //                          
                          //                          
                          //                          [cookieProperties setObject:NSHTTPCookieName forKey:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
                          //                          [cookieProperties setObject:NSHTTPCookieDomain forKey:[NSHTTPCookie.domain];
                          //                          
                          //                          NSDictionary* requestFields=;
                          //                          [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:LoginCookie];
                          //                          
                          
                          if ([responseObject isKindOfClass:[NSData class]])
                          {
                              responseObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                              if (!responseObject) {
                                  responseObject = operation.responseString;
                              }
                          }
                          
                          success(responseObject, operation.response.statusCode);
                      }
                      
                  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                      NSLog(@"operation: %@", operation.responseString);
                      
                      if (fail) {
                          fail(error);
                      }
                      
                  }];
            
        } else {
            
            [manager POST:requestURL
               parameters:parmas constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                   
                   
                   for (id key in files) {
                       
                       id value = files[key];
                       
                       
                       
                       [formData appendPartWithFileData:value
                                                   name:key
                                               fileName:@"header.png"
                                               mimeType:@"image/png"];
                   }
                   
               } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                   
                   if (success) {
                       success(responseObject, operation.response.statusCode);
                   }
                   
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                   
                   if (fail) {
                       fail(error);
                   }
                   
               }];
        }
        
    }
    
}

@end
