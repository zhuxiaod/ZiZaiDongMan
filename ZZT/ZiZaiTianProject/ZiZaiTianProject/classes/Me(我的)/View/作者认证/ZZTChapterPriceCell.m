//
//  ZZTChapterPriceCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTChapterPriceCell.h"
#import "ZZTChapterlistModel.h"

@interface ZZTChapterPriceCell()

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation ZZTChapterPriceCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //button
    UILabel *label = [[UILabel alloc] init];
    label.text = @"";
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.borderWidth = 1.0f;
    label.layer.cornerRadius = 8;
    _label = label;
    [self.contentView addSubview:label];

    //收费标志
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.clipsToBounds = YES;
    _imageView = imageView;
    _imageView.hidden = YES;
    imageView.image = [UIImage imageNamed:@"VIPChapterImage"];
    [self.contentView addSubview:imageView];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-4);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(0);
        make.top.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
}

-(void)setIsChangeStyle:(NSInteger)isChangeStyle{
    _isChangeStyle = isChangeStyle;
    if(isChangeStyle == 2){
        _label.layer.borderColor = ZZTSubColor.CGColor;
        _label.textColor = ZZTSubColor;
        //图片显示
        _imageView.hidden = NO;
    }else{
        _label.layer.borderColor = ZZTSubColor.CGColor;
        _label.textColor = ZZTSubColor;
        _imageView.hidden = YES;
    }
}

-(void)setModel:(ZZTChapterlistModel *)model{
    _model = model;
    _label.text = [NSString stringWithFormat:@"第%@",model.chapterName];
}
@end
