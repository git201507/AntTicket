//
//  BasicViewCell.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobleURL.h"

@protocol BasicViewCellTimingProtocol <NSObject>
@optional
- (void)timingViewCellDidLoad:(UIView *)view;
- (void)timingViewCellWillAppear:(UIView *)view;
- (void)timingViewCellDidAppear:(UIView *)view;
- (void)timingViewCellWillDisappear:(UIView *)view;
- (void)timingViewCellDidDisappear:(UIView *)view;

@end


@class BasicViewCellManger;
@interface BasicViewCell : UIControl
{
@private
    __weak BasicViewCellManger *_viewCellManger;
    BOOL _isFristAdd;
    NSMutableArray *_registArray;
}

@property (nonatomic, weak) BasicViewCellManger *viewCellManger;

- (void)viewCellDidLoad;
- (void)viewCellWillAppear;

- (void)viewCellDidAppear;

- (void)viewCellWillDisappear;
- (void)viewCellDidDisappear;

//注册viewCell生命时机代理,主线程调用
+ (void)registViewCellTiming:(id <BasicViewCellTimingProtocol>)delegate;
+ (void)logoutViewCellTiming:(id <BasicViewCellTimingProtocol>)delegate;

@end
