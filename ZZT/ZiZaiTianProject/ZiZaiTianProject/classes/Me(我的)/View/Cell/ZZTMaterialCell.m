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


-(void)awakeFromNib{
    
    [super awakeFromNib];
 
    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.imageView.clipsToBounds = YES;
    
    self.imageView.layer.cornerRadius = 10.0f;
    
    self.imageView.layer.masksToBounds = YES;
    
    self.imageView.userInteractionEnabled = YES;
}

-(void)setSelectImageView:(UIImageView *)selectImageView{
    _selectImageView = selectImageView;
    [self layoutIfNeeded];
    selectImageView.frame = CGRectMake(0, 0, self.width, self.height);
    [self.contentView addSubview:selectImageView];

}

-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    if (_arrayCount == 1) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageStr]] placeholderImage:[UIImage imageNamed:@"bannerPlaceV"] options:0];
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imageStr]] placeholderImage:[UIImage imageNamed:@"worldPlaceV"] options:0];

    }
}

-(void)setArrayCount:(NSInteger)arrayCount{
    _arrayCount = arrayCount;
}
@end
