//
//  ZZTChapterChooseCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/30.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTChapterChooseCell.h"
#import "ZZTChapterChooseModel.h"

@interface ZZTChapterChooseCell ()

@property (nonatomic,strong) UILabel *label;

@end

@implementation ZZTChapterChooseCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame])
    {
        //添加自己需要个子视图控件
      [self setUpAllChildView];
    
    } return self;
    
}

-(void)setUpAllChildView{
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
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView).offset(0);
    }];
}

-(void)setModel:(ZZTChapterChooseModel *)model{
    _model = model;
    _label.text = [NSString stringWithFormat:@"%@-%@话",model.benginPage,model.endPage];
}

-(void)setStr:(NSString *)str{
    _str = str;
    _label.text = str;

}

-(void)setIsChangeStyle:(NSNumber *)isChangeStyle{
    _isChangeStyle = isChangeStyle;
    if([isChangeStyle isEqualToNumber:@1]){
        _label.layer.borderColor = ZZTSubColor.CGColor;
        _label.textColor = ZZTSubColor;
    }else{
        _label.layer.borderColor = [UIColor grayColor].CGColor;
        _label.textColor = [UIColor grayColor];
    }
}
@end
