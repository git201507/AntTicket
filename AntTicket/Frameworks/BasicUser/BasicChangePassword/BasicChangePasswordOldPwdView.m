//
//  NSSChangePasswordOldPwdView.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicChangePasswordOldPwdView.h"
#import "UIImage+EX.h"
#import "BasicViewCellAdmin.h"
#import "BasicToastInterFace.h"
#import "BasicAccountInterFace.h"
#import "BasicChangePasswordNewPwdView.h"
#import "BasicAccountLib.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicUserDef.h"
#import "UIColor+Hex.h"
#import "BasicUserNet.h"
#import "BasicUserInterFace.h"
#import "BasicUserMangerLogIn.h"
#import "UIImageView+WebCache.h"

@interface BasicChangePasswordOldPwdView()
{
    
}

@property (nonatomic, strong) UIActivityIndicatorView *act;
@property (nonatomic, strong) UIImageView *imageCodeView;
@end

@implementation BasicChangePasswordOldPwdView

- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    
    self.imagenum.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.imagenum.returnKeyType = UIReturnKeyNext;
    self.imagenum.tintColor = [UIColor redColor];
    
    self.securitynum.keyboardType = UIKeyboardTypeNumberPad;
    self.securitynum.returnKeyType = UIReturnKeyNext;
    self.securitynum.tintColor = [UIColor redColor];
    
    self.password.keyboardType = UIKeyboardTypeASCIICapable;
    [_password setSecureTextEntry:YES];
    self.password.returnKeyType = UIReturnKeyNext;
    self.password.tintColor = [UIColor redColor];
    
    
    self.qrpassword.keyboardType = UIKeyboardTypeASCIICapable;
    [_qrpassword setSecureTextEntry:YES];
    self.qrpassword.returnKeyType = UIReturnKeyDone;
    self.qrpassword.tintColor = [UIColor redColor];
    
    _imageCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 82, 80, 20)];
    [self changeVerifyImage];

    [self addSubview:_imageCodeView];

    UIButton *imageCodeBtn= [[UIButton alloc] initWithFrame:CGRectMake(220, 82, 80, 20)];
    [imageCodeBtn addTarget:self action:@selector(changeVerifyImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:imageCodeBtn];
    
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
- (IBAction)back:(UIButton *)sender
{
    [self endEditing:NO];
    [self.viewCellManger popToLastViewCell:[BasicViewCellAdmin class]];
}

- (void)changeVerifyImage
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];

    NSString *urlPath = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserAppYzCodeURL];
    
    NSString *path = [NSString stringWithFormat:urlPath, [[NSDate date] timeIntervalSince1970], accountInfo.userId];
    
    [_imageCodeView sd_setImageWithURL:[NSURL URLWithString:path] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         NSLog(@"这里可以在图片加载完成之后做些事情");
     }];
}

