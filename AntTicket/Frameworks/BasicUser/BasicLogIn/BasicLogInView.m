//
//  BasicLogInView.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BasicLogInView.h"
#import "BasicToastInterFace.h"
#import "BasicRegisterView.h"
#import "BasicRetrievePasswordView.h"
#import "BasicViewCellUPDownAdmin.h"
#import "BasicAccountLib.h"
#import "BasicDriver.h"
#import "AFNRequestData.h"
#import "BasicConfigPath.h"
#import "BasicUserInterFace.h"
#import "BasicMessageInterFace.h"
#import "BasicFileMD5Check.h"
#import "BasicWindowInterFace.h"
@interface BasicLogInView ()
{
    NSString *_refreshToken;
    NSString *_accessToken;
}

@property (nonatomic, strong) UIActivityIndicatorView *act;
@end

@implementation BasicLogInView

@synthesize isAllocedLogView = _isAllocedLogView;

- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    [self initFace];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap)];
    
    [doubleTap setNumberOfTapsRequired:3];
    
    [self addGestureRecognizer:doubleTap];
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
- (IBAction)textFieldDoneEditing:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)back:(UIButton *)sender
{
    [self endEditing:NO];
    [self.viewCellManger popToLastViewCell:[BasicViewCellUPDownAdmin class]];
    _isAllocedLogView = NO;
}

- (void)retrieveUserName:(NSString *)sender
{
    _username.text = sender;
}

- (void)registLogin:(NSString *)para
{
    _username.text=[para componentsSeparatedByString:@"-"][0];
    _password.text=[para componentsSeparatedByString:@"-"][1];
    [self login:nil];
}

- (void)loginToCertificate:(id)sender
{
    UITabBarController *topCon = (UITabBarController *)[BasicWindowInterFace getCurTopController];
    UIViewController *MyAccountVC = [topCon.viewControllers objectAtIndex:1];
    if ([MyAccountVC isKindOfClass:NSClassFromString(@"MyAccountViewController")])
    {
        [MyAccountVC performSegueWithIdentifier:@"accountToCertificate" sender:nil];
    }
}

