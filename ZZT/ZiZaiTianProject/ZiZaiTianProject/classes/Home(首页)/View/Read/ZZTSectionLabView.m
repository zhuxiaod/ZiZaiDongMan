//
//  ZZTSectionLabView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTSectionLabView.h"
@interface ZZTSectionLabView ()

@property (nonatomic,strong) UILabel *sectionLab;

@end

@implementation ZZTSectionLabView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self setupUI];
        
    } return self;
    
}

-(void)setupUI{
    UILabel *sectionLab = [[UILabel alloc] init];
    sectionLab.text = @"为您推荐";
    sectionLab.textAlignment = NSTextAlignmentCenter;
    _sectionLab = sectionLab;
    [self addSubview:sectionLab];
}

-(void)layoutSubviews{
    [_sectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.right.left.equalTo(self).offset(0);
    }];
}

@end
