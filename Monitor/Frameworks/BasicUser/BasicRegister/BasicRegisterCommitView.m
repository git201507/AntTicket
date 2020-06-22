//
//  BasicRegisterCommitView.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicRegisterCommitView.h"
#import "BasicToastInterFace.h"
#import "UIImage+EX.h"
#import "BasicViewCellAdmin.h"
#import "BasicAccountInterFace.h"

#define ACCOUNTSETTING_SELECTEDAREA_DIC              (@"ACCOUNTSETTING_SELECTEDAREA_KEY")//选中地区,key为areaName和areaId

@implementation BasicRegisterCommitView

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
    
    if (_password.text.length == 0)
    {
        msg = @"请输入密码！";
    }
    else if (_password.text.length < 6)
    {
        msg = @"密码必须大于6位！";
    }
    else if ([_qrpassword.text length] == 0)
    {
        msg = @"请再次输入密码！";
    }
    else if (![_password.text isEqualToString:_qrpassword.text])
    {
        msg = @"两次密码不同";
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
        
//        NSSTaskObj *task = [[NSSTaskObj alloc] init];
//        task.taskName = @"RegisterCommit";
//        task.taskLevel = TaskLevel_Def;
//        task.taskDelegate = self;
//        task.annexStr = _phoneStr;
//        task.annexObj = _sessionStr;
//        task.annexArray = [NSArray arrayWithObjects:_password.text, nil];
//        
//        [NSSTaskPoolInterFace addTask:task];
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

-(void)login
{
    // 获取本地所选城市
    NSString *accountName = [BasicAccountInterFace getCurAccountName];
    NSDictionary *areaInfoDic = (NSDictionary *)[BasicAccountInterFace getAccountSettingInfo:accountName key:ACCOUNTSETTING_SELECTEDAREA_DIC];
    if (areaInfoDic)
    {
        _cityId = (NSString *)[areaInfoDic objectForKey:@"areaId"];
        _cityName = [areaInfoDic objectForKey:@"areaName"];
    }
//    NSSLoadingBase *loading = [NSSLoadingInterFace creatWithType:NSSLOADINGTYPE_CANCEL delegate:self nameID:@"LogIn" annexObj:nil];
//    [NSSLoadingInterFace showLoading:loading];
//    NSSTaskObj *task = [[NSSTaskObj alloc] init];
//    task.taskName = @"LogIn";
//    task.taskLevel = TaskLevel_Def;
//    task.taskDelegate = self;
//    task.annexStr = _phoneStr;
//    task.annexObj = _password.text;
//    
//    [NSSTaskPoolInterFace addTask:task];
}
#pragma mark - 消息方法


#pragma mark - 代理方法
#pragma mark task代理
//线程池中的任务
//- (void)runTask:(NSSTaskObj *)taskObj
//{
//    if ([taskObj.taskName isEqualToString:@"RegisterCommit"])
//    {
//        NSData *receiveData = nil;
//        //        NSSNETRltState state = [NSSUserNet PostToRegisterCommit:taskObj.annexStr withSession:taskObj.annexObj withPassword:[taskObj.annexArray objectAtIndexByNSS:0] receiveData:&receiveData];
//        NSSNETRltState state = [NSSUserNet PostToRegisterCommit:taskObj.annexStr withPassword:[taskObj.annexArray objectAtIndexByNSS:0] receiveData:&receiveData];
//        
//        taskObj.annexInteger = state;
//        taskObj.annexObj = receiveData;
//        
//        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
//    }
//    else if ([taskObj.taskName isEqualToString:@"LogIn"])
//    {
//        NSData *receiveData = nil;
//        NSSNETRltState state = [NSSUserNet PostToLogIn:taskObj.annexStr password:taskObj.annexObj receiveData:&receiveData];
//        
//        taskObj.annexObj = receiveData;
//        taskObj.annexInteger = state;
//        
//        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
//        
//    }
//    else if ([taskObj.taskName isEqualToString:@"FetchUerLoginInfo"])
//    {
//        NSData *receiveData = nil;
//        NSSNETRltState state = [NSSUserNet PostToFetchUserDetailWithAccessToken:taskObj.annexObj receiveData:&receiveData];
//        
//        taskObj.annexObj = receiveData;
//        taskObj.annexInteger = state;
//        
//        [NSSTaskPoolInterFace taskToMainThread:taskObj isNeedWait:NO];
//    }
//}
////切换到主线程的任务
//- (void)runTaskOnMainThread:(NSSTaskObj *)taskObj
//{
//    if (taskObj.annexInteger != NSSNETRltState_SUCESS && taskObj.annexInteger != 400)
//    {
//        [NSSLoadingInterFace hideAllLoading];
//        return;
//    }
//    NSString *msg = nil;
//    if ([taskObj.taskName isEqualToString:@"RegisterCommit"])
//    {
//        [NSSLoadingInterFace hideLoadingWithNameID:@"RegisterCommit"];
//        NSData *receiveData = taskObj.annexObj;
//        NSSNETRltState state = taskObj.annexInteger;
//        if (state == NSSNETRltState_SUCESS)
//        {
//            NSSYESNoLoadingInfo *yesnoLoading = [[NSSYESNoLoadingInfo alloc] init];
//            yesnoLoading.title = @"注册信息：";
//            yesnoLoading.message = @"恭喜您注册成功！";
//            NSArray *btnNameArray = [[NSArray alloc] initWithObjects:@"确定", nil];
//            yesnoLoading.btnNameArray  = btnNameArray;
//            NSSLoadingBase *loading = [NSSLoadingInterFace creatWithType:NSSLOADINGTYPE_YESNO delegate:self nameID:@"RegisterSuccess" annexObj:yesnoLoading];
//            [NSSLoadingInterFace showLoading:loading];
//            [_imageView3 setImage:[UIImage imageNamed:@"login_3_n"]];
//            [_imageView4 setImage:[UIImage imageNamed:@"login_4_h"]];
//            return;
//        }
//        if (state == 400 && receiveData)
//        {
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
//            msg = [infoDic objectForKeyByNSS:@"msg"];
//        }
//    }
//    else if ([taskObj.taskName isEqualToString:@"LogIn"])
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
//                NSString *accountName = receiveInfo.user.uid;
//                [NSSAccountInterFace savePassWordInfo:accountName passWord:_password.text];
//                [NSSAccountInterFace saveUserName:accountName userName:_phoneStr];
//                [NSSAccountInterFace saveToken:accountName token:_accessToken];
//                [NSSAccountInterFace saveRefreshToken:accountName token:_refreshToken];
//                
//                [NSSAccountInterFace chooseAccount:accountName];
//                [NSSUserInterFace setLogInState:NSSUSERLONGSTATE_LONGIN_MANUAL];
//                [NSSMessageInterFace fireMessageOnMainThread:NSSUSERACCOUNTCHANGEDMESSAGE_MainThread anexObj:nil];
//                // 所选城市存入本地
//                NSDictionary *areaDic = [[NSDictionary alloc] initWithObjectsAndKeys:_cityName, @"areaName", _cityId, @"areaId", nil];
//                [NSSAccountInterFace setAccountSettingInfo:accountName key:ACCOUNTSETTING_SELECTEDAREA_DIC val:areaDic];
//                [self.viewCellManger popToOriginal:[NSSViewCellUPDownAdmin class]];
//            }
//        }
//    }
//    
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
//    if ([view.nameID isEqualToString:@"RegisterSuccess"])
//    {
//        if (index == 0)
//        {
//            [self login];
//        }
//    }
//    [NSSTaskPoolInterFace cancelTask:view.nameID];
//    [NSSLoadingInterFace hideLoadingWithNameID:view.nameID];
//}

@end
