//
//  BasicUserMangerLogIn.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicUserMangerLogIn.h"
#import "BasicAccountInterFace.h"
#import "BasicUserNet.h"
#import "BasicMessageInterFace.h"
#import "BasicViewCellUPDownAdmin.h"
#import "UIWindow+NSSViewCell.h"
#import "BasicToastInterFace.h"

@implementation BasicUserMangerLogIn

+ (BasicUserMangerLogIn *) Instance
{
    static BasicUserMangerLogIn *obj = nil;
    @synchronized([BasicUserMangerLogIn class])
    {
        if (obj == nil)
        {
            obj = [[BasicUserMangerLogIn alloc] init];
        }
        
    }
    return obj;
}

- (BOOL) doLogIn
{
    if (_logInView && _logInView.isAllocedLogView)
    {
        return NO;
    }
    
    if (!_logInView)
    {
        _logInView = [[[NSBundle mainBundle] loadNibNamed:@"BasicLogInView" owner:self options:nil] lastObject];
    }
    
    _logInView.isAllocedLogView = YES;
    _logInView.password.text = @"";
    if (_LogInState == BASICUSERLONGSTATE_OVERDUE)
    {
        [self logInOverDueNotice];
        _LogInState = BASICUSERLONGSTATE_NONE;
        [BasicMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
    }
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addViewCellToManger:_logInView animated:[BasicViewCellUPDownAdmin class]];
    
    return YES;
}

- (BOOL)doLogInAuto:(BOOL)isSyn accountName:(NSString *)accountName
{
    BOOL ret = NO;
    //    NSArray *array = [BasicAccountInterFace getAccountForm];
    //    
    //    if (accountName && array && [array count] > 0)
    //    {
    //        BOOL isIn = NO;
    //        for (int i = 0; i < [array count]; i++)
    //        {
    //            NSDictionary *accountDic = [array objectAtIndex:i];
    //            NSArray *valArray = [accountDic allValues];
    //            NSString *str = [valArray objectAtIndex:0];
    //            if ([str isEqualToString:accountName])
    //            {
    //                isIn = YES;
    //                break;
    //            }
    //        }
    //        
    //        if (isIn)
    //        {
    //            NSString *refresh_token = [BasicAccountInterFace getRefreshTokenWithAccountName:accountName];
    //            NSData *receiveData = nil;
    //            NSSNETRltState state = [BasicUserNet PostToUpdateToken:refresh_token receiveData:&receiveData];
    //            if (state == NSSNETRltState_SUCESS && receiveData)
    //            {
    //                ret = [self dealLogInSuccess accountName:accountName];
    //            }
    //            else if (state == NSSNETRltState_OVERDUE)
    //            {
    //                [self performSelectorOnMainThread:@selector(changeLogInStateOverDue) withObject:nil waitUntilDone:NO];
    //                [self performSelectorOnMainThread:@selector(doLogIn) withObject:nil waitUntilDone:NO];
    //            }
    //        }
    //    }
    
    return ret;
}


- (NSString *)doLogInAutoRetNewToken:(BOOL)isSyn accountName:(NSString *)accountName;
{
    NSString *ret = nil;
    //    NSArray *array = [BasicAccountInterFace getAccountForm];
    //    
    //    if (accountName && array && [array count] > 0)
    //    {
    //        BOOL isIn = NO;
    //        for (int i = 0; i < [array count]; i++)
    //        {
    //            NSDictionary *accountDic = [array objectAtIndex:i];
    //            NSArray *valArray = [accountDic allValues];
    //            NSString *str = [valArray objectAtIndex:0];
    //            if ([str isEqualToString:accountName])
    //            {
    //                isIn = YES;
    //                break;
    //            }
    //        }
    //        
    //        if (isIn)
    //        {
    //            NSString *refresh_token = [BasicAccountInterFace getRefreshTokenWithAccountName:accountName];
    //            NSData *receiveData = nil;
    //            NSSNETRltState state = [BasicUserNet PostToUpdateAccessToken:refresh_token receiveData:&receiveData];
    //            if (state == NSSNETRltState_SUCESS && receiveData)
    //            {
    //                AccountInfo *receiveInfo = [[AccountInfo alloc] init];
    //                NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
    //                
    //                if ([receiveInfo setJsonDataWithDic:infoDic])
    //                {
    //                    _publicId = accountName;
    //                    [self performSelectorOnMainThread:@selector(saveAccountOnMainThread:) withObject:receiveInfo waitUntilDone:NO];
    //                    ret = receiveInfo.access_token;
    //                }
    //            }
    //            else if (state == 400 && receiveData)
    //            {
    //                NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
    //                [self performSelectorOnMainThread:@selector(showErrorMessageOnMainThread:) withObject:infoDic waitUntilDone:NO];
    //                [self performSelectorOnMainThread:@selector(doLogIn) withObject:nil waitUntilDone:NO];
    //            }
    //            else if (state == NSSNETRltState_OVERDUE)
    //            {
    //                [self performSelectorOnMainThread:@selector(changeLogInStateOverDue) withObject:nil waitUntilDone:NO];
    //                [self performSelectorOnMainThread:@selector(doLogIn) withObject:nil waitUntilDone:NO];
    //            }
    //        }
    //    }
    
    return ret;
}

- (BASICUSERLONGSTATE)getLogInState
{
    BASICUSERLONGSTATE state = BASICUSERLONGSTATE_NONE;
    
    if ([BasicAccountInterFace getIsLogingState])
    {
        if (_LogInState == BASICUSERLONGSTATE_AUTO)
        {
            state = BASICUSERLONGSTATE_AUTO;
        }
        else if(_LogInState == BASICUSERLONGSTATE_AUTONONET)
        {
            state = BASICUSERLONGSTATE_AUTONONET;
        }
        else if(_LogInState == BASICUSERLONGSTATE_NONE || _LogInState == BASICUSERLONGSTATE_OVERDUE)
        {
            state = BASICUSERLONGSTATE_NONE;
        }
        else
        {
            state = BASICUSERLONGSTATE_LONGIN_MANUAL;
        }
    }
    
    return state;
}

- (void)setLogInState:(BASICUSERLONGSTATE)logInState
{
    if (logInState == BASICUSERLONGSTATE_AUTO)
    {
        _LogInState = BASICUSERLONGSTATE_AUTO;
    }
    else if(logInState == BASICUSERLONGSTATE_AUTONONET)
    {
        _LogInState = BASICUSERLONGSTATE_AUTONONET;
    }
    else if(logInState == BASICUSERLONGSTATE_NONE)
    {
        _LogInState = BASICUSERLONGSTATE_NONE;
    }
    else
    {
        _LogInState = BASICUSERLONGSTATE_LONGIN_MANUAL;
    }
}

- (BOOL)dealLogInSuccess:(NSData *)receiveData accountName:(NSString *)accountName
{
    BOOL ret = NO;
    AccountInfo *receiveInfo = [[AccountInfo alloc] init];
    
    NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
    
    if ([receiveInfo setJsonDataWithDic:infoDic])
    {
        _publicId = accountName;
        [self performSelectorOnMainThread:@selector(saveAccountOnMainThread:) withObject:receiveInfo waitUntilDone:NO];
        ret = YES;
    }
    return ret;
}

- (BOOL)changeAccounNoNet:(NSString *)accountName
{
    BOOL ret = NO;
    NSArray *array = [BasicAccountInterFace getAccountForm];
    
    if (accountName && array && [array count] > 0)
    {
        BOOL isIn = NO;
        for (int i = 0; i < [array count]; i++)
        {
            NSDictionary *accountDic = [array objectAtIndex:i];
            NSArray *valArray = [accountDic allValues];
            NSString *str = [valArray objectAtIndex:0];
            if ([str isEqualToString:accountName])
            {
                isIn = YES;
                break;
            }
        }
        
        if (isIn)
        {
            NSString *token = [BasicAccountInterFace getTokenWithAccountName:accountName];
            if (token)
            {
                [BasicAccountInterFace chooseAccount:accountName];
                _LogInState = BASICUSERLONGSTATE_AUTONONET;
            }
        }
    }
    
    return ret;
}

- (BOOL)logInOut
{
    _LogInState = BASICUSERLONGSTATE_NONE;
    
    //清空cookie里的token
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [cookieJar cookies])
    {
        if ([[cookie name] isEqualToString:@"token"])
        {
            [cookieJar deleteCookie:cookie];
        }
    }
    
    [BasicAccountInterFace setAccountSettingInfo:_publicId key:ACCOUNTSETTING_ISREMMBERPASSWORD_NSNUMBER_BOOL val:[NSNumber numberWithBool:NO]];
    return [BasicAccountInterFace chooseAccount:PUBLICACCOUNT];
}

- (void)logInOverDueNotice
{
    [BasicToastInterFace showToast:@"登录已过期，请您重新登录!  "];
}

- (void)changeLogInStateOverDue
{
    _LogInState = BASICUSERLONGSTATE_OVERDUE;
}
- (void)saveAccountOnMainThread:(AccountInfo *)receiveInfo
{
    _LogInState = BASICUSERLONGSTATE_AUTO;
    [BasicAccountInterFace chooseAccount:_publicId];
    [BasicAccountInterFace saveToken:_publicId token:receiveInfo.token];
    //    [BasicAccountInterFace saveRefreshToken:_publicId token:receiveInfo.refresh_token];
}

- (void)showErrorMessageOnMainThread:(NSDictionary *)infoDic
{
    _LogInState = BASICUSERLONGSTATE_NONE;
    [BasicMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
    NSString *errorDescription = [infoDic objectForKey:@"error_description"];
    if (errorDescription.length > 0)
    {
        [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", errorDescription]];
    }
}
- (BasicLogInView *) getLoginView
{
    return _logInView;
}

@end
