//
//  BasicToastView.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicToastDef.h"

@interface BasicToastView : UIView
{
@private
    NSString *_text;
    NSInteger _fontNum;
    BasicToastTime _showTime;
    BOOL _isFristShow;
    NSTimer *_timer;
}
@property (nonatomic, strong) IBOutlet UILabel *showLabel;

- (void)setText:(NSString *)setText;
- (void)setShowDuringTime:(BasicToastTime)time;
- (void)setTextFount:(NSInteger)fount;
- (void)show;

@end
