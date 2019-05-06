//
//  ZZTCaiNiXiHuanView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCaiNiXiHuanView.h"
#import <SDWebImage/UIButton+WebCache.h>

@interface ZZTCaiNiXiHuanView ()
//头像View

 //猜你喜欢
@property (strong, nonatomic) UIImageView *topView;
//中间部位
@property (strong, nonatomic) UIView *midView;

@property (strong, nonatomic) UIView *btView;


@property (strong, nonatomic) UILabel *CNXHLab;

@end

@implementation ZZTCaiNiXiHuanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(106 * SCREEN_WIDTH / 360);
    }];
    
    CGFloat midViewH = (SCREEN_WIDTH - 20) / 5;
    
    [self.midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(0);
        make.right.left.equalTo(self.contentView);
        make.height.mas_equalTo(midViewH);
    }];
    
    CGFloat BtnW = self.contentView.height * 0.14;
    [self.updataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.midView.mas_bottom).offset(8);
        make.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(60);
    }];
}

-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self setupMainView];
}

-(void)setupMainView{
    CGFloat space = 5;
    CGFloat btnW = (SCREEN_WIDTH - space * 4) / 5;
    CGFloat btnH = btnW;
    
    NSInteger arrayCount = 0;
    if(self.dataArray.count <= 5){
        arrayCount = self.dataArray.count;
    }else{
        arrayCount = 5;
    }
    //获得数据 几个 6个
    for (int i = 0; i < arrayCount; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        if(_dataArray.count != 0){
            UserInfo *userInfo = self.dataArray[i];
            [btn sd_setImageWithURL:[NSURL URLWithString:userInfo.headimg] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"peien"] forState:UIControlStateNormal];
        }
        CGFloat x = (btnW + space) * i;
        btn.frame = CGRectMake(x, 2, btnW, btnH);
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.midView addSubview:btn];
    }
}

- (void)buttonClick:(UIButton *)button{
    if(self.dataArray.count > 0){
        UserInfo *userInfo = self.dataArray[button.tag];
        //跳转个人页
        ZZTMyZoneViewController *zoneView = [[ZZTMyZoneViewController alloc] init];
        zoneView.userId = [NSString stringWithFormat:@"%ld",userInfo.id];
        [[self myViewController].navigationController pushViewController:zoneView animated:NO];
        
        // 判断下这个block在控制其中有没有被实现
        if (self.buttonAction) {
            // 调用block传入参数
            self.buttonAction(button);
        }
    }else{
        [MBProgressHUD showMessage:@"服务器繁忙,请刷新数据。"];
    }
}

-(UIButton *)updataBtn{
    if(!_updataBtn){
        _updataBtn = [[UIButton alloc] init];
        [_updataBtn setImage:[UIImage imageNamed:@"刷新图标"] forState:UIControlStateNormal];
        [self.contentView addSubview:_updataBtn];
    }
    return _updataBtn;
}

-(UIView *)midView{
    if(!_midView){
        _midView = [[UIView alloc] init];
        _midView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_midView];
    }
    return _midView;
}

-(UIImageView *)topView{
    if(!_topView){
        _topView = [[UIImageView alloc] init];
        //设置图片
        [_topView setImage:[UIImage imageNamed:@"推荐-猜你喜欢"]];
        _topView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_topView];
        
    }
    return _topView;
}

@end
