//
//  ZZTZBView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTZBView.h"
#import "ZZTFreeBiModel.h"

@interface ZZTZBView ()

@property (nonatomic,strong) UILabel *ZBLab;

@property (nonatomic,strong) UILabel *ZBDetailLab;

@property (nonatomic,strong) UILabel *moneyLab;

@property (nonatomic,strong) UIImageView *btnImageView;

@end

@implementation ZZTZBView


-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setupUI];

    }
    return self;
}

-(void)setupUI{
    //空白 0.1864
    //多少ZB
    UILabel *ZBLab = [[UILabel alloc] init];
    ZBLab.textAlignment = NSTextAlignmentCenter;
    _ZBLab = ZBLab;
    ZBLab.font = [UIFont systemFontOfSize:18];
//    ZBLab.text = @"1000ZB";
    [self addSubview:ZBLab];
    
    //ZB 详情
    UILabel *ZBDetailLab = [[UILabel alloc] init];
    _ZBDetailLab = ZBDetailLab;
    ZBDetailLab.textColor = [UIColor colorWithRGB:@"253,169,122"];
    ZBDetailLab.textAlignment = NSTextAlignmentCenter;
    ZBDetailLab.font = [UIFont systemFontOfSize:16];
//    ZBDetailLab.text = @"首冲";
    [self addSubview:ZBDetailLab];
    
    //按钮
    UIImageView *btnImageView = [[UIImageView alloc] init];
    _btnImageView = btnImageView;
    btnImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:btnImageView];
    
    //显示价格
    UILabel *moneyLab = [[UILabel alloc] init];
    moneyLab.text = @"100";
    moneyLab.font = [UIFont systemFontOfSize:22];
    _moneyLab = moneyLab;
    moneyLab.textColor = [UIColor whiteColor];
    moneyLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:moneyLab];
    
    //点击事件
    UIButton *btn = [[UIButton alloc] init];
    _viewBtn = btn;
    [self addSubview:btn];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_ZBDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(self.mas_width);
    }];
    
    [_ZBLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.ZBDetailLab.mas_top).offset(-6);
        make.centerX.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.18);
        make.width.equalTo(self.mas_width);
    }];
    
    [_btnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ZBDetailLab.mas_bottom).offset(12);
        make.centerX.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.25);
        make.width.equalTo(self.mas_width);
    }];
    
    [_moneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.btnImageView);
        make.centerX.equalTo(self.btnImageView);
        make.height.equalTo(self.btnImageView.mas_height).multipliedBy(0.5);
        make.width.equalTo(self.btnImageView.mas_width);
    }];
    
    [_viewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.centerX.equalTo(self);
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
    }];
}

-(void)setVIPModel:(ZZTFreeBiModel *)VIPModel{
    _VIPModel = VIPModel;
    
    NSLog(@"viptag:%ld",self.tag);
    
    //自动续费的view
    if(self.tag == 0){
        
        NSMutableAttributedString *attriStr1 = [[NSMutableAttributedString alloc] initWithString:VIPModel.goodsName];
        [attriStr1 addAttribute:NSForegroundColorAttributeName value:ZZTSubColor range:NSMakeRange(0, 3)];
        [attriStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, 3)];
        [_ZBLab setAttributedText:attriStr1];
        
    }else{
        
        NSMutableAttributedString *attriStr1 = [[NSMutableAttributedString alloc] initWithString:VIPModel.goodsName];
        [attriStr1 addAttribute:NSForegroundColorAttributeName value:ZZTSubColor range:NSMakeRange(0, VIPModel.goodsName.length)];
        [attriStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, VIPModel.goodsName.length)];
        [_ZBLab setAttributedText:attriStr1];
        
    }
    
    [_ZBDetailLab setText:VIPModel.goodsDetaill];
    
    [_ZBDetailLab setTextColor:[UIColor colorWithRGB:@"205,99,207"]];
    
    [_btnImageView setImage:[UIImage imageNamed:@"ME_wallet_purpleBox"]];

    [_moneyLab setText:[NSString stringWithFormat:@"¥%ld",(long)VIPModel.goodsMoney]];

}


-(void)setWalletModel:(ZZTFreeBiModel *)walletModel{
    _walletModel = walletModel;
    //数字紫色  zb 黑色 大小不同
    NSMutableAttributedString *attriStr1 = [[NSMutableAttributedString alloc] initWithString:walletModel.goodsName];
    [attriStr1 addAttribute:NSForegroundColorAttributeName value:ZZTSubColor range:NSMakeRange(0, walletModel.goodsName.length - 2)];
    [attriStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24] range:NSMakeRange(0, walletModel.goodsName.length - 2)];
    
    [_ZBLab setAttributedText:attriStr1];
    
    [_ZBDetailLab setText:walletModel.goodsDetaill];
    
    [_btnImageView setImage:[UIImage imageNamed:@"ME_wallet_orangeBox"]];
    
    [_moneyLab setText:[NSString stringWithFormat:@"¥%ld",(long)walletModel.goodsMoney]];
}


@end
