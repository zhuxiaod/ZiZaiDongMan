//
//  likeCountView.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/5/7.
//  Copyright © 2016年 name. All rights reserved.
//

#import "likeCountView.h"
//#import "NetWorkManager.h"
#import "CommonMacro.h"
#import "NSString+Extension.h"
#import "UIView+Extension.h"
#import <Masonry.h>

//static NSString * const likeUrl = @"http://api.kuaikanmanhua.com/v1/comics";
//
//static NSString * const normalImageName = @"catoonDetail_like";
//
//static NSString * const pressedImageName = @"catoonDetail_like_select";

#define MyWidth 30.0f

@interface likeCountView ()

@property (nonatomic,strong) NSString *img;

@property (nonatomic,strong) NSString *selectImg;

@property (nonatomic, weak) UILabel *numLab;

@property (nonatomic, weak) UIImageView *icon;

@end

@implementation likeCountView

- (void)likeCountViewWithImg:(NSString *)img selectImg:(NSString *)selectImg{

    self.img = img;
    
    self.selectImg = selectImg;
    
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


- (void)setup {
    
    UIImageView *icon = [[UIImageView alloc] init];
    _icon = icon;
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:icon];
    
    UILabel *numLab = [[UILabel alloc] init];
    _numLab = numLab;
    numLab.textAlignment = NSTextAlignmentCenter;
    [numLab setTextColor:ZZTSubColor];
    [self addSubview:numLab];
//    //点击事件
    [self addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];

    self.islike = false;

}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self);
        make.width.height.mas_equalTo(18);
    }];
    
    [self.numLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self);
        make.left.equalTo(self.icon.mas_right);
    }];
}

//设置状态
- (void)setIslike:(BOOL)islike {
    _islike = islike;
    //0 没点  1 点了
    NSString *imgStr = islike ? self.selectImg : self.img;
    
    [self.icon setImage:[UIImage imageNamed:imgStr]];
    
    self.likeCount = self.likeCount;

    UIColor *textColor = self.islike ? ZZTSubColor : ZZTSubColor;
    
    [self setTitleColor:textColor forState:UIControlStateNormal];
}

- (void)setLikeCount:(NSInteger)likeCount {
    _likeCount = likeCount;
    
    CGFloat width = MyWidth;
    
    

    if (likeCount < 1) {
        
//        if(likeCount == -999){
//            [self.numLab setText:@""];
//            return;
//        }

       [self.numLab setText:@"0"];

    }else {

        NSString *title = [NSString makeTextWithCount:likeCount];

        [self.numLab setText:title];

        width = [title getTextWidthWithFont:self.titleLabel.font] + MyWidth;

    }
}

- (void)like {
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    self.userInteractionEnabled = NO;
    
    self.islike = !self.islike;
    
    if (self.onClick) {
        self.onClick(self);
    }

    self.userInteractionEnabled = YES;
}



@end
