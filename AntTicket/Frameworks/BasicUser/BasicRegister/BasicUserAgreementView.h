//
//  BasicUserAgreementView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicViewCell.h"

@interface BasicUserAgreementView : BasicViewCell
{
@private
    NSString *_protocalStr; // 协议内容
}
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


- (IBAction)back:(UIButton *)sender;

@end
