//
//  ZZTEditorTopView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorTopView.h"

@interface ZZTEditorTopView ()



@end

@implementation ZZTEditorTopView


-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self addUI];
    }
    return self;
}

-(void)addUI{
    
    //返回
    UIButton *backBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"返回"] title:nil titleColor:nil];
    _backBtn = backBtn;
    [self addSubview:backBtn];
    
    UIButton *deletBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"清空"] title:nil titleColor:nil];
    _deletBtn = deletBtn;
    [self addSubview:deletBtn];
 
    
    UIButton *saveBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"保存"] title:nil titleColor:nil];
    _saveBtn = saveBtn;
    [self addSubview:saveBtn];
    
  
    
    UIButton *previewBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"预览"] title:nil titleColor:nil];
    _previewBtn = previewBtn;
    [self addSubview:previewBtn];
    
 
    
    UIButton *releaseBtn = [GlobalUI createButtonWithImg:nil title:@"发布" titleColor:[UIColor whiteColor]];
    releaseBtn.backgroundColor = ZZTSubColor;
    _releaseBtn = releaseBtn;
    releaseBtn.layer.cornerRadius = 10;
    [self addSubview:releaseBtn];
    
  
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(14);
        make.height.mas_equalTo(ZZTLayoutDistance(72));
        make.width.mas_equalTo(ZZTLayoutDistance(72));
    }];
    
    [self.deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(72 * AAdaptionWidth());
    }];
    [self.previewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.left.equalTo(self.deletBtn.mas_right).offset(ZZTLayoutDistance(60));
        make.width.height.mas_equalTo(ZZTLayoutDistance(72));
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.right.equalTo(self.deletBtn.mas_left).offset(ZZTLayoutDistance(-60));
        make.width.height.mas_equalTo(ZZTLayoutDistance(72));
    }];
    
    [self.releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(ZZTLayoutDistance(72));
        make.width.mas_equalTo(ZZTLayoutDistance(160));
    }];
    
}
@end
