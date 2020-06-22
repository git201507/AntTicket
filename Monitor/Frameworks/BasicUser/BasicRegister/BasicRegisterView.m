//
//  BasicRegisterView.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicRegisterView.h"
#import "BasicToastInterFace.h"
#import "BasicViewCellUPDownAdmin.h"
#import "BasicUserAgreementView.h"
#import "BasicAccountLib.h"
#import "UIColor+Hex.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicUserDef.h"
#import "BasicUserNet.h"
#import "BasicWindowInterFace.h"
#import "BasicUserMangerLogIn.h"
#import "BasicAccountInterFace.h"
#import "UIImageView+WebCache.h"

@interface BasicRegisterView ()
{
    NSString *_sn;
    NSString *_code;
}

@property (nonatomic, strong) UIActivityIndicatorView *act;
@property (nonatomic, strong) UIImageView *imageCodeView;
@end

@implementation BasicRegisterView


- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    
    self.phonenum.keyboardType = UIKeyboardTypeNumberPad;
    self.phonenum.returnKeyType = UIReturnKeyNext;
    self.phonenum.tintColor = [UIColor redColor];
    
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
    self.qrpassword.returnKeyType = UIReturnKeyNext;
    self.qrpassword.tintColor = [UIColor redColor];
    
    self.yqwords.keyboardType = UIKeyboardTypeASCIICapable;
    self.yqwords.returnKeyType = UIReturnKeyDone;
    self.yqwords.tintColor = [UIColor redColor];
    
    self.registBtn.layer.cornerRadius = 5.f;
    
    _imageCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 135, 80, 20)];
    [self changeVerifyImage];
    
    [self addSubview:_imageCodeView];
    
    UIButton *imageCodeBtn= [[UIButton alloc] initWithFrame:CGRectMake(220, 135, 80, 20)];
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
    [self.viewCellManger popToLastViewCell:[BasicViewCellUPDownAdmin class]];
}

