//
//  BasicRegisterView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//
#import "BasicViewCell.h"

@interface BasicRegisterView : BasicViewCell
{
@private
    NSUInteger _seconds;
}

//@property (weak, nonatomic) NSNumber *readFlag;    // 阅读用户协议标志
@property (weak, nonatomic) IBOutlet UITextField *imagenum;
@property (weak, nonatomic) IBOutlet UITextField *phonenum;
@property (weak, nonatomic) IBOutlet UITextField *securitynum;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *qrpassword;
@property (weak, nonatomic) IBOutlet UITextField *yqwords;
@property (weak, nonatomic) IBOutlet UIButton *getnum;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

- (IBAction)getnum:(UIButton *)sender;
- (IBAction)back:(UIButton *)sender;

@end