- (IBAction)login:(UIButton *)sender
{
    if([_act isAnimating])
    {
        return;
    }
    [self endEditing:NO];
    
    NSString *msg = nil;
    if ([_username.text isEqualToString: @""] || ([_username.text length] != 11))
    {
        msg = @"请输入正确的手机号!  ";
        [BasicToastInterFace showToast:msg];
        return;
    }
    
    BOOL isRight = [BasicAccountLib validateMobile:_username.text];
    
    if (!isRight)
    {
        msg = @"请输入正确的手机号!  ";
        [BasicToastInterFace showToast:msg];
        return;
    }
    
    if ([_password.text isEqualToString: @""])
    {
        msg = @"请输入密码!  ";
        [BasicToastInterFace showToast:msg];
        return;
    }
    
    
    // 获取本地所选城市
    NSString *accountName = [BasicAccountInterFace getCurAccountName];
    NSDictionary *areaInfoDic = (NSDictionary *)[BasicAccountInterFace getAccountSettingInfo:accountName key:ACCOUNTSETTING_SELECTEDAREA_DIC];
    if (areaInfoDic)
    {
        _cityId = (NSString *)[areaInfoDic objectForKey:@"areaId"];
        _cityName = [areaInfoDic objectForKey:@"areaName"];
    }
    
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/3)];
        [self addSubview:_act];
    }
    [_act startAnimating];
    
    //请求参数
    NSMutableDictionary *params = [@{@"userName":_username.text, @"password":[[BasicFileMD5Check md5With16:_password.text] lowercaseString]} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserLoginFirstStepURL];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id responseData, NSInteger statusCode)
     {
         NSLog(@"%@",responseData);
         
         AccountReciveInfo *info = [[AccountReciveInfo alloc] init];
         if (![info setJsonDataWithDic:responseData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [_act stopAnimating];
            [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             return;
         }
         
         _accessToken = info.data.token;
         if (!_accessToken || _accessToken.length == 0)
         {
             [_act stopAnimating];
             [BasicToastInterFace showToast:@"无效的token!  "];
             return;
         }
         
         
         [_act stopAnimating];
         
         //--{
         [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
         
         NSString *accountName = info.data.userId;
         [BasicAccountInterFace savePassWordInfo:accountName passWord:self.password.text];
         [BasicAccountInterFace saveUserName:accountName userName:self.username.text];
         [BasicAccountInterFace saveAdditionalInfo:accountName dic:[responseData objectForKey:@"data"]];
         
         if (_accessToken)
         {
             [BasicAccountInterFace saveToken:accountName token:_accessToken];
         }
         
         [BasicAccountInterFace chooseAccount:accountName];
         [BasicAccountInterFace setAccountSettingInfo:accountName key:ACCOUNTSETTING_ISREMMBERPASSWORD_NSNUMBER_BOOL val:[NSNumber numberWithBool:YES]];
         
         [BasicUserInterFace setLogInState:BASICUSERLONGSTATE_LONGIN_MANUAL];
         [BasicMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
         [self back:nil];
         
         if (!sender)
         {
             [self performSelector:@selector(loginToCertificate:) withObject:nil afterDelay:0.5f];
         }
         //请求参数
         //         NSString *outStr = [BasicJsonKvcClass dataToJsonString:[info.data getObjectData]];
         //--}
         //Replace
         /*--{
          NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[responseData objectForKey:@"data"] options:NSJSONWritingPrettyPrinted error:nil];
          
          NSString *outStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
          
          
          NSMutableDictionary *params = [@{@"openId":OPENID, @"outParam":outStr} mutableCopy];
          
          NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserLoginSecondStepURL];
          [AFNRequestData requestURL:url
          httpMethod:@"POST"
          params:params
          file:nil
          success:^(id respData, NSInteger statusCode)
          {
          [_act stopAnimating];
          NSLog(@"%@",respData);
          
          AccountCheckReciveInfo *checkInfo = [[AccountCheckReciveInfo alloc] init];
          if (![checkInfo setJsonDataWithDic:respData] || !info.state || [info.state isEqualToString:@"0"])
          {
          [BasicToastInterFace showToast:checkInfo.msg];
          return;
          }
          
          [BasicToastInterFace showToast:checkInfo.msg];
          
          NSString *accountName = info.data.userId;
          [BasicAccountInterFace savePassWordInfo:accountName passWord:self.password.text];
          [BasicAccountInterFace saveUserName:accountName userName:self.username.text];
          [BasicAccountInterFace saveAdditionalInfo:accountName dic:[responseData objectForKey:@"data"]];
          
          if (_accessToken)
          {
          [BasicAccountInterFace saveToken:accountName token:_accessToken];
          }
          
          [BasicAccountInterFace chooseAccount:accountName];
          //                      [BasicAccountInterFace setAccountSettingInfo:accountName key:ACCOUNTSETTING_ISREMMBERPASSWORD_NSNUMBER_BOOL val:[NSNumber numberWithBool:_isSavePassWord]];
          
          [BasicUserInterFace setLogInState:BASICUSERLONGSTATE_LONGIN_MANUAL];
          [BasicMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
          [self back:nil];
          }
          fail:^(NSError *error)
          {
          [_act stopAnimating];
          NSLog(@"%@",[error description]);
          [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
          }];
          --}*/
     }
                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

- (IBAction)registerNewUser:(id)sender
{
    if([_act isAnimating])
    {
        return;
    }
    [self endEditing:NO];
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"BasicRegisterView" owner:self options:nil]; //通过这个方法,取得我们的视图
    BasicRegisterView *SubView = [nibViews objectAtIndex:0];
    [self.viewCellManger pushViewCell:SubView animated:[BasicViewCellUPDownAdmin class]];
    
    _isAllocedLogView = NO;
}

- (IBAction)retrievePassword:(id)sender
{
    if([_act isAnimating])
    {
        return;
    }
    [self endEditing:NO];
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"BasicRetrievePasswordView" owner:self options:nil]; //通过这个方法,取得我们的视图
    BasicRetrievePasswordView *SubView = [nibViews objectAtIndex:0];
    [self.viewCellManger pushViewCell:SubView animated:[BasicViewCellUPDownAdmin class]];
    
    _isAllocedLogView = NO;
}

#pragma mark - 自己的方法
- (void)initFace
{
    self.username.keyboardType = UIKeyboardTypeDecimalPad;
    self.username.returnKeyType = UIReturnKeyNext;
    self.password.keyboardType = UIKeyboardTypeASCIICapable;
    self.password.returnKeyType = UIReturnKeyDone;
    [self.username setValue:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
    [self.username setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    self.username.tintColor = [UIColor redColor];
    
    [self.password setValue:[UIColor colorWithRed:172/255.0 green:172/255.0 blue:172/255.0 alpha:0.6] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    self.password.tintColor = [UIColor redColor];
    
    [_password setSecureTextEntry:YES];
    
    self.loginBtn.layer.cornerRadius = 5.f;
    //    [self.loginBtn setBackgroundColor:[UIColor colorWithRed:46/255.0f green:194/255.0f blue:204/255.0f alpha:1]];
    //    [self.registerBtn setBackgroundColor:[UIColor colorWithRed:253/255.0f green:167/255.0f blue:68/255.0f alpha:1]];
    
    //    BOOL isLog = [BasicAccountInterFace getIsLogingState];
    //    
    //    if (!isLog)
    {
        NSArray *array = [BasicAccountInterFace getAccountForm];
        
        NSString *userName = nil;
        //        NSString *passWord = nil;
        
        if (array && ([array count] > 0))
        {
            NSDictionary *accountDic = [array objectAtIndex:0];
            NSArray *keyArray = [accountDic allKeys];
            userName = [keyArray objectAtIndex:0];
        }
        
        _username.text = userName;
        //        _password.text = passWord;
    }
    
    //    [self rmbword:self.rmbbutton];
    
    if ([_username.text isEqualToString:@"15111111111"])
    {
        _password.text = @"474644";
    }
    if ([_username.text isEqualToString:@"15120001111"])
    {
        _password.text = @"123456";
    }
    if ([_username.text isEqualToString:@"13876543210"])
    {
        _password.text = @"123456";
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:NO];
}

- (void)handleDoubleTap
{
    if([_act isAnimating])
    {
        [_act stopAnimating];
    }
}
#pragma mark - 消息方法

#pragma mark - 代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField;
{
    PhoneScreen phoneScreen = [BasicDriver getPhoneScreenType];
    if ((phoneScreen == PHONESCREEN_4) || (phoneScreen == PHONESCREEN_5))
    {
        if ([textField isEqual:_username])
        {
            _username.restorationIdentifier = @"1";
            //将视图的Y坐标向上移动80个单位，以使下面腾出地方用于软键盘的显示
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.mainViewTopLayout.constant = -120;
            self.mainViewBottomLayout.constant = 120;
            [self layoutIfNeeded];
            [UIView commitAnimations];
        }
        else if ([textField isEqual:_password])
        {
            _password.restorationIdentifier = @"1";
            //将视图的Y坐标向上移动160个单位，以使下面腾出地方用于软键盘的显示
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.mainViewTopLayout.constant = -160;
            self.mainViewBottomLayout.constant = 160;
            [self layoutIfNeeded];
            [UIView commitAnimations];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;
{
    PhoneScreen phoneScreen = [BasicDriver getPhoneScreenType];
    if ((phoneScreen == PHONESCREEN_4) || (phoneScreen == PHONESCREEN_5))
    {
        if ([textField isEqual:_username])
        {
            _username.restorationIdentifier = @"0";
            if ([_password.restorationIdentifier isEqualToString:@"1"])
            {
                return YES;
            }
            //将视图的Y坐标向上移动80个单位，以使下面腾出地方用于软键盘的显示
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.mainViewTopLayout.constant = 0;
            self.mainViewBottomLayout.constant = 0;
            [self layoutIfNeeded];
            [UIView commitAnimations];
        }
        else if ([textField isEqual:_password])
        {
            _password.restorationIdentifier = @"0";
            if ([_username.restorationIdentifier isEqualToString:@"1"])
            {
                return YES;
            }
            //将视图的Y坐标向下移动160个单位，以使下面腾出地方用于软键盘的显示
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];
            self.mainViewTopLayout.constant = 0;
            self.mainViewBottomLayout.constant = 0;
            [self layoutIfNeeded];
            [UIView commitAnimations];
        }
    }
    return YES;
}

//#pragma mark task代理
//线程池中的任务
//- (void)runTask:(NSSTaskObj *)taskObj
//{
//    if ([taskObj.taskName isEqualToString:@"LogIn"])
//    {
//        NSData *receiveData = nil;
//        NSSNETRltState state = [NSSUserNet PostToLogIn:taskObj.annexStr password:taskObj.annexObj receiveData:&receiveData];
//        
//        taskObj.annexObj = receiveData;
//        taskObj.annexInteger = state;
//        
//        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
//    }
//    if ([taskObj.taskName isEqualToString:@"FetchUerLoginInfo"])
//    {
//        NSData *receiveData = nil;
//        NSSNETRltState state = [NSSUserNet PostToFetchUserDetailWithAccessToken:taskObj.annexObj receiveData:&receiveData];
//        
//        taskObj.annexObj = receiveData;
//        taskObj.annexInteger = state;
//        
//        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
//    }
//    
//}
//切换到主线程的任务
//- (void)runTaskOnMainThread:(NSSTaskObj *)taskObj
//{
//    if (taskObj.annexInteger != NSSNETRltState_SUCESS && taskObj.annexInteger != 400)
//    {
//        [NSSLoadingInterFace hideAllLoading];
//        [NSSToastInterFace showToast:@"网络不稳定，请重试！"];
//        return;
//    }
//    if ([taskObj.taskName isEqualToString:@"LogIn"])
//    {
//        [NSSLoadingInterFace hideLoadingWithNameID:@"LogIn"];
//        NSString *msg = nil;
//        
//        NSData *receiveData = taskObj.annexObj;
//        NSSNETRltState state = taskObj.annexInteger;
//        
//        if (state == 400 && receiveData)
//        {
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
//            msg = [infoDic objectForKeyByNSS:@"error_description"];
//            if (msg)
//            {
//                [NSSToastInterFace showToast:msg];
//                msg = nil;
//            }
//        }
//        
//        if (state == NSSNETRltState_SUCESS)
//        {
//            AccountInfo *receiveInfo = [[AccountInfo alloc] init];
//            
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
//            
//            if ([receiveInfo setJsonDataWithDic:infoDic])
//            {
//                _refreshToken = receiveInfo.refresh_token;
//                _accessToken = receiveInfo.access_token;
//                
//                NSSLoadingBase *loading = [NSSLoadingInterFace creatWithType:NSSLOADINGTYPE_CANCEL delegate:self nameID:@"FetchUerLoginInfo" annexObj:nil];
//                [NSSLoadingInterFace showLoading:loading];
//                
//                NSSTaskObj *task = [[NSSTaskObj alloc] init];
//                task.taskName = @"FetchUerLoginInfo";
//                task.taskLevel = TaskLevel_Def;
//                task.taskDelegate = self;
//                task.annexStr = _refreshToken;
//                task.annexObj = _accessToken;
//                
//                [NSSTaskPoolInterFace addTask:task];
//            }
//        }
//    }
//    if ([taskObj.taskName isEqualToString:@"FetchUerLoginInfo"])
//    {
//        [NSSLoadingInterFace hideLoadingWithNameID:@"FetchUerLoginInfo"];
//        NSString *msg = nil;
//        
//        NSData *receiveData = taskObj.annexObj;
//        NSSNETRltState state = taskObj.annexInteger;
//        
//        if (state == 400 && receiveData)
//        {
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
//            msg = [infoDic objectForKeyByNSS:@"message"];
//            if (msg)
//            {
//                [NSSToastInterFace showToast:msg];
//                msg = nil;
//            }
//        }
//        
//        if (state == 200)
//        {
//            AccountMoreInfo *receiveInfo = [[AccountMoreInfo alloc] init];
//            
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
//            
//            if ([receiveInfo setJsonDataWithDic:infoDic])
//            {
//                NSArray *loginArray = [NSSAccountInterFace getAccountForm];
//                BOOL isSave = YES;
//                for (NSDictionary *nameDic in loginArray)
//                {
//                    NSString *name = [nameDic objectForKeyByNSS:self.username.text];
//                    if ([name isEqualToString:receiveInfo.user.uid])
//                    {
//                        isSave = NO;
//                        break;
//                    }
//                }
//                NSString *accountName = receiveInfo.user.uid;
//                [NSSAccountInterFace savePassWordInfo:accountName passWord:self.password.text];
//                [NSSAccountInterFace saveUserName:accountName userName:self.username.text];
//                [NSSAccountInterFace saveRefreshToken:accountName token:_refreshToken];
//                
//                if (_accessToken)
//                {
//                    [NSSAccountInterFace saveToken:accountName token:_accessToken];
//                }
//                
//                [NSSAccountInterFace chooseAccount:accountName];
//                [NSSAccountInterFace setAccountSettingInfo:accountName key:ACCOUNTSETTING_ISREMMBERPASSWORD_NSNUMBER_BOOL val:[NSNumber numberWithBool:_isSavePassWord]];
//                
//                if (isSave)
//                {
//                    // 所选城市存入本地
//                    NSDictionary *areaDic = [[NSDictionary alloc] initWithObjectsAndKeys:_cityName, @"areaName", _cityId, @"areaId", nil];
//                    [NSSAccountInterFace setAccountSettingInfo:accountName key:ACCOUNTSETTING_SELECTEDAREA_DIC val:areaDic];
//                }
//                [BasicUserInterFace setLogInState:NSSUSERLONGSTATE_LONGIN_MANUAL];
//                [NSSMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
//                msg = @"登录成功";
//                [self back:nil];
//            }
//        }
//    }
//}


//#pragma mark loading框代理
//- (void)responseIndex:(NSInteger)index obj:(NSSLoadingBase *)view
//{
//    [NSSTaskPoolInterFace cancelTask:view.nameID];
//    [NSSLoadingInterFace hideLoadingWithNameID:view.nameID];
//}

@end
