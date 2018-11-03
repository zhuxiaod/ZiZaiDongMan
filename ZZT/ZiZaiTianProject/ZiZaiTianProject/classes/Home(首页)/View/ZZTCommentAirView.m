//
//  ZZTCommentAirView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/3.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCommentAirView.h"

@implementation ZZTCommentAirView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    UIImageView *airImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:airImageView];
    
    airImageView.image = [UIImage imageNamed:@"空白"];
    
    [airImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.contentView).offset(0);
    }];
}

@end
