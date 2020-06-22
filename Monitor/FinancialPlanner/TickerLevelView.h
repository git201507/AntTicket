//
//  TickerLevelView.h
//  MedicareButler
//
//  Created by Wangxy on 16/3/8.
//  Copyright © 2016年 Neusoft. All rights reserved.
//

#import "BasicViewCell.h"

@interface TickerLevelView : BasicViewCell
{
    
}

@property (nonatomic, copy) NSString *levelStr;
@property (nonatomic, weak) IBOutlet UILabel *levelLabel;

@end
