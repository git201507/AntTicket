//
//  BasicLogInView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "BasicViewCell.h"

@interface BasicLogInView : BasicViewCell
{
    BOOL _isAllocedLogView;
    
@private
    //    BOOL _isSavePassWord;
    NSString *_cityName;
    NSString *_cityId;
}
@property BOOL isAllocedLogView;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (nonatomic) NSDictionary *data;
@property (nonatomic) NSArray *list;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewBottomLayout;

- (IBAction) login:(UIButton *)sender;
- (IBAction) back:(UIButton *)sender;
- (IBAction) registerNewUser:(id)sender;
- (IBAction) retrievePassword:(id)sender;

@end