//
//  ZZTEditorBottomView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorBottomView.h"
@interface ZZTEditorBottomView ()


@end

@implementation ZZTEditorBottomView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self addUI];
    }
    return self;
}

-(void)addUI{
    
    //底View
    UIView *bottomView = [[UIView alloc] init];
    _bottomView = bottomView;
    [self addSubview:bottomView];
    
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#1C1522" alpha:0.5];
    
    //素材库
    UIButton *materialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _materialBtn = materialBtn;
    [materialBtn setImage:[UIImage imageNamed:@"素材库"] forState:UIControlStateNormal];
    [materialBtn setTitle:@"素材库" forState:UIControlStateNormal];
    materialBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:materialBtn];
    
//    往下一层
    UIButton *nextBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"往下一层"] title:@"下置一层" titleColor:[UIColor whiteColor]];
    _nextBtn = nextBtn;
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:nextBtn];
    
//    往上一层
    UIButton *lastBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"往上一层"] title:@"上置一层" titleColor:[UIColor whiteColor]];
    _lastBtn = lastBtn;
    lastBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:lastBtn];

    
//    填色
    UIButton *colorBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"填色"] title:@"填色" titleColor:[UIColor whiteColor]];
    _colorBtn = colorBtn;
    colorBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:colorBtn];
    
    UIButton *paletteBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"调色"] title:@"调色" titleColor:[UIColor whiteColor]];
    _paletteBtn = paletteBtn;
    paletteBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [bottomView addSubview:paletteBtn];

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.right.left.equalTo(self);
        make.height.mas_equalTo(ZZTLayoutDistance(130));
    }];
    
    [self.materialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.height.mas_equalTo(ZZTLayoutDistance(200));
        make.width.mas_equalTo(ZZTLayoutDistance(200));
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.right.equalTo(self.materialBtn.mas_left).offset(ZZTLayoutDistance(-90));
        make.top.equalTo(self.bottomView.mas_top);
        make.width.mas_equalTo(ZZTLayoutDistance(130));
    }];
//    [self initButton:nextBtn];
    
    
    [self.lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.right.equalTo(self.nextBtn.mas_left).offset(ZZTLayoutDistance(-50));
        make.top.equalTo(self.bottomView.mas_top);
        make.width.mas_equalTo(ZZTLayoutDistance(130));
    }];
    
    [self.colorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.left.equalTo(self.materialBtn.mas_right).offset(ZZTLayoutDistance(90));
        make.top.equalTo(self.bottomView.mas_top);
        make.width.mas_equalTo(ZZTLayoutDistance(130));
    }];
    
    [self.paletteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.left.equalTo(self.colorBtn.mas_right).offset(ZZTLayoutDistance(50));
        make.top.equalTo(self.bottomView.mas_top);
        make.width.mas_equalTo(ZZTLayoutDistance(130));
    }];
    
     [self initButton:self.nextBtn];
     [self initButton:self.lastBtn];
     [self initButton:self.paletteBtn];
     [self initButton:self.colorBtn];
    
     [self.materialBtn setTitleEdgeInsets:
     UIEdgeInsetsMake(self.materialBtn.imageView.size.height + ZZTLayoutDistance(10),
                      (self.materialBtn.frame.size.width-self.materialBtn.titleLabel.intrinsicContentSize.width)/2-self.materialBtn.imageView.frame.size.width,
                      0,
                      (self.materialBtn.frame.size.width-self.materialBtn.titleLabel.intrinsicContentSize.width)/2)];
    
     [self.materialBtn setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (self.materialBtn.frame.size.width-self.materialBtn.imageView.frame.size.width)/2,
                      self.materialBtn.titleLabel.intrinsicContentSize.height + 2,
                      (self.materialBtn.frame.size.width-self.materialBtn.imageView.frame.size.width)/2)];
}

-(void)initButton:(UIButton*)but{
    NSLog(@"but.imageView.size.height:%f",but.imageView.size.height);
    [but setTitleEdgeInsets:
     UIEdgeInsetsMake(but.imageView.size.height + ZZTLayoutDistance(20),
                      (but.frame.size.width -but.titleLabel.intrinsicContentSize.width)/2 -but.imageView.frame.size.width,
                      0,
                      (but.frame.size.width -but.titleLabel.intrinsicContentSize.width)/2)];
    [but setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (but.frame.size.width-but.imageView.frame.size.width)/2,
                      but.titleLabel.intrinsicContentSize.height + 2,
                      (but.frame.size.width-but.imageView.frame.size.width)/2)];
}


@end
