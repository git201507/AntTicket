//
//  BasicChangePasswordNewPwdView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//
#import "BasicViewCell.h"

@interface BasicChangePasswordNewPwdView:BasicViewCell<UITextFieldDelegate>

@property (nonatomic, strong) NSString *session;
@property (nonatomic, strong) IBOutlet UITextField *newpasswordTextField;
@property (nonatomic, strong) IBOutlet UITextField *confirmPasswordTextField;
@property (nonatomic, strong) IBOutlet UIButton *commitBtn;

@end
