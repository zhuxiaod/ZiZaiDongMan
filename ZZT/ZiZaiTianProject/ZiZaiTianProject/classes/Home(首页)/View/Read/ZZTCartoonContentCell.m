//
//  ZZTCartoonContentCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCartoonContentCell.h"
#import "ZZTCartoonModel.h"
@interface ZZTCartoonContentCell ()
@property (nonatomic,strong) UIImageView *likeView;
@end
@implementation ZZTCartoonContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        
        _content = imageView;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //点赞按钮
        UIImageView *likeView = [[UIImageView alloc] init];
        _likeView = likeView;
        likeView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:likeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.content.frame = self.bounds;
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
    }];
    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).with.offset(-10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(@50);
        make.width.mas_equalTo(@50);
    }];
}

-(void)setModel:(ZZTCartoonModel *)model{
    _model = model;
    [_content sd_setImageWithURL:[NSURL URLWithString:model.cartoonUrl] placeholderImage:[UIImage imageNamed:@"peien"]];
    
}
@end
