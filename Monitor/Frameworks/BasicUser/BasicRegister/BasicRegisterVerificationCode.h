//
//  BasicRegisterVerificationCode.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicViewCell.h"

@interface BasicRegisterVerificationCode : BasicViewCell
{
@private
    NSUInteger _seconds;
    NSString *_session;
}

@property (strong, nonatomic) NSString *snStr;
@property (strong, nonatomic) NSString *codeStr;
@property (strong, nonatomic) NSString *phoneStr;
@property (weak, nonatomic) IBOutlet UITextField *securitynum;
@property (weak, nonatomic) IBOutlet UIView *commitview;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

- (IBAction)back:(UIButton *)sender;


@end