- (void)changeVerifyImage
{
    AccountInfo *accountInfo = [[AccountInfo alloc] init];
    [accountInfo setJsonDataWithDic:[BasicAccountInterFace getAdditionalInfoWithAccountName:[BasicAccountInterFace getCurAccountName]]];
    
    NSString *urlPath = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserAppYzCodeURL];
    
    NSString *path = [NSString stringWithFormat:urlPath, [[NSDate date] timeIntervalSince1970], @"1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p"];
    
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
    [self endEditing:NO];
    
    if(_imagenum.text.length == 0)
    {
        [BasicToastInterFace showToast:@"请输入图形验证码!  "];
        return;
    }
    
    NSString *msg = nil;
    if ([_phonenum.text isEqualToString: @""] || ([_phonenum.text length] != 11))
    {
        msg = @"请输入正确的手机号";
        UIAlertView*  alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    BOOL isRight = [BasicAccountLib validateMobile:_phonenum.text];
    if (!isRight)
    {
        msg = @"请输入正确的手机号";
        UIAlertView*  alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
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
    NSMutableDictionary *params = [@{@"phone":_phonenum.text} mutableCopy];
    
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserRegistCheckPhoneNumberExistURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         AccountCheckReciveInfo *checkInfo = [[AccountCheckReciveInfo alloc] init];
         if (![checkInfo setJsonDataWithDic:respData] || !checkInfo.state || [checkInfo.state isEqualToString:@"0"])
         {
             [_act stopAnimating];
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", checkInfo.msg]];
             return;
         }
         

     NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_FetchShortMessageVerifyCodeURL(_phonenum.text, [_imagenum.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p")];
         
         //请求参数
//         NSMutableDictionary *params = [@{@"mobileNumber":_phonenum.text,@"yz":[_imagenum.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"memberId":@"1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p"} mutableCopy];
//         
//         NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_FetchShortMessageVerifyChineseCodeURL];
         
         [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
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
                               failure:^(NSError *error)
          {
              [_act stopAnimating];
              NSLog(@"%@",[error description]);
              [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
          }];
     }
                          failure:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
}

- (IBAction)userAgreement:(id)sender
{
    if ([_act isAnimating])
    {
        return;
    }
    
    [self endEditing:NO];
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"BasicRegisterView" owner:self options:nil]; //通过这个方法,取得我们的视图
    BasicUserAgreementView *SubView = [nibViews objectAtIndex:3];
    [self.viewCellManger pushViewCell:SubView animated:[BasicViewCellAdmin class]];
}
#pragma mark - 自己的方法
- (void)handleDoubleTap
{
    if([_act isAnimating])
    {
        [_act stopAnimating];
    }
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if (self.phonenum.editing)
    {
        [self.securitynum becomeFirstResponder];
        return YES;
    }
    if (self.securitynum.editing)
    {
        [self.password becomeFirstResponder];
        return YES;
    }
    if (self.password.editing)
    {
        [self.qrpassword becomeFirstResponder];
        return YES;
    }
    if (self.qrpassword.editing)
    {
        [self.yqwords becomeFirstResponder];
        return YES;
    }
    if (self.yqwords.editing)
    {
        [self.yqwords resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return ([scan scanInt:&val] && [scan isAtEnd]);
}

- (void) verifyCode
{
    //验证码正确
    if(!_act)
    {
        _act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
        [_act setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
        [_act setCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/3)];
        [self addSubview:_act];
    }
    [_act startAnimating];
    
    //请求参数
    NSMutableDictionary *params = [@{@"pageVerifyCode":_securitynum.text, @"phoneNumber":_phonenum.text} mutableCopy];
    
    //校验验证码是否正确
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserRegistValidateUserPhoneVerifyCodeURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         
         AccountCheckReciveInfo *info = [[AccountCheckReciveInfo alloc] init];
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             [_act stopAnimating];
             //验证码错误
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             return;
         }
         
         //请求参数
         NSMutableDictionary *params = [@{@"userName":_phonenum.text, @"code":_securitynum.text, @"password":_password.text, @"inviteCode":_yqwords.text, @"openId":@""} mutableCopy];
         //开始第一步注册
         NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserRegistFirstStepURL];
         [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
          {
              NSLog(@"%@",respData);
              
              AccountReciveInfo *info = [[AccountReciveInfo alloc] init];
              if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
              {
                  //第一步注册失败
                  [_act stopAnimating];
                 [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
                  return;
              }
              
              [BasicToastInterFace showToast:@"恭喜您注册成功!  "];
              [self back:nil];
              
              if([[[BasicUserMangerLogIn Instance] getLoginView] respondsToSelector:@selector(registLogin:)])
              {
                  [[[BasicUserMangerLogIn Instance] getLoginView] performSelector:@selector(registLogin:) withObject: [NSString stringWithFormat:@"%@-%@", _phonenum.text, _password.text] afterDelay:1];
              }
              
              /*replace --{
               
               //请求参数
               NSMutableDictionary *params = [@{@"phone":_phonenum.text, @"openId":OPENID} mutableCopy];
               
               //第一步注册成功，开始第二步
               NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserRegistSecondStepURL];
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
               //第二步注册失败
               [BasicToastInterFace showToast:checkInfo.msg];
               return;
               }
               
               //注册操作成功
               UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"注册信息：" message:@"恭喜您注册成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
               [alert show];
               }
               fail:^(NSError *error)
               {
               [_act stopAnimating];
               NSLog(@"%@",[error description]);
               [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
               }];
               //--}
               */
          }
                               failure:^(NSError *error)
          {
              [_act stopAnimating];
              NSLog(@"%@",[error description]);
              [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
          }];
     }
                          failure:^(NSError *error)
     {
         [_act stopAnimating];
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
         return;
     }];
}

- (IBAction)registerNewUser
{
//    [self back:nil];
//    
//    if([[[BasicUserMangerLogIn Instance] getLoginView] respondsToSelector:@selector(registLogin:)])
//    {
//        [[[BasicUserMangerLogIn Instance] getLoginView] performSelector:@selector(registLogin:) withObject: [NSString stringWithFormat:@"%@-%@", _phonenum.text, _password.text] afterDelay:1];
//    }
//    return;
    if([_act isAnimating])
    {
        return;
    }
    [self endEditing:NO];
    NSString *msg = nil;
    
    //手机号位数不足或超长时提示
    if ([_phonenum.text isEqualToString: @""] || ([_phonenum.text length] != 11))
    {
        msg = @"请输入正确的手机号";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    //手机号不在运营商号段内提示
    if (![BasicAccountLib validateMobile:_phonenum.text])
    {
        msg = @"请输入正确的手机号";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
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

    if ([_yqwords.text length] == 0)
    {
        [self verifyCode];
        return;
    }
    //请求参数
    NSMutableDictionary *params = [@{@"inviteCode":_yqwords.text} mutableCopy];
    
    //判断邀请码是否存在
    NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserRegistCheckInviteCodeExistURL];
    [AFNRequestData requestAFURL:url httpMethod:METHOD_POST parameters:params succeed:^(id respData)
     {
         NSLog(@"%@",respData);
         
         AccountCheckReciveInfo *info = [[AccountCheckReciveInfo alloc] init];
         if (![info setJsonDataWithDic:respData] || !info.state || ![info.state isEqualToString:@"1"])
         {
             //判断邀请码不存在
             [BasicToastInterFace showToast:[NSString stringWithFormat:@"%@!  ", info.msg]];
             return;
         }
         
         //校验手机验证码
         [self verifyCode];
     }
                          failure:^(NSError *error)
     {
         NSLog(@"%@",[error description]);
         [BasicToastInterFace showToast:NETERROR_DISCONNECTION];
     }];
    
}
#pragma mark - 消息方法


#pragma mark - 代理方法

/*
 //线程池中的任务
 - (void)runTask:(NSSTaskObj *)taskObj
 {
 if ([taskObj.taskName isEqualToString:@"RegisterVerify"])
 {
 NSData *receiveData = nil;
 NSSNETRltState state = [NSSUserNet PostToRegisterVerify:taskObj.annexStr receiveData:&receiveData];
 
 taskObj.annexObj = receiveData;
 taskObj.annexInteger = state;
 
 [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
 }
 }
 
 //切换到主线程的任务
 - (void)runTaskOnMainThread:(NSSTaskObj *)taskObj
 {
 if (taskObj.annexInteger != NSSNETRltState_SUCESS)
 {
 [NSSLoadingInterFace hideAllLoading];
 return;
 }
 NSString *msg = nil;
 if ([taskObj.taskName isEqualToString:@"RegisterVerify"])
 {
 [NSSLoadingInterFace hideLoadingWithNameID:@"RegisterVerify"];
 NSData *receiveData = taskObj.annexObj;
 NSSNETRltState state = taskObj.annexInteger;
 if (state == NSSNETRltState_SUCESS && receiveData)
 {
 NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
 //NSNumber *infocode = [infoDic objectForKeyByNSS:@"infocode"];
 
 //if ([infocode intValue] == 1)
 //{
 //    NSDictionary *data = [infoDic objectForKeyByNSS:@"data"];
 //    _sn = [data objectForKeyByNSS:@"sn"];
 //    _code = [data objectForKeyByNSS:@"code"];
 //    [self registerNewUser];
 //}
 //else if([infocode intValue] == -1)
 //{
 //    msg = [infoDic objectForKeyByNSS:@"infomessage"];
 //}
 
 NSNumber *infocode = [infoDic objectForKeyByNSS:@"code"];
 
 if ([infocode intValue] == 0)
 {
 NSDictionary *data = [infoDic objectForKeyByNSS:@"data"];
 _sn = [data objectForKeyByNSS:@"sn"];
 _code = [data objectForKeyByNSS:@"code"];
 [self registerNewUser];
 }
 else
 {
 msg = [infoDic objectForKeyByNSS:@"message"];
 }
 }
 else if(state == NSSNETRltState_NETERROR)
 {
 msg = @"请检查您的网络";
 }
 }
 if (msg)
 {
 UIAlertView*  alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
 [alert show];
 msg = nil;
 }
 }
 
 #pragma mark loading框代理
 - (void)responseIndex:(NSInteger)index obj:(NSSLoadingBase *)view
 {
 if ([view.nameID isEqualToString:@"ConfirmPhone"])
 {
 if (index == 0)
 {
 NSSLoadingBase *loading = [NSSLoadingInterFace creatWithType:NSSLOADINGTYPE_CANCEL delegate:self nameID:@"RegisterVerify" annexObj:nil];
 [NSSLoadingInterFace showLoading:loading];
 NSSTaskObj *task = [[NSSTaskObj alloc] init];
 task.taskName = @"RegisterVerify";
 task.taskLevel = TaskLevel_Def;
 task.taskDelegate = self;
 task.annexStr = _phonenum.text;
 
 [NSSTaskPoolInterFace addTask:task];
 }
 }
 [NSSTaskPoolInterFace cancelTask:view.nameID];
 [NSSLoadingInterFace hideLoadingWithNameID:view.nameID];
 }*/

@end
