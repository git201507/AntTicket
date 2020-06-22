//
//  BasicRegisterCommitView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//
#import "BasicViewCell.h"

@interface BasicRegisterCommitView : BasicViewCell
{
    NSString *_cityName;
    NSString *_cityId;
    
    NSString *_refreshToken;
    NSString *_accessToken;
}
@property (strong, nonatomic) NSString *phoneStr;
@property (strong, nonatomic) NSString *sessionStr;

@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *qrpassword;
@property (weak, nonatomic) IBOutlet UIButton *finish;
@property (weak, nonatomic) IBOutlet UIView *commitview;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

- (IBAction)commit:(id)sender;
- (IBAction)back:(UIButton *)sender;


@end
