//
//  BasicRetrieveCommitView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicViewCell.h"

@interface BasicRetrieveCommitView : BasicViewCell
{
    NSString *_refreshToken;
    NSString *_accessToken;
}
@property (strong, nonatomic) NSString *accountStr;
@property (strong, nonatomic) NSString *sessionStr;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *qrpassword;
@property (weak, nonatomic) IBOutlet UIButton *finish;


- (IBAction)commit:(id)sender;
- (IBAction)back:(UIButton *)sender;

@end
