//
//  PlannerEditViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlannerEditViewController:UIViewController<UITextViewDelegate>
{
    
}

@property (nonatomic, copy) NSString *contextStr;
@property (nonatomic, weak) IBOutlet UITextView *contextTextView;

@end

