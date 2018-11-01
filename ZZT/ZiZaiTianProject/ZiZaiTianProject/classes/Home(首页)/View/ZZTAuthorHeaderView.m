//
//  ZZTAuthorHeaderView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/1.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTAuthorHeaderView.h"
#import "CommentSectionHeadView.h"
@interface ZZTAuthorHeaderView ()
@property (nonatomic,strong) UIView *authorDataView;
@property (nonatomic,strong) CommentSectionHeadView *commentSectionHeadView;

@end

@implementation ZZTAuthorHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    CommentSectionHeadView *commentSectionHeadView = [[CommentSectionHeadView alloc] init];
    _commentSectionHeadView = commentSectionHeadView;
    [self.contentView addSubview:commentSectionHeadView];
    
    UIView *authorDataView = [[UIView alloc] init];
    _authorDataView = authorDataView;
    [self.contentView addSubview:authorDataView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_commentSectionHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.right.left.equalTo(self.contentView).offset(0);
        make.height.mas_equalTo(40);
    }];
    
    [_authorDataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.contentView).offset(0);
    }];
    
    
    
    
}
@end
