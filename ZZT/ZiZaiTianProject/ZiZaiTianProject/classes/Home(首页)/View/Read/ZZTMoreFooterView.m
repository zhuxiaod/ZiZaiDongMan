//
//  ZZTMoreFooterView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/13.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMoreFooterView.h"
@interface ZZTMoreFooterView ()

@property (nonatomic,strong) UIButton *moreBtn;

@property (nonatomic,strong) UIButton *updateBtn;

@end

@implementation ZZTMoreFooterView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self setupUI];
        
    } return self;
    
}

-(void)setupUI{
    //更多
    UIButton *moreBtn = [[UIButton alloc] init];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    moreBtn.backgroundColor = [UIColor colorWithRGB:@"242,242,242"];
    moreBtn.titleLabel.textColor = [UIColor grayColor];
    [moreBtn addTarget:self action:@selector(moreTarget) forControlEvents:UIControlEventTouchUpInside];
    moreBtn.layer.cornerRadius = 8.0f;
    _moreBtn = moreBtn;
    [self addSubview:moreBtn];
    
    //换一批
    UIButton *updateBtn = [[UIButton alloc] init];
    [updateBtn setTitle:@"换一批" forState:UIControlStateNormal];
    updateBtn.backgroundColor = [UIColor colorWithRGB:@"242,242,242"];
    [updateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _updateBtn = updateBtn;
    [updateBtn addTarget:self action:@selector(updateTarget) forControlEvents:UIControlEventTouchUpInside];
    updateBtn.layer.cornerRadius = 8.0f;
    [self addSubview:updateBtn];
}

-(void)moreTarget{
    if(self.moreBtnClick){
        self.moreBtnClick();
    }
}

-(void)updateTarget{
    if(self.updateBtnClick){
        self.updateBtnClick();
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat BtnW = (SCREEN_WIDTH - 20) / 2;
    
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.left.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-2);
        make.width.mas_equalTo(BtnW);
    }];
    
    [_updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-8);
        make.bottom.equalTo(self).offset(-2);
        make.width.mas_equalTo(BtnW);
    }];
}
@end
