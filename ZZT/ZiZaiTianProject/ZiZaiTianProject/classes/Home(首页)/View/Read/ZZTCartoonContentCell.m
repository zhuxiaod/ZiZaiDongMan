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

@property (nonatomic,strong) NSNumber *imageHeight;
@end

@implementation ZZTCartoonContentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        
        _content = imageView;

//        imageView.sd_layout
//        .leftSpaceToView(self.contentView, 0)
//        .rightSpaceToView(self.contentView, 0)
//        .topSpaceToView(self.contentView, 0)
//        .autoHeightRatio(0);
//        [self setupAutoHeightWithBottomView:_content bottomMargin:0];

        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        //点赞按钮
//        UIImageView *likeView = [[UIImageView alloc] init];
//        _likeView = likeView;
//        likeView.backgroundColor = [UIColor yellowColor];
//        [self.contentView addSubview:likeView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.content.frame = self.bounds;
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(0);
        make.right.equalTo(self).with.offset(0);
        make.bottom.equalTo(self).with.offset(0);
//        make.height.mas_equalTo(@400);
    }];
//    [self.likeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).with.offset(-10);
//        make.right.equalTo(self).with.offset(-10);
//        make.height.mas_equalTo(@50);
//        make.width.mas_equalTo(@50);
//    }];
}

-(void)setModel:(ZZTCartoonModel *)model{
    _model = model;
    
//    [_content sd_setImageWithURL:[NSURL URLWithString:model.cartoonUrl] placeholderImage:[UIImage imageNamed:@"peien"]];
    _content.contentMode = UIViewContentModeScaleToFill;
    __block float height = 0.0f;
    [_content sd_setImageWithURL:[NSURL URLWithString:model.cartoonUrl] placeholderImage:[UIImage imageNamed:@"chapterPlaceV"] options:0 completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if(image){
            self.content.contentMode = UIViewContentModeScaleAspectFit;

            CGFloat percentage;
            CGFloat imageHeight;
            NSLog(@"imageW:%@",image);
            if(image.size.width > Screen_Width){
                percentage = image.size.width / Screen_Width;
                imageHeight = image.size.height / percentage;
            }else{
                percentage = Screen_Width / image.size.width;
                imageHeight = image.size.height * percentage;
            }
            height = imageHeight;
            //        刷新
            //        判断图片是否加载完成 如果是不用
            if(cacheType == SDImageCacheTypeNone){
                NSLog(@"我是刚被下载下来的");
                
            }
            else if(cacheType == SDImageCacheTypeDisk){
                NSLog(@"我本来就在");
            }
            else if (cacheType == SDImageCacheTypeMemory){
                NSLog(@"我是内存里面的");
            }
            
            if ([self.delegate respondsToSelector:@selector(cellHeightUpdataWithIndex:Height:)]) {
                [self.delegate cellHeightUpdataWithIndex:model.index Height:imageHeight];
            }
            //        if(cacheType == SDImageCacheTypeNone || cacheType == SDImageCacheTypeDisk){
            
            //        }
            
            NSNumber *newHeight = [NSNumber numberWithDouble:height];
            self.imageHeight = newHeight;
        }
    }];
}

-(void)setCartoonImg:(UIImage *)cartoonImg{
    _cartoonImg = cartoonImg;
    
    _content.image = cartoonImg;
}

-(NSNumber *)getImgaeHeight{
    return self.imageHeight;
}
@end
