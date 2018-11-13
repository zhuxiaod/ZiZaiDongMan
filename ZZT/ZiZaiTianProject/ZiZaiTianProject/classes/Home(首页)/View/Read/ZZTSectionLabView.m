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
    _sectionLab = sectionLab;
    //字体大一点
    _sectionLab.font = [UIFont systemFontOfSize:16];
    [self addSubview:sectionLab];
}

-(void)setSectionName:(NSString *)sectionName{
    _sectionName = sectionName;
    _sectionLab.text = sectionName;
    //字间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.sectionLab.text attributes:@{NSKernAttributeName : @(1.5f)}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.sectionLab.text.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(0, self.sectionLab.text.length)];
    [self.sectionLab setAttributedText:attributedString];
    _sectionLab.textAlignment = NSTextAlignmentCenter;
}

-(void)layoutSubviews{
    [_sectionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-8);
        make.right.left.equalTo(self).offset(0);
    }];
}

@end
