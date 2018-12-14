//
//  ZZTLittleBoxView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/13.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTLittleBoxView.h"
@interface ZZTLittleBoxView ()
@property (nonatomic,strong) UIImageView *imageView;
@end
@implementation ZZTLittleBoxView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {

        //添加UI
        [self addUI];
        self.isSelect = NO;
        
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self addUI];
    }
    return self;
}

-(void)addUI{
    //图片
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    imageView.image = [UIImage imageNamed:@"Me_littlebox"];
    [self addSubview:imageView];
    //按钮
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(btnTarget) forControlEvents:UIControlEventTouchUpInside];
//    btn setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
    _button = btn;
    [self addSubview:btn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];

    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
}

-(void)btnTarget{
    _button.selected = !_button.selected;
    if(_button.selected){
        _imageView.image = [UIImage imageNamed:@"Me_littlebox_select"];
    }else{
        _imageView.image = [UIImage imageNamed:@"Me_littlebox"];
    }
    if(self.LittleBoxBlock){
        self.LittleBoxBlock(_button.selected);
    }
}
@end
