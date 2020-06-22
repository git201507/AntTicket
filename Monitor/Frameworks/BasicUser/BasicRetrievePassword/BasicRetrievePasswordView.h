//
//  BasicRetrievePasswordView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//
#import "BasicViewCell.h"

@interface BasicRetrievePasswordView : BasicViewCell
{
@private
    NSString *_sn;
    NSString *_code;
    NSUInteger _seconds;
}

@property (weak, nonatomic) IBOutlet UITextField *imagenum;
@property (weak, nonatomic) IBOutlet UITextField *phonenum;
@property (weak, nonatomic) IBOutlet UITextField *securitynum;
@property (weak, nonatomic) IBOutlet UIButton *getnum;

- (IBAction)back:(id)sender;
- (IBAction)getnum:(UIButton *)sender;

- (void)textFieldDidBeginEditing:(UITextField *)textField;

@end
