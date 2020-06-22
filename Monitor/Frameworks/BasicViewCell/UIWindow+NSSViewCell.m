//
//  UIWindow+NSSViewCell.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "UIWindow+NSSViewCell.h"
#import "BasicWindowInterFace.h"

@implementation UIWindow (BasicViewCell)

- (BasicViewCellManger *)addViewCellToManger:(BasicViewCell *)ViewCell animated:(Class)BasicViewCellAdminClass
{
    BasicViewCellManger *cellManger = nil;
    
    if (ViewCell)
    {
        cellManger = [[BasicViewCellManger alloc] init];
        cellManger.window = self;
        cellManger.frame = self.bounds;
        [BasicWindowInterFace addViewToWindow:cellManger level:BasicWINDOWLEVEL_LEVEL2];
        [cellManger pushViewCell:ViewCell animated:BasicViewCellAdminClass];
    }
    
    return cellManger;
}



@end