- (IBAction)getnum:(UIButton *)sender
{
    if([_act isAnimating])
    {
        return;
    }
    
    if(_imagenum.text.length == 0)
    {
        [BasicToastInterFace showToast:@"请输入图形验证码!  "];
        return;
    }
    
    if(_imagenum.text.length != 4)
    {
        [BasicToastInterFace showToast:@"图形验证码不正确!  "];
        return;
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
    NSMutableDictionary *params = [@{@"phone":[BasicAccountInterFace getUserNameWithAccountName:[BasicAccountInterFace getCurAccountName]]} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserRegistCheckPhoneNumberExistURL];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         AccountCheckReciveInfo *checkInfo = [[AccountCheckReciveInfo alloc] init];
         if (![checkInfo setJsonDataWithDic:respData] || !checkInfo.state || [checkInfo.state isEqualToString:@"1"])
         {
             //手机号不存在，返回。
             [_act stopAnimating];
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", checkInfo.msg]];
             return;
         }
         
         //请求参数
         //NSMutableDictionary *params = [@{@"mobileNumber":[BasicAccountInterFace getUserNameWithAccountName:[BasicAccountInterFace getCurAccountName]], @"yz":_imagenum.text} mutableCopy];
         
         AccountInfo *accountInfo = [[AccountInfo alloc] init];
         [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
         
         NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_FetchShortMessageVerifyCodeURL([BasicAccountInterFace getUserNameWithAccountName:[BasicAccountInterFace getCurAccountName]], _imagenum.text, accountInfo.userId)];
         
         [AFNRequestData requestURL:url
                         httpMethod:@"GET"
                             params:nil
                               file:nil
                            success:^(id respData, NSInteger statusCode)
          {
              [_act stopAnimating];
              if (!respData || ![respData isEqualToString:@"success:120"])
                  
              {
                  if([respData isEqualToString:@"codeerror"])
                  {
                      [BasicToastInterFace showToast:@"图形验证码填写错误！ "];
                      return;
                  }
                  //获取短信验证码失败，停止转圈
                  if([respData isEqualToString:@"haveMakeOutError"])
                  {
                      [BasicToastInterFace showToast:@"在一段时间内不能重复生成验证码！ "];
                      return;
                  }
                  [BasicToastInterFace showToast:@"手机验证码发送失败，请稍后重试！ "];
                  return;
              }
              
              [BasicToastInterFace showToast:@"您生成验证码并发送到您的手机！ "];
              //获取短信验证码成功
              NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateSecondLabel:) userInfo:nil repeats:YES];
              
              _seconds = 59;
              
              NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
              [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
              _getnum.titleLabel.text = @"60秒后重新发送";
              [_getnum setTitleColor:[UIColor colorWithHexString:@"686868"] forState:UIControlStateNormal];
              [_getnum setTitle:@"60秒后重新发送" forState:UIControlStateNormal];
          }
                               fail:^(NSError *error)
          {
              [_act stopAnimating];
              NSLog(@"%@",[error description]);
              [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
          }];
     }
                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

- (void)updateSecondLabel:(id)sender
{
    if (_seconds <= 0)
    {
        self.getnum.userInteractionEnabled = YES;
        self.getnum.titleLabel.text = @"重新获取验证码";
        [self.getnum setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        [self.getnum setTitleColor:[UIColor colorWithHexString:@"ff3300"] forState:UIControlStateNormal];
        
        NSTimer *timer = (NSTimer *)sender;
        [timer invalidate];
        timer = nil;
    }
    else
    {
        int seconds = _seconds % 60;
        NSString *strTime = [NSString stringWithFormat:@"%d秒后重新发送", seconds];
        self.getnum.userInteractionEnabled = NO;
        self.getnum.titleLabel.text = strTime;
        [self.getnum setTitle:strTime forState:UIControlStateNormal];
        _seconds--;
    }
}

- (IBAction)commit:(UIButton *)sender
{
    if([_act isAnimating])
    {
        return;
    }
    [self endEditing:NO];
    NSString *msg = nil;
    
    if (_securitynum.text.length == 0)
    {
        msg = @"请输入验证码！";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (_password.text.length == 0)
    {
        msg = @"请输入密码！";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if ([_qrpassword.text length] == 0)
    {
        msg = @"请再次输入密码！";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (![_password.text isEqualToString:_qrpassword.text])
    {
        msg = @"两次密码不同";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
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
    NSMutableDictionary *params = [@{@"token":[BasicAccountInterFace getTokenWithAccountName:[BasicAccountInterFace getCurAccountName]], @"verifyCode":_securitynum.text, @"newpassword":_password.text, @"anewpassword":_qrpassword.text }mutableCopy];
    
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserRegistModifyPasswordURL];
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
     {
         [_act stopAnimating];
         NSLog(@"%@",respData);
         
         //登录过期
         if (statusCode == NSSNETRltState_OVERDUE)
         {
             [BasicToastInterFace showToast:@"登录已过期，请重新登录!  "];
             [self back:nil];
             [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
             [BasicUserInterFace doLogIn];
             return;
         }
         
         AccountCheckReciveInfo *info = [[AccountCheckReciveInfo alloc] init];
         if (![info setJsonDataWithDic:respData] || !info.state || [info.state isEqualToString:@"0"])
         {
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
  
             if([info.msg isEqualToString:@"当前用户登录状态异常"])
             {
                 [self back:nil];
                 [BasicUserMangerLogIn Instance].LogInState = BASICUSERLONGSTATE_OVERDUE;
                 [BasicUserInterFace doLogIn];
             }

             return;
         }
         
         [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
         [self back:nil];
     }
                          fail:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}
#pragma mark - 自己的方法
- (void)handleDoubleTap
{
    if([_act isAnimating])
    {
        [_act stopAnimating];
    }
}

- (void)toSetNewPassword:(NSString *)session
{
    [self endEditing:NO];
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"BasicChangePassword" owner:self options:nil]; //通过这个方法,取得我们的视图
    BasicChangePasswordNewPwdView *SubView = [nibViews objectAtIndex:1];
    [SubView setValue:session forKey:@"session"];
    [self.viewCellManger pushViewCell:SubView animated:[BasicViewCellAdmin class]];
}

- (BOOL) ValidateUserName:(NSString *)username
{
    if ((username.length < 6) || (username.length > 15))
    {
        return NO;
    }
    const char *cusername = [username UTF8String];
    BOOL isChar = NO;
    BOOL isNum = NO;
    for (int i = 0; i < strlen(cusername); i++)
    {
        if ((cusername[i] >= '0') && (cusername[i] <= '9'))
        {
            isNum = YES;
        }
        else if (((cusername[i] >= 'a') && (cusername[i] <= 'z'))
                 || ((cusername[i] >= 'A') && (cusername[i] <= 'Z')))
        {
            isChar = YES;
        }
        else
        {
            return NO;
        }
    }
    if (isNum && isChar)
    {
        return YES;
    }
    return NO;
}

- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return ([scan scanInt:&val] && [scan isAtEnd]);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if(self.securitynum.editing)
    {
        [self.password becomeFirstResponder];
        return YES;
    }
    if(self.password.editing)
    {
        [self.qrpassword becomeFirstResponder];
        return YES;
    }
    if(self.qrpassword.editing)
    {
        [self.qrpassword resignFirstResponder];
        return NO;
    }
    return YES;
}

//- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
//{
//    if(self.passwordTextField.editing)
//    {
//        [self.passwordTextField resignFirstResponder];
//    }
//    return YES;
//}

#pragma mark - 消息方法


#pragma mark - 代理方法
//线程池中的任务
//- (void)runTask:(NSSTaskObj *)taskObj
//{
//    if ([taskObj.taskName isEqualToString:@"CommitNewPassword"])
//    {
//        NSData *receiveData = nil;
//        NSSNETRltState state = [NSSUserNet PostToChangePswdCommit:taskObj.annexStr password:taskObj.annexObj receiveData:&receiveData];
//        
//        taskObj.annexObj = receiveData;
//        taskObj.annexInteger = state;
//        
//        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
//    }
//}

#pragma mark task代理
//切换到主线程的任务
//- (void)runTaskOnMainThread:(NSSTaskObj *)taskObj
//{
//    if (taskObj.annexInteger != NSSNETRltState_SUCESS)
//    {
//        [NSSLoadingInterFace hideAllLoading];
//        [NSSToastInterFace showToast:@"网络不稳定，请重试！"];
//        return;
//    }
//    if ([taskObj.taskName isEqualToString:@"CommitNewPassword"])
//    {
//        [NSSLoadingInterFace hideLoadingWithNameID:@"CommitNewPassword"];
//        
//        NSString *msg = nil;
//        
//        NSData *receiveData = taskObj.annexObj;
//        NSSNETRltState state = taskObj.annexInteger;
//        
//        if (state == NSSNETRltState_SUCESS)
//        {
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
//            NSString *infoCode = [infoDic objectForKeyByNSS:@"code"];
//            
//            msg = [infoDic objectForKeyByNSS:@"msg"];
//            if (![infoCode isEqualToString:@"success"])
//            {
//                [NSSToastInterFace showToast:msg];
//                msg = nil;
//                return;
//            }
//            
//            NSSYESNoLoadingInfo *yesnoLoading = [[NSSYESNoLoadingInfo alloc] init];
//            yesnoLoading.title = @"修改密码：";
//            yesnoLoading.message = @"恭喜您修改密码成功！";
//            NSArray *btnNameArray = [[NSArray alloc] initWithObjects:@"确定", nil];
//            yesnoLoading.btnNameArray  = btnNameArray;
//            NSSLoadingBase *loading = [NSSLoadingInterFace creatWithType:NSSLOADINGTYPE_YESNO delegate:self nameID:@"ChangePasswordSuccess" annexObj:yesnoLoading];
//            [NSSLoadingInterFace showLoading:loading];
//            return;
//        }
//    }
//}

#pragma mark - loading框代理
//- (void)responseIndex:(NSInteger)index obj:(NSSLoadingBase *)view
//{
//    if ([view.nameID isEqualToString:@"ChangePasswordSuccess"])
//    {
//        if (index == 0)
//        {
//            [self.viewCellManger popToOriginal:[NSSViewCellAdmin class]];
//        }
//    }
//    [NSSTaskPoolInterFace cancelTask:view.nameID];
//    [NSSLoadingInterFace hideLoadingWithNameID:view.nameID];
//}

@end
