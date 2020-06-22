//
//  NSSUserInterFace.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicUserDef.h"
#import "BasicUserNet.h"
#import "BasicAccountInterFace.h"

@interface BasicUserInterFace : NSObject

//手动调登陆界面
+ (BOOL)doLogIn;

+ (BOOL)doLogInAuto:(BOOL)isSyn accountName:(NSString *)accountName;

+ (BASICUSERLONGSTATE)getLogInState;

+ (void)setLogInState:(BASICUSERLONGSTATE)logInState;

+ (NSSNETRltState)UserNetHTTPPOST:(NSString *)url parameters:(id)parameters receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout;

+ (NSSNETRltState)UserNetHTTPGET:(NSString *)url receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout;

//不用请求网络，直接切换账户
+ (BOOL)changeAccounNoNet:(NSString *)accountName;

//手动调登陆界面
+ (BOOL)doRegister;

#pragma mark -账户
//注销
+ (BOOL)doLogOut;

@end
