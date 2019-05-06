//
//  ZZTXuHuaCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTXuHuaCell.h"
#import "ZZTChapterlistModel.h"

@interface ZZTXuHuaCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation ZZTXuHuaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ZZTChapterlistModel *)model{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    
    _nameLab.text = [NSString stringWithFormat:@"%ld",model.praiseNum];
}
@end
