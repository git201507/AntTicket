//
//  BasicRetrieveVerificationCodeView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicViewCell.h"

@interface BasicRetrieveVerificationCodeView : BasicViewCell
{
@private
    NSUInteger _seconds;
    NSString *_session;
}

@property (strong, nonatomic) NSString *snStr;
@property (strong, nonatomic) NSString *codeStr;
@property (strong, nonatomic) NSString *accountStr;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIButton *verifyCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *getCodeLabel;

- (IBAction)back:(UIButton *)sender;

@end
