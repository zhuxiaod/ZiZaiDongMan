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
    
    self.imageView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage)];
//    [self.imageView addGestureRecognizer:tap];
}

-(void)tapImage{
//    if(self.buttonAction){
//        self.buttonAction(self.imageView);
//    }
}

-(void)setSelectImageView:(UIImageView *)selectImageView{
    _selectImageView = selectImageView;
//    self.imageView = selectImageView;
    [self layoutIfNeeded];
    selectImageView.frame = CGRectMake(0, 0, self.width, self.height);
    [self.contentView addSubview:selectImageView];
//    [selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.right.left.bottom.equalTo(self.contentView);
//    }];
}

-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.cdn.zztian.cn/%@",imageStr]] placeholderImage:[UIImage createImageWithColor:[UIColor whiteColor]] options:0];
    NSLog(@"imageBB%@",[NSString stringWithFormat:@"http://img.cdn.zztian.cn/%@",imageStr]);

}

@end
