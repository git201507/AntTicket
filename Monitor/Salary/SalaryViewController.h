//
//  SalaryViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalaryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UILabel *couponLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
@property (nonatomic, weak) IBOutlet UILabel *cashLabel;
@property (nonatomic, weak) IBOutlet UILabel *balanceLabel;

@property (nonatomic, weak) IBOutlet UIButton *cashBtn;
@property (nonatomic, weak) IBOutlet UIButton *fetchCouponBtn;

@property (nonatomic, weak) IBOutlet UIButton *mysalaryListBtn;
@property (nonatomic, weak) IBOutlet UIButton *withdrawListBtn;
@property (nonatomic, weak) IBOutlet UIButton *couponUseRecordBtn;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

