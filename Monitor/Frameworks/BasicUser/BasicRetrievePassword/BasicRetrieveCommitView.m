//
//  BasicRetrieveCommitView.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicRetrieveCommitView.h"
#import "BasicUserDef.h"
#import "UIImage+EX.h"
#import "BasicViewCellAdmin.h"

@implementation BasicRetrieveCommitView

- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    self.password.keyboardType = UIKeyboardTypeASCIICapable;
    self.qrpassword.keyboardType = UIKeyboardTypeASCIICapable;
    
    [self.password setValue:[UIColor colorWithRed:237/255.0 green:249/255.0 blue:251/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.password setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [self.qrpassword setValue:[UIColor colorWithRed:237/255.0 green:249/255.0 blue:251/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [self.qrpassword setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];
    [_qrpassword setSecureTextEntry:YES];
    [_password setSecureTextEntry:YES];
    UIImage *originalImage1 = [UIImage imageNamed:@"btn_line_bk"];
    UIImage *resizeImage1 = [UIImage resizableImageWithAll:originalImage1];
    [self.finish setBackgroundImage:resizeImage1 forState:UIControlStateNormal];
    
    self.password.returnKeyType = UIReturnKeyNext;
    self.qrpassword.returnKeyType = UIReturnKeyDone;
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

- (IBAction)commit:(id)sender
{
    [self endEditing:NO];
    NSString *msg = nil;
    
    if (_password.text.length < 6)
    {
        msg = @"密码必须大于6位";
    }
    else if (![_password.text isEqualToString:_qrpassword.text])
    {
        msg = @"两次密码不一致";
    }
    else
    {
        if (![self ValidateUserName:_password.text])
        {
            NSString *msg = @"密码填写不符合规则，请重新填写密码！";
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            [alert show];
            msg = nil;
            return;
        }
        
        UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 40, self.bounds.size.height / 2 - 40, 80, 80)];
        [self addSubview:loading];
        [loading startAnimating];
        /*
        NSSTaskObj *task = [[NSSTaskObj alloc] init];
        task.taskName = @"RetrieveCommit";
        task.taskLevel = TaskLevel_Def;
        task.taskDelegate = self;
        //task.annexStr = _accountStr;
        //task.annexObj = _sessionStr;
        //task.annexArray = [NSArray arrayWithObjects:_password.text, nil];
        task.annexStr = @"null";
        task.annexObj = _password.text;
        
        [NSSTaskPoolInterFace addTask:task];*/
    }
    if (msg)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
        msg = nil;
    }
}

#pragma mark - 自己的方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield
{
    if(self.password.editing)
    {
        [self.qrpassword becomeFirstResponder];
    }
    else if(self.qrpassword.editing)
    {
        [self.qrpassword resignFirstResponder];
    }
    return YES;
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

//-(void)login
//{
//    NSSLoadingBase *loading = [NSSLoadingInterFace creatWithType:NSSLOADINGTYPE_CANCEL delegate:self nameID:@"LogIn" annexObj:nil];
//    [NSSLoadingInterFace showLoading:loading];
//    NSSTaskObj *task = [[NSSTaskObj alloc] init];
//    task.taskName = @"LogIn";
//    task.taskLevel = TaskLevel_Def;
//    task.taskDelegate = self;
//    task.annexStr = _accountStr;
//    task.annexObj = _sessionStr;
//    task.annexArray = [[NSArray alloc] initWithObjects:_password.text, nil];
//    
//    [NSSTaskPoolInterFace addTask:task];
//}
#pragma mark - 消息方法


#pragma mark - 代理方法
#pragma mark task代理
//线程池中的任务
/*
- (void)runTask:(NSSTaskObj *)taskObj
{
    if ([taskObj.taskName isEqualToString:@"RetrieveCommit"])
    {
        NSData *receiveData = nil;
        NSSNETRltState state = [NSSUserNet PostToChangePswdCommit:taskObj.annexStr password:taskObj.annexObj accountName:_accountStr receiveData:&receiveData];
        
        taskObj.annexObj = receiveData;
        taskObj.annexInteger = state;
        
        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
    }
    else if ([taskObj.taskName isEqualToString:@"LogIn"])
    {
        NSData *receiveData = nil;
        NSSNETRltState state = [NSSUserNet PostToLogIn:taskObj.annexStr password:taskObj.annexObj receiveData:&receiveData];
        
        taskObj.annexObj = receiveData;
        taskObj.annexInteger = state;
        
        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
    }
    else if ([taskObj.taskName isEqualToString:@"FetchUerLoginInfo"])
    {
        NSData *receiveData = nil;
        NSSNETRltState state = [NSSUserNet PostToFetchUserDetailWithAccessToken:taskObj.annexObj receiveData:&receiveData];
        
        taskObj.annexObj = receiveData;
        taskObj.annexInteger = state;
        
        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
    }
}
//切换到主线程的任务

- (void)runTaskOnMainThread:(NSSTaskObj *)taskObj
{
    if (taskObj.annexInteger != NSSNETRltState_SUCESS && taskObj.annexInteger != 400)
    {
        [NSSLoadingInterFace hideAllLoading];
        return;
    }
    if ([taskObj.taskName isEqualToString:@"RetrieveCommit"])
    {
        [NSSLoadingInterFace hideLoadingWithNameID:@"RetrieveCommit"];
        NSData *receiveData = taskObj.annexObj;
        NSSNETRltState state = taskObj.annexInteger;
        if (state == NSSNETRltState_SUCESS)
        {
            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
            NSString *infoCode = [infoDic objectForKeyByNSS:@"code"];
            
            if (![infoCode isEqualToString:@"success"])
            {
                [NSSToastInterFace showToast:[infoDic objectForKeyByNSS:@"msg"]];
                return;
            }
            
            NSSYESNoLoadingInfo *yesnoLoading = [[NSSYESNoLoadingInfo alloc] init];
            yesnoLoading.title = @"找回密码";
            yesnoLoading.message = @"恭喜您找回密码成功！";
            NSArray *btnNameArray = [[NSArray alloc] initWithObjects:@"确定", nil];
            yesnoLoading.btnNameArray  = btnNameArray;
            NSSLoadingBase *loading = [NSSLoadingInterFace creatWithType:NSSLOADINGTYPE_YESNO delegate:self nameID:@"RetrievePasswordSuccess" annexObj:yesnoLoading];
            [NSSLoadingInterFace showLoading:loading];
            return;
        }
    }
}

#pragma mark loading框代理
- (void)responseIndex:(NSInteger)index obj:(NSSLoadingBase *)view
{
    if ([view.nameID isEqualToString:@"RetrievePasswordSuccess"])
    {
        if (index == 0)
        {
            [self.viewCellManger popToRootViewCell:[NSSViewCellAdmin class]];
        }
    }
    [NSSTaskPoolInterFace cancelTask:view.nameID];
    [NSSLoadingInterFace hideLoadingWithNameID:view.nameID];
}*/

@end
