//
//  BasicRetrievePasswordView.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicRetrievePasswordView.h"
#import "BasicUserDef.h"
#import "BasicViewCellUPDownAdmin.h"
#import "BasicAccountLib.h"
#import "BasicConfigPath.h"
#import "AFNRequestData.h"
#import "BasicToastInterFace.h"
#import "UIColor+Hex.h"
#import "BasicUserNet.h"
#import "UIImageView+WebCache.h"
#import "BasicAccountInterFace.h"
#import "BasicUserMangerLogIn.h"

@interface BasicRetrievePasswordView ()
{
    
}

@property (nonatomic, strong) UIActivityIndicatorView *act;
@property (nonatomic, strong) UIImageView *imageCodeView;

@end

@implementation BasicRetrievePasswordView

- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    
    self.phonenum.returnKeyType = UIReturnKeyNext;
    self.phonenum.tintColor = [UIColor redColor];
    
    self.imagenum.returnKeyType = UIReturnKeyNext;
    self.imagenum.tintColor = [UIColor redColor];
    
    self.securitynum.returnKeyType = UIReturnKeyDone;
    self.securitynum.tintColor = [UIColor redColor];
    
    _imageCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(220, 155, 80, 20)];
    [self changeVerifyImage];
    
    [self addSubview:_imageCodeView];
    
    UIButton *imageCodeBtn= [[UIButton alloc] initWithFrame:CGRectMake(220, 155, 80, 20)];
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
    
    if(_imagenum.text.length == 0)
    {
        [BasicToastInterFace showToast:@"请输入图形验证码!  "];
        return;
    }
    
    NSString *msg = nil;
    BOOL isRight = [BasicAccountLib validateMobile:_phonenum.text];
    if ([_phonenum.text isEqualToString: @""] || ([_phonenum.text length] != 11))
    {
        msg = @"请输入正确的手机号";
    }
    else if (!isRight)
    {
        msg = @"请输入正确的手机号";
    }
    else
    {
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
                 [BasicToastInterFace showToast:@"手机号不存在!  "];
                 return;
             }
             
             //请求参数
             //NSMutableDictionary *params = [@{@"mobileNumber":_phonenum.text} mutableCopy];
             
             NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_FetchShortMessageVerifyCodeURL(_phonenum.text, [_imagenum.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], @"1a2b3c4d5e6f7g8h9i0j1k2l3m4n5o6p")];
             [AFNRequestData requestURL:url
                             httpMethod:@"POST"
                                 params:nil
                                   file:nil
                                success:^(id respData, NSInteger statusCode)
              {
                  
                  [_act stopAnimating];
                  //                  if (!respData || ![respData isEqualToString:@"haveMakeOutError"])
                  
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
    [self.phonenum resignFirstResponder];
    
    if (msg)
    {
        UIAlertView*  alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        msg = nil;
    }
}


- (IBAction)commit:(id)sender
{
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
    
    [self verifyCode];
}

#pragma mark - 自己的方法
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
    [AFNRequestData requestURL:url
                    httpMethod:@"POST"
                        params:params
                          file:nil
                       success:^(id respData, NSInteger statusCode)
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
         NSMutableDictionary *params = [@{@"mobile":_phonenum.text, @"code":_securitynum.text} mutableCopy];
         
         NSString *url = [[BasicConfigPath getConfigPathWithKey:@"MAINNETPATH"] stringByAppendingString:Account_UserRegistRetrievePasswordURL];
         [AFNRequestData requestURL:url
                         httpMethod:@"POST"
                             params:params
                               file:nil
                            success:^(id respData, NSInteger statusCode)
          {
              [_act stopAnimating];
              AccountRetreivePasswordInfo *info = [[AccountRetreivePasswordInfo alloc] init];
              if (![info setJsonDataWithDic:respData] || !info.data || info.data.length == 0)
              {
                  //手机号不存在，返回。
                  [_act stopAnimating];
                  [BasicToastInterFace showToast:@"密码找回失败!  "];
                  return;
              }
              //密码找回成功
              if([[[BasicUserMangerLogIn Instance] getLoginView] respondsToSelector:@selector(retrieveUserName:)])
              {
                  [[[BasicUserMangerLogIn Instance] getLoginView] performSelector:@selector(retrieveUserName:) withObject: _phonenum.text];
              }
              
              UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"密码找回成功" message:[NSString stringWithFormat:@"新密码:%@\r\n请您尽快登录，重新修改密码！", info.data] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
              [alert show];
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

- (void)handleDoubleTap
{
    if([_act isAnimating])
    {
        [_act stopAnimating];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:NO];
}

- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return ([scan scanInt:&val] && [scan isAtEnd]);
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
#pragma mark - 消息方法


#pragma mark - 代理方法

#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            [self back:nil];
            break;
        }
        default:
            break;
    }
}


#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if (self.phonenum.editing)
    {
        [self.securitynum becomeFirstResponder];
        return YES;
    }
    if (self.securitynum.editing)
    {
        [self.securitynum resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
/*
 #pragma mark task代理
 //线程池中的任务
 - (void)runTask:(NSSTaskObj *)taskObj
 {
 if ([taskObj.taskName isEqualToString:@"RetrievePswdVerify"])
 {
 NSData *receiveData = nil;
 NSSNETRltState state = [NSSUserNet PostToRetrievePswdVerify:_phonenum.text receiveData:&receiveData];
 
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
 if ([taskObj.taskName isEqualToString:@"RetrievePswdVerify"])
 {
 [NSSLoadingInterFace hideLoadingWithNameID:@"RetrievePswdVerify"];
 NSData *receiveData = taskObj.annexObj;
 NSSNETRltState state = taskObj.annexInteger;
 if (state == NSSNETRltState_SUCESS && receiveData)
 {
 NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
 //NSNumber *infocode = [infoDic objectForKeyByNSS:@"infocode"];
 
 //if ([infocode intValue] == 1)
 NSNumber *infocode = [infoDic objectForKeyByNSS:@"code"];
 
 if ([infocode intValue] == 0)
 {
 NSDictionary *data = [infoDic objectForKeyByNSS:@"data"];
 _sn = [data objectForKeyByNSS:@"sn"];
 _code = [data objectForKeyByNSS:@"code"];
 [self retrieveVerificationCode];
 }
 //else if([infocode intValue] == -1)
 //{
 //    msg = [infoDic objectForKeyByNSS:@"infomessage"];
 //}
 else
 {
 msg = [infoDic objectForKeyByNSS:@"message"];
 }
 }
 else if (state == NSSNETRltState_NETERROR)
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
 
 #pragma mark - loading框代理
 - (void)responseIndex:(NSInteger)index obj:(NSSLoadingBase *)view
 {
 [NSSTaskPoolInterFace cancelTask:view.nameID];
 [NSSLoadingInterFace hideLoadingWithNameID:view.nameID];
 }*/

@end
