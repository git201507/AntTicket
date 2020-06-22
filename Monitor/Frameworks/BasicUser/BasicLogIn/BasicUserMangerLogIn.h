//
//  BasicUserMangerLogIn.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicLogInView.h"
#import "BasicUserDef.h"

@interface BasicUserMangerLogIn : NSObject
{
@private
    BasicLogInView *_logInView;
    BASICUSERLONGSTATE _LogInState;
    
@public
    NSString *_publicId;
}

+ (BasicUserMangerLogIn *) Instance;
@property(nonatomic) BASICUSERLONGSTATE LogInState;

- (BOOL) doLogIn;

- (BOOL)doLogInAuto:(BOOL)isSyn accountName:(NSString *)accountName;

- (NSString *)doLogInAutoRetNewToken:(BOOL)isSyn accountName:(NSString *)accountName;

//不用请求网络，直接切换账户
- (BOOL)changeAccounNoNet:(NSString *)accountName;

- (BOOL)logInOut;

- (BASICUSERLONGSTATE)getLogInState;
- (void)setLogInState:(BASICUSERLONGSTATE)logInState;

- (BOOL)dealLogInSuccess:(NSData *)receiveData accountName:(NSString *)accountName;

- (BasicLogInView *) getLoginView;

@end
