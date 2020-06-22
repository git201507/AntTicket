//
//  BidDetailViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FinanceProductEntity;
@interface BidDetailViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    
}

@property (nonatomic, strong) UIButton *aNewFishBidBtn;
@property (nonatomic, strong) UIButton *optimalBidBtn;
@property (nonatomic, strong) UIButton *vipBidBtn;

@property (nonatomic, strong) UILabel *hLineLabel1;
@property (nonatomic, strong) UILabel *hLineLabel2;
@property (nonatomic, strong) UILabel *hLineLabel3;


@property (nonatomic, weak) IBOutlet UIView *targetView;
@property (nonatomic, weak) IBOutlet UIView *tableHeaderView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UILabel *bidNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *profitLabel;
@property (nonatomic, weak) IBOutlet UILabel *financeDayLabel;
@property (nonatomic, weak) IBOutlet UILabel *financeDescriptionLabel;

@property (nonatomic, strong) FinanceProductEntity *financeProduct;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *keyBoardTop;
@property (nonatomic, strong) NSNumber *isNewsBid;

@end

