//
//  FinancialPlannerListViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/16.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinancialPlannerListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@end
