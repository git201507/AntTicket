//
//  BuyBidViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FinanceProductDetail;
@class FinanceProductEntity;
@interface BuyBidViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *draftId;

@property (nonatomic, weak) IBOutlet UILabel *bidNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *profitLabel;
@property (nonatomic, weak) IBOutlet UILabel *financeDayLabel;
@property (nonatomic, weak) IBOutlet UILabel *financeDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *availableAmountLabel;

@property (nonatomic, weak) IBOutlet UILabel *forValue;
@property (nonatomic, weak) IBOutlet UILabel *forOutValue;

@property (nonatomic, weak) IBOutlet UIView *targetView;
@property (nonatomic, strong) FinanceProductDetail *financeDetail;
@property (nonatomic, strong) FinanceProductEntity *financeProduct;


@property (nonatomic, strong) NSNumber *isNewsBid;

@end

