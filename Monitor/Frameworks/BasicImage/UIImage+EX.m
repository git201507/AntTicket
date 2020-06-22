//
//  UIImage+EX.m
//  AntTicket
//
//  Created by 王 夏阳 on 16/8/1.
//  Copyright © 2016年 王 夏阳. All rights reserved.
//

#import "UIImage+EX.h"

@implementation UIImage (EX)

+ (UIImage *)resizableImageWithAll:(UIImage *)originalImage
{
    UIEdgeInsets insets = UIEdgeInsetsMake((originalImage.size.width / 2) - 1, (originalImage.size.width / 2) - 1, (originalImage.size.width / 2) + 1, (originalImage.size.width / 2) + 1);
    UIImage *newImage = [originalImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    return newImage;
}

@end