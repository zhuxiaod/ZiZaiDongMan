//
//  ZZTCartoonHistoryCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/27.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCartoonHistoryCell.h"
#define imgHeight  (CGRectGetWidth([UIScreen mainScreen].bounds) - 100)/3

@interface ZZTCartoonHistoryCell()

@property (weak, nonatomic) IBOutlet UIImageView *headBounds;

@property (weak, nonatomic) IBOutlet UIImageView *covorImg;

@property (weak, nonatomic) IBOutlet UILabel *chapterName;

@property (weak, nonatomic) IBOutlet UILabel *detaiLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *covorImgWCons;


@end

@implementation ZZTCartoonHistoryCell

-(void)setModel:(ZZTCarttonDetailModel *)model{
    _model = model;
    
    _headBounds.hidden = model.cover?YES:NO;
    
    NSString *coverImgStr = model.cover?model.cover:model.headimg;
    
    [_covorImg sd_setImageWithURL:[NSURL URLWithString:coverImgStr] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //计算image的高度
        CGFloat proportion = image.size.height / (SCREEN_HEIGHT * 0.25 - 21);
        
        CGFloat imageViewW = image.size.width / proportion;
        
        self.covorImgWCons.constant = model.cover?imageViewW:80;
        
    }];
    
    NSString *chapterStr = model.bookName?model.bookName:model.nickName;
    
    _chapterName.text = chapterStr;
    
    _detaiLab.text = model.bookType?model.bookType:model.content;
    
    if(_model.rowHeight == 0){
        CGFloat rowHeiht = model.cover?210:100;
        _model.rowHeight = rowHeiht;
    }
}

@end
