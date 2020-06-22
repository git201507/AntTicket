//
//  PlannerHomePageViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlannerHomePageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, strong) UIButton *customerBtn;
@property (nonatomic, strong) UIButton *vipSalaryBtn;
@property (nonatomic, strong) UIButton *rankBtn;

@property (nonatomic, strong) UILabel *hLineLabel1;
@property (nonatomic, strong) UILabel *hLineLabel2;
@property (nonatomic, strong) UILabel *hLineLabel3;

@property (nonatomic, weak) IBOutlet UIView *targetView;
@property (weak, nonatomic) IBOutlet UIImageView *adviserImg;
@property (weak, nonatomic) IBOutlet UILabel *adviserIntroductionLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;

@property (nonatomic, weak) IBOutlet UIView *tableHeaderView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *keyBoardTop;

@property (nonatomic, strong) UIActivityViewController *activityController;

@end

