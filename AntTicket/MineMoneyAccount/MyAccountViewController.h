//
//  MyAccountViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAccountDetail;
@interface MyAccountViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *incomeLabel;
@property (nonatomic, weak) IBOutlet UILabel *assetLabel;
@property (nonatomic, weak) IBOutlet UILabel *collectLabel;
@property (nonatomic, weak) IBOutlet UILabel *financingLabel;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;

@property (nonatomic, weak) IBOutlet UIButton *fillInBtn;
@property (nonatomic, weak) IBOutlet UIButton *fetchCashBtn;

@property (nonatomic, weak) IBOutlet UIButton *vipBtn;
@property (nonatomic, weak) IBOutlet UIButton *levelBtn;
@property (nonatomic, weak) IBOutlet UIButton *lcsBtn;
@property (nonatomic, weak) IBOutlet UIButton *telBtn;
@property (nonatomic, weak) IBOutlet UIButton *settingBtn;
@property (nonatomic, weak) IBOutlet UIButton *msgBtn;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, strong) MyAccountDetail *accountDetail;
@property (nonatomic, strong) UIActivityViewController *activityController;

@end

