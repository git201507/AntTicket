//
//  BasicChangePasswordNewPwdView.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicChangePasswordNewPwdView.h"
//Replaced by import in NUViewControllerBase class
#import "BasicAccountInterFace.h"
#import "UIImage+EX.h"
#import "BasicViewCellAdmin.h"
#import "BasicToastInterFace.h"

@implementation BasicChangePasswordNewPwdView

- (void)dealloc
{
    
}

- (void)viewCellDidLoad
{
    [super viewCellDidLoad];
    UIImage *originalImage1 = [UIImage imageNamed:@"btn_line_bk"];
    UIImage *resizeImage1 = [UIImage resizableImageWithAll:originalImage1];
    [_commitBtn setBackgroundImage:resizeImage1 forState:UIControlStateNormal];
    _newpasswordTextField.returnKeyType = UIReturnKeyNext;
    _confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
    _newpasswordTextField.secureTextEntry = YES;
    _confirmPasswordTextField.secureTextEntry = YES;
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

- (IBAction)commit:(UIButton *)sender
{
    [self endEditing:NO];
    if (_newpasswordTextField.text.length == 0)
    {
        [BasicToastInterFace showToast:@"请填写密码!  "];
    }
    else if (_confirmPasswordTextField.text.length == 0)
    {
        [BasicToastInterFace showToast:@"请填写确认密码!  "];
    }
    else if (_newpasswordTextField.text.length < 6)
    {
        [BasicToastInterFace showToast:@"密码必须大于6位!  "];
    }
    else if (![_newpasswordTextField.text isEqualToString:_confirmPasswordTextField.text])
    {
        [BasicToastInterFace showToast:@"两次密码不一致!  "];
    }
    else
    {
        if (![self ValidateUserName:_newpasswordTextField.text])
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
        
        NSString *accountname = [BasicAccountInterFace getCurAccountName];
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:accountname, @"account", _newpasswordTextField.text, @"newpasswd", _session, @"session", nil];
        
        //        NSString *url = [NSSUserNet getChangePassWordCommitURL];
        NSString *url;
//        NSSUserNetHttpReq *task = [[NSSUserNetHttpReq alloc] init];
//        task.taskName = @"CommitNewPassword";
//        task.taskLevel = TaskLevel_Def;
//        task.netHttpStly = NSSNETSTLY_POST_JSON;
//        task.netTimeOut = NSSNETTimeOut_MaxLevel2;
//        task.taskDelegate = self;
//        task.netURL = url;
//        task.netBody = parameters;
//        
//        [NSSTaskPoolInterFace addTask:task];
    }
}


#pragma mark - 自己的方法
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
    if(self.newpasswordTextField.editing)
    {
        [self.confirmPasswordTextField becomeFirstResponder];
    }
    else if(self.confirmPasswordTextField.editing)
    {
        [self.confirmPasswordTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - 消息方法


#pragma mark - 代理方法
#pragma mark task代理
////切换到主线程的任务
//- (void)runTaskOnMainThread:(NSSTaskObj *)taskObj
//{
//    if (((NSSNetTaskObj *)taskObj).netState == NSSNETRltState_NETERROR)
//    {
//        [NSSLoadingInterFace hideAllLoading];
//        return;
//    }
//    if ([taskObj.taskName isEqualToString:@"CommitNewPassword"])
//    {
//        [NSSLoadingInterFace hideLoadingWithNameID:@"CommitNewPassword"];
//        
//        NSData *receiveData = ((NSSNetTaskObj *)taskObj).netReviceData;
//        NSSNETRltState state = ((NSSNetTaskObj *)taskObj).netState;
//        if (state == NSSNETRltState_SUCESS && receiveData)
//        {
//            NSDictionary *infoDic = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableLeaves error:nil];
//            NSNumber *infocode = [infoDic objectForKeyByNSS:@"infocode"];
//            if ([infocode intValue] == 1)
//            {
//                NSString *data = [infoDic objectForKeyByNSS:@"data"];
//                if ([data isEqualToString:@"OK"])
//                {
//                    NSSYESNoLoadingInfo *yesnoLoading = [[NSSYESNoLoadingInfo alloc] init];
//                    yesnoLoading.title = @"修改密码：";
//                    yesnoLoading.message = @"恭喜您修改密码成功！";
//                    NSArray *btnNameArray = [[NSArray alloc] initWithObjects:@"确定", nil];
//                    yesnoLoading.btnNameArray  = btnNameArray;
//                    NSSLoadingBase *loading = [NSSLoadingInterFace creatWithType:NSSLOADINGTYPE_YESNO delegate:self nameID:@"ChangePasswordSuccess" annexObj:yesnoLoading];
//                    [NSSLoadingInterFace showLoading:loading];
//                }
//            }
//            else
//            {
//                [NSSToastInterFace showToast:[infoDic objectForKeyByNSS:@"infomessage"]];
//            }
//        }
//    }
//}
//
//#pragma mark - loading框代理
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
