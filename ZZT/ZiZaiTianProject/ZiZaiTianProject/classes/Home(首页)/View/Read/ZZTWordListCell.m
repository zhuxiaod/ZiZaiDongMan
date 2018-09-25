//
//  ZZTWordListCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/22.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTWordListCell.h"
#import "ZZTChapterlistModel.h"
@interface ZZTWordListCell()
@property (weak, nonatomic) IBOutlet UIImageView *wordImage;
@property (weak, nonatomic) IBOutlet UILabel *wordName;
@property (weak, nonatomic) IBOutlet UILabel *wordPage;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UIImageView *likeImage;
@property (assign,nonatomic) BOOL ifrelease;
@end
@implementation ZZTWordListCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLike)];
//    [self.likeImage addGestureRecognizer:tap];

}

-(void)setModel:(ZZTChapterlistModel *)model{
    _model = model;
    
    [self.wordImage sd_setImageWithURL:[NSURL URLWithString:model.chapterCover]];
    self.wordName.text = model.chapterName;
    self.wordName.textColor = [UIColor grayColor];

    self.likeNum.text = [NSString stringWithFormat:@"%ld",model.praiseNum];
    self.likeNum.textColor = [UIColor grayColor];
    
    self.wordPage.text = model.chapterpage;
    
    self.commentNum.text = model.commentNum;
    
//    if(model.ifrelease){
    [self.likeImage setImage:[UIImage imageNamed:@"正文-点赞-已点赞"]];
//    }else{
//        [self.likeImage setImage:[UIImage imageNamed:@"正文-点赞-未点赞(灰色）"]];
//    }
//    self.ifrelease = model.ifrelease;
}

////点赞和评论跳转
//-(void)clickLike{
//    //反状态
//    NSInteger zanNum = [_likeNum.text integerValue];
//    UIImage *selZan = [UIImage imageNamed:@"正文-点赞-未点赞(灰色）"];
//    if (_ifrelease) {
//        _ifrelease = NO;
//        _likeImage.image = selZan;
//        --zanNum;
//        _likeNum.text = [NSString stringWithFormat:@"%ld",zanNum];
//    }else{
//        _ifrelease = YES;
//        _likeImage.image = [UIImage imageNamed:@"正文-点赞-已点赞"];
//        ++zanNum;
//        _likeNum.text = [NSString stringWithFormat:@"%ld",zanNum];
//    }
//    _model.praiseNum = zanNum;
//    _model.ifrelease = _ifrelease;
//    if (self.btnBlock) {
//        // 调用block传入参数
//        self.btnBlock(self,_model);
//    }
//}

@end
