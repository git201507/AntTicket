//
//  HasCertificatedViewController.h
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HasCertificatedViewController : UIViewController<UITextFieldDelegate>
{
    
}
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *telLabel;
@property (nonatomic, weak) IBOutlet UILabel *cardNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *zhongjinNoLabel;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;

@end

