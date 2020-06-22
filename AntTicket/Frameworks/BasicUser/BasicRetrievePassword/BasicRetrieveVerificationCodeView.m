//
//  BasicRetrieveVerificationCodeView.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicRetrieveVerificationCodeView.h"
#import "BasicRetrieveCommitView.h"
#import "UIImage+EX.h"
#import "BasicViewCellAdmin.h"

@implementation BasicRetrieveVerificationCodeView

- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    self.verifyCodeBtn.userInteractionEnabled = NO;
    [self.codeTextField setValue:[UIColor colorWithRed:237/255.0 green:249/255.0 blue:251/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.codeTextField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    self.codeTextField.returnKeyType = UIReturnKeyDone;
    UIImage *originalImage1 = [UIImage imageNamed:@"btn_line_bk"];
    UIImage *resizeImage1 = [UIImage resizableImageWithAll:originalImage1];
    [self.verifyCodeBtn setBackgroundImage:resizeImage1 forState:UIControlStateNormal];
    
    if (_accountStr.length > 7)
    {
        self.noticeLabel.text = [NSString stringWithFormat:@"请输入手机号%@****%@收到的短信验证码。", [_accountStr substringToIndex:3], [_accountStr substringFromIndex:7]];
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateSecondLabel:) userInfo:nil repeats:YES];
    
    _seconds = 59;
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    self.getCodeBtn.backgroundColor = [UIColor colorWithRed:150/255.0 green:157/255.0 blue:163/255.0 alpha:1];
    self.getCodeBtn.titleLabel.text = @"60秒后重新发送";
    [_getCodeBtn setTitle:@"60秒后重新发送" forState:UIControlStateNormal];
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

- (IBAction)checkVerify:(UIButton *)sender
{
    [self endEditing:NO];
    NSString *msg;
    UIAlertView *alert;
    
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 40, self.bounds.size.height / 2 - 40, 80, 80)];
    [self addSubview:loading];
    [loading startAnimating];
    
    //    NSSTaskObj *task = [[NSSTaskObj alloc] init];
    //    task.taskName = @"CheckVerify";
    //    task.taskLevel = TaskLevel_Def;
    //    task.taskDelegate = self;
    //    task.annexStr = _accountStr;
    //    task.annexArray = [[NSArray alloc] initWithObjects:self.codeTextField.text, _snStr, nil];
    //    
    //    [NSSTaskPoolInterFace addTask:task];
    //    
    if (msg)
    {
        alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        msg = nil;
    }
}

- (IBAction)repeatGetCode:(UIButton *)sender
{
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 40, self.bounds.size.height / 2 - 40, 80, 80)];
    [self addSubview:loading];
    [loading startAnimating];
    //    
    //    NSSTaskObj *task = [[NSSTaskObj alloc] init];
    //    task.taskName = @"RetrievePasswordVerify";
    //    task.taskLevel = TaskLevel_Def;
    //    task.taskDelegate = self;
    //    task.annexStr = _accountStr;
    //    
    //    [NSSTaskPoolInterFace addTask:task];
}

#pragma mark - 自己的方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if (self.codeTextField.editing)
    {
        [self.codeTextField resignFirstResponder];
    }
    return YES;
}

- (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return ([scan scanInt:&val] && [scan isAtEnd]);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.verifyCodeBtn.userInteractionEnabled = YES;
}

- (void)retrievePasswordCommit
{
    [self endEditing:NO];
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"BasicRetrievePasswordView" owner:self options:nil]; //通过这个方法,取得我们的视图
    BasicRetrieveCommitView *SubView = [nibViews objectAtIndex:2];
    [SubView setValue:_session forKey:@"sessionStr"];
    [SubView setValue:_accountStr forKey:@"accountStr"];
    [self.viewCellManger pushViewCell:SubView animated:[BasicViewCellAdmin class]];
    
}

- (void)updateSecondLabel:(id)sender
{
    if (_seconds <= 0)
    {
        _getCodeBtn.userInteractionEnabled = YES;
        self.getCodeBtn.titleLabel.text = @"重新获取验证码";
        [_getCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        UIImage *originalImage1 = [UIImage imageNamed:@"btn_line_bk"];
        UIImage *resizeImage1 = [UIImage resizableImageWithAll:originalImage1];
        [_getCodeBtn setBackgroundImage:resizeImage1 forState:UIControlStateNormal];
        _getCodeBtn.backgroundColor = [UIColor clearColor];
        NSTimer *timer = (NSTimer *)sender;
        [timer invalidate];
        timer = nil;
    }
    else
    {
        int seconds = _seconds % 60;
        NSString *strTime = [NSString stringWithFormat:@"%d秒后重新发送", seconds];
        _getCodeBtn.userInteractionEnabled = NO;
        self.getCodeBtn.titleLabel.text = strTime;
        [_getCodeBtn setTitle:strTime forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor colorWithRed:237/255.0 green:249/255.0 blue:251/255.0 alpha:1] forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor colorWithRed:237/255.0 green:249/255.0 blue:251/255.0 alpha:1] forState:UIControlStateHighlighted];
        UIImage *image = nil;
        [_getCodeBtn setBackgroundImage:image forState:UIControlStateNormal];
        _getCodeBtn.backgroundColor = [UIColor colorWithRed:150/255.0 green:157/255.0 blue:163/255.0 alpha:1];
        _seconds--;
    }
}
#pragma mark - 消息方法


