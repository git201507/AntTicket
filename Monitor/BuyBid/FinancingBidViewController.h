//
//  FinancingBidViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyAccountDetail;
@interface FinancingBidViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic, strong) UIButton *aNewFishBidBtn;
@property (nonatomic, strong) UIButton *optimalBidBtn;
@property (nonatomic, strong) UIButton *vipBidBtn;

@property (nonatomic, strong) UILabel *hLineLabel1;
@property (nonatomic, strong) UILabel *hLineLabel2;
@property (nonatomic, strong) UILabel *hLineLabel3;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

