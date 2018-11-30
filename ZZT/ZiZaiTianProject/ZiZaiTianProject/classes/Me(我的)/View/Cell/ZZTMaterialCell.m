//
//  ZZTMaterialCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMaterialCell.h"
@interface ZZTMaterialCell ()


@end

@implementation ZZTMaterialCell

-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage createImageWithColor:[UIColor whiteColor]] options:0];
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.imageView.clipsToBounds = YES;
}

@end
