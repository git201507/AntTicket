//
//  NSSUserInterFace.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicUserInterFace.h"
#import "BasicUserMangerLogIn.h"
#import "BasicViewCellUPDownAdmin.h"
#import "BasicAccount/BasicAccountInterFace.h"
#import "UIWindow+NSSViewCell.h"

@class NSSRegisterView;

@implementation BasicUserInterFace

+ (BOOL) doLogIn
{
    return [[BasicUserMangerLogIn Instance] doLogIn];
}

+ (BOOL)doLogInAuto:(BOOL)isSyn accountName:(NSString *)accountName
{
    return [[BasicUserMangerLogIn Instance] doLogInAuto:isSyn accountName:accountName];
}

+ (BASICUSERLONGSTATE)getLogInState
{
    return [[BasicUserMangerLogIn Instance] getLogInState];
}

+ (void)setLogInState:(BASICUSERLONGSTATE)logInState
{
    [[BasicUserMangerLogIn Instance] setLogInState:logInState];
}

+ (NSSNETRltState)UserNetHTTPPOST:(NSString *)url parameters:(id)parameters receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout
{
    NSSNETRltState state = [BasicUserNet UserHTTPPOST:url parameters:parameters receiveData:receiveData timeOut:timeout];
    
    return state;
}

+ (NSSNETRltState)UserNetHTTPGET:(NSString *)url receiveData:(NSData **)receiveData timeOut:(NSSNETTimeOut)timeout
{
    NSSNETRltState state = [BasicUserNet UserHTTPGET:url receiveData:receiveData timeOut:timeout];
    
    return state;
}

//不用请求网络，直接切换账户
+ (BOOL)changeAccounNoNet:(NSString *)accountName
{
    return [[BasicUserMangerLogIn Instance] changeAccounNoNet:accountName];
}

+ (BOOL)doRegister
{
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"BasicRegisterView" owner:self options:nil]; //通过这个方法,取得我们的视图
    NSSRegisterView *SubView = [nibViews objectAtIndex:0];
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addViewCellToManger:(BasicViewCell *)SubView animated:[BasicViewCellUPDownAdmin class]];
    return YES;
}

+ (BOOL)doLogOut
{
    return [[BasicUserMangerLogIn Instance] logInOut];
}

@end
