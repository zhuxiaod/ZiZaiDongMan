//
//  ZZTFirstViewBtn.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/10.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTFirstViewBtn.h"
#import "ZXDCartoonFlexoBtn.h"
#import "ZZTHomeTableViewModel.h"
@interface ZZTFirstViewBtn()

@property (weak, nonatomic) IBOutlet UIImageView *ImgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation ZZTFirstViewBtn

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setBtnModel:(ZZTHomeTableViewModel *)btnModel{
    _btnModel = btnModel;
    
    _ImgView.image = [UIImage imageNamed:btnModel.btnImgUrl];
    
    _titleLab.text = btnModel.title;
    
}
@end
