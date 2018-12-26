//
//  ZZTMaterialTypeCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTMaterialTypeCell.h"

#import "ZZTKindModel.h"

@interface ZZTMaterialTypeCell ()

@property (nonatomic,strong) UILabel *cellLab;
@property (nonatomic,strong) UIView *whiteView;

@end

@implementation ZZTMaterialTypeCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //label
    UILabel *cellLab = [[UILabel alloc] init];
    _cellLab = cellLab;
    cellLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:cellLab];
    
    //line
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView = whiteView;
    [self addSubview:whiteView];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.cellLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.height.mas_equalTo(ZZTLayoutDistance(64));
    }];
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cellLab.mas_centerX);
        make.top.equalTo(self.cellLab.mas_bottom).offset(ZZTLayoutDistance(4));
        make.height.mas_equalTo(ZZTLayoutDistance(7));
        make.width.mas_equalTo(ZZTLayoutDistance(43));

    }];
    
}

-(void)setTitle:(NSString *)title{
    _title = title;
    _cellLab.text = title;
}

-(void)setModel:(ZZTKindModel *)model{
    _model = model;
    if([model.isSelect isEqualToString:@"1"]){
        _whiteView.backgroundColor = [UIColor whiteColor];
    }else{
        _whiteView.backgroundColor = [UIColor clearColor];
    }
    self.cellLab.text = model.kindTitle;
}
@end
