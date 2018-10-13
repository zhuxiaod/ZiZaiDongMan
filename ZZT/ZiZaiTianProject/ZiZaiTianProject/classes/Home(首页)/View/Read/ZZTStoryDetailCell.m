//
//  ZZTStoryDetailCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/17.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTStoryDetailCell.h"
@interface ZZTStoryDetailCell()
@property (strong, nonatomic) UILabel *storyContent;

@end
@implementation ZZTStoryDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UILabel *storyContent = [[UILabel alloc] init];
    _storyContent = storyContent;
    [self.contentView addSubview:storyContent];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.storyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
}

-(void)setStr:(NSString *)str{
    _str = str;
    [self.storyContent setText:str];
}

@end
