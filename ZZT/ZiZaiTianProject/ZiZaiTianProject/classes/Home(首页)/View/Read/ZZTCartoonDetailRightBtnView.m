//
//  ZZTCartoonDetailRightBtnView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/25.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTCartoonDetailRightBtnView.h"

@interface ZZTCartoonDetailRightBtnView ()

@property (nonatomic,weak) UIButton *rightAttentionBtn;


@property (nonatomic,weak) UIButton *rightLikeBtn;

@end

@implementation ZZTCartoonDetailRightBtnView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        
        [self setupUI];
        
    } return self;
}

-(void)setupUI{
    //收藏
    UIButton *rightCollectBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"wordsDetail_collect_normal"] title:@"收藏" titleColor:ZZTSubColor];
    _rightCollectBtn = rightCollectBtn;
    [rightCollectBtn setImage:[UIImage imageNamed:@"editor_collect_select"] forState:UIControlStateSelected];
    [rightCollectBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    rightCollectBtn.frame = CGRectMake(0, 0, 50, 70);
    [rightCollectBtn addTarget:self action:@selector(collectTarget:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightCollectBtn];
    [self initButton:rightCollectBtn];
    
    //点赞
    UIButton *rightLikeBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"未点赞"] title:@"点赞" titleColor:ZZTSubColor];
    [rightLikeBtn setImage:[UIImage imageNamed:@"已点赞"] forState:UIControlStateSelected];
    [rightLikeBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [rightLikeBtn addTarget:self action:@selector(likeTarget:) forControlEvents:UIControlEventTouchUpInside];
    _rightLikeBtn = rightLikeBtn;
    
    rightLikeBtn.frame = CGRectMake(0, CGRectGetMaxY(rightCollectBtn.frame), 50, 70);
    [self addSubview:rightLikeBtn];
    [self initButton:rightLikeBtn];
    
    //关注
    UIButton *rightAttentionBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"未关注"] title:@"关注" titleColor:ZZTSubColor];
    [rightAttentionBtn setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateSelected];
    [rightAttentionBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [rightAttentionBtn addTarget:self action:@selector(attentionTarget:) forControlEvents:UIControlEventTouchUpInside];
    rightAttentionBtn.frame = CGRectMake(0, CGRectGetMaxY(rightLikeBtn.frame), 50, 70);
    _rightAttentionBtn = rightAttentionBtn;
    [self addSubview:rightAttentionBtn];
    [self initButton:rightAttentionBtn];
}

#pragma mark - 收藏block
-(void)collectTarget:(UIButton *)btn{
    self.collectStatus = [NSString stringWithFormat:@"%d",!btn.selected];
    if(self.collectBtnBlock){
        self.collectBtnBlock(1);
    }
}

#pragma mark - 收藏block
-(void)likeTarget:(UIButton *)btn{
    self.likeStatus = [NSString stringWithFormat:@"%d",!btn.selected];
    if(self.likeBtnBlock){
        self.likeBtnBlock();
    }
}

#pragma mark - 关注block
-(void)attentionTarget:(UIButton *)btn{
    self.attentionStatus = [NSString stringWithFormat:@"%d",!btn.selected];
    if(self.attentionBtnBlock){
        self.attentionBtnBlock();
    }
}


//设置显示的状态
-(void)setLikeModel:(ZZTStoryModel *)likeModel{
    _likeModel = likeModel;
}

-(void)setLikeStatus:(NSString *)likeStatus{
    _likeStatus = likeStatus;
    _rightLikeBtn.selected = [likeStatus integerValue];
    NSString *btnTitle = _rightLikeBtn.selected?@"已点赞":@"点赞";
    [_rightLikeBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self changeBtnColor:_rightLikeBtn];
    [self initButton:_rightLikeBtn];
}

-(void)setCollectStatus:(NSString *)collectStatus{
    _collectStatus = collectStatus;
    _rightCollectBtn.selected = [collectStatus integerValue];
    //改字体
    NSString *btnTitle = _rightCollectBtn.selected?@"已收藏":@"收藏";
    [_rightCollectBtn setTitle:btnTitle forState:UIControlStateNormal];
    //改颜色
    [self changeBtnColor:_rightCollectBtn];

    [self initButton:_rightCollectBtn];
}

-(void)setAttentionStatus:(NSString *)attentionStatus{
    _attentionStatus = attentionStatus;
    _rightAttentionBtn.selected = [attentionStatus integerValue];
    NSString *btnTitle = _rightAttentionBtn.selected?@"已关注":@"关注";
    [_rightAttentionBtn setTitle:btnTitle forState:UIControlStateNormal];
    [self changeBtnColor:_rightAttentionBtn];

    [self initButton:_rightAttentionBtn];
}

-(void)changeBtnColor:(UIButton *)btn{
    UIColor *btnColor = btn.selected?ZZTSubColor:[UIColor grayColor];
    [btn setTitleColor:btnColor forState:UIControlStateNormal];
}

//将按钮设置为图片在上，文字在下
-(void)initButton:(UIButton*)btn{
    float  spacing = 4;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
}

@end
