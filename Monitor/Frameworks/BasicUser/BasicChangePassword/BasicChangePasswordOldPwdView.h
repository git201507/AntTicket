//
//  BasicChangePasswordOldPwdView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//
#import "BasicViewCell.h"

@interface BasicChangePasswordOldPwdView : BasicViewCell <UITextFieldDelegate>
{
    
@private
    NSUInteger _seconds;
}


@property (nonatomic, strong) NSString *session;

@property (weak, nonatomic) IBOutlet UITextField *imagenum;
@property (weak, nonatomic) IBOutlet UITextField *securitynum;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *qrpassword;
@property (weak, nonatomic) IBOutlet UIButton *getnum;
@property (nonatomic, weak) IBOutlet UIButton *commitBtn;

@end