#pragma mark - 代理方法
#pragma mark task代理
//线程池中的任务
//- (void)runTask:(NSSTaskObj *)taskObj
//{
//    if ([taskObj.taskName isEqualToString:@"RetrievePasswordVerify"])
//    {
//        NSData *receiveData = nil;
//        NSSNETRltState state = [NSSUserNet PostToRetrievePswdVerify:taskObj.annexStr receiveData:&receiveData];
//        
//        taskObj.annexObj = receiveData;
//        taskObj.annexInteger = state;
//        
//        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
//        
//    }
//    else if ([taskObj.taskName isEqualToString:@"CheckVerify"])
//    {
//        NSData *receiveData = nil;
//        //NSSNETRltState state = [NSSUserNet PostToRetrievePswdCheckVerify:taskObj.annexStr code:[taskObj.annexArray objectAtIndexByNSS:0] sn:[taskObj.annexArray objectAtIndexByNSS:1] receiveData:&receiveData];
//        NSSNETRltState state = [NSSUserNet PostToRetrievePswdCheckVerify:taskObj.annexStr withCode:[taskObj.annexArray objectAtIndexByNSS:0] receiveData:&receiveData];
//        
//        taskObj.annexInteger = state;
//        taskObj.annexObj = receiveData;
//        
//        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
//    }
//}
//切换到主线程的任务
//- (void)runTaskOnMainThread:(NSSTaskObj *)taskObj
//{
//    if (taskObj.annexInteger != NSSNETRltState_SUCESS)
//    {
//        [NSSLoadingInterFace hideAllLoading];
//        return;
//    }
//    NSString *msg = nil;
//    
//    if ([taskObj.taskName isEqualToString:@"RetrievePasswordVerify"])
//    {
//        [NSSLoadingInterFace hideLoadingWithNameID:@"RetrievePasswordVerify"];
//        NSData *receiveData = taskObj.annexObj;
//        NSSNETRltState state = taskObj.annexInteger;
//        if (state == NSSNETRltState_SUCESS && receiveData)
//        {
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
//            //NSNumber *infocode = [infoDic objectForKeyByNSS:@"infocode"];
//            
//            //if ([infocode intValue] == 1)
//            NSNumber *infocode = [infoDic objectForKeyByNSS:@"code"];
//            
//            if ([infocode intValue] == 0)
//            {
//                NSDictionary *data = [infoDic objectForKeyByNSS:@"data"];
//                _snStr = [data objectForKeyByNSS:@"sn"];
//                _codeStr = [data objectForKeyByNSS:@"code"];
//                
//                NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateSecondLabel:) userInfo:nil repeats:YES];
//                
//                _seconds = 59;
//                
//                NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//                [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
//                [self.getCodeBtn setBackgroundImage:nil forState:UIControlStateNormal];
//                self.getCodeBtn.backgroundColor = [UIColor colorWithRed:150/255.0 green:157/255.0 blue:163/255.0 alpha:1];
//                self.getCodeBtn.titleLabel.text = @"60秒后重新发送";
//                [_getCodeBtn setTitle:@"60秒后重新发送" forState:UIControlStateNormal];
//            }
//            //else if([infocode intValue] == -1)
//            //{
//            //    msg = [infoDic objectForKeyByNSS:@"infomessage"];
//            //}
//            else
//            {
//                msg = [infoDic objectForKeyByNSS:@"message"];
//            }
//        }
//        else if(state == NSSNETRltState_NETERROR)
//        {
//            msg = @"请检查您的网络";
//        }
//    }
//    else if ([taskObj.taskName isEqualToString:@"CheckVerify"])
//    {
//        [NSSLoadingInterFace hideLoadingWithNameID:@"CheckVerify"];
//        NSData *receiveData = taskObj.annexObj;
//        NSSNETRltState state = taskObj.annexInteger;
//        if (state == NSSNETRltState_SUCESS && receiveData)
//        {
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
//            //NSNumber *infocode = [infoDic objectForKeyByNSS:@"infocode"];
//            //if ([infocode intValue] == 1)
//            NSNumber *infocode = [infoDic objectForKeyByNSS:@"code"];
//            if ([infocode intValue] == 0)
//            {
//                NSDictionary *data = [infoDic objectForKeyByNSS:@"data"];
//                _session = [data objectForKeyByNSS:@"session"];
//                [self retrievePasswordCommit];
//            }
//            //else if([infocode intValue] == -1)
//            //{
//            //    msg = [infoDic objectForKeyByNSS:@"infomessage"];
//            //}
//            else
//            {
//                msg = [infoDic objectForKeyByNSS:@"message"];
//            }
//        }
//        else if(state == NSSNETRltState_NETERROR)
//        {
//            msg = @"请检查您的网络";
//        }
//    }
//    if (msg)
//    {
//        UIAlertView*  alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//        [alert show];
//        msg = nil;
//    }
//}

#pragma mark loading框代理
//- (void)responseIndex:(NSInteger)index obj:(NSSLoadingBase *)view
//{
//    [NSSTaskPoolInterFace cancelTask:view.nameID];
//    [NSSLoadingInterFace hideLoadingWithNameID:view.nameID];
//}

@end
