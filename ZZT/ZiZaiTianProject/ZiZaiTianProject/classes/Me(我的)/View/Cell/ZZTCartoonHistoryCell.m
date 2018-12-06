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

@property (nonatomic,strong) UIImageView *headBounds;
@property (nonatomic,strong) UIImageView *headImg;
@property (nonatomic,strong) UILabel *chapterLab;
@property (nonatomic,strong) UILabel *pageLab;//类型
@property (nonatomic,strong) UIImageView *commentView;
@property (nonatomic,strong) UILabel *commentLab;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) NSArray *imgArray;

@property (nonatomic,strong) NSMutableArray * groupImgArr;
@property (strong, nonatomic) UIView *bgImgsView;

@end

@implementation ZZTCartoonHistoryCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //头像框
    UIImageView *headBounds = [[UIImageView alloc] init];
    [headBounds setImage:[UIImage imageNamed:@"我的-头像框"]];
    //    headBounds.backgroundColor = [UIColor redColor];
    _headBounds = headBounds;
    [self.contentView addSubview:headBounds];
    
    //图片
    UIImageView *headImg = [[UIImageView alloc] init];
    //    headImg.backgroundColor = [UIColor yellowColor];
    _headImg = headImg;
    headImg.contentMode = UIViewContentModeScaleAspectFill;
    headImg.layer.cornerRadius = 10;
    headImg.layer.masksToBounds = YES;
    [self.contentView addSubview:headImg];
    
    //章节名
    UILabel *chapterLab = [[UILabel alloc] init];
    //    chapterLab.backgroundColor = [UIColor yellowColor];
    _chapterLab = chapterLab;
    [self.contentView addSubview:chapterLab];
    
    //底线
    UIView *bottomView = [[UIView alloc] init];
    //    bottomView.backgroundColor = [UIColor grayColor];
    [bottomView setBackgroundColor:[UIColor colorWithHexString:@"#F0F1F2"]];
    _bottomView = bottomView;
    [self.contentView addSubview:bottomView];
    
    //页数
    UILabel *pageLab = [[UILabel alloc] init];
    pageLab.textColor = [UIColor grayColor];
    //    pageLab.backgroundColor = [UIColor yellowColor];
    _pageLab = pageLab;
    [self.contentView addSubview:pageLab];
    
    _groupImgArr = [NSMutableArray array];
    
    _bgImgsView = [[UIView alloc]init];
    [self.contentView addSubview:_bgImgsView];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(0);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(1);
    }];
    
    //如果是漫画
    if(self.model.cover){
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(10);
            make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
//            make.width.mas_equalTo(80);
        }];
    }else{
        [self.headImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(10);
            make.left.equalTo(self).with.offset(10);
            //            make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
//            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
        //头像框
        [self.headBounds mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(7);
            make.left.equalTo(self).with.offset(7);
            //            make.bottom.equalTo(self.bottomView.mas_top).with.offset(-10);
            make.width.mas_equalTo(86);
            make.height.mas_equalTo(86);
        }];
    }
    
    [self.chapterLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.left.equalTo(self.headImg.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.pageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chapterLab.mas_bottom).with.offset(10);
        make.left.equalTo(self.headImg.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.bgImgsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageLab.mas_bottom).with.offset(10);
        make.left.equalTo(self.headImg.mas_right).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.bottom.equalTo(self).with.offset(-10);
    }];
}


-(void)setModel:(ZZTCarttonDetailModel *)model{
    _model = model;
    //有没有封面
    if(model.cover){
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.cover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(!image)return ;

            //计算image的高度
            CGFloat proportion = image.size.height / (SCREEN_HEIGHT * 0.25 - 21);
            //            NSLog(@"proportion:%f",proportion);
            CGFloat imageViewW = image.size.width / proportion;
            //            NSLog(@"imageViewW:%f",imageViewW);
            [self.headImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(imageViewW);
            }];
        }];
    }else{
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headimg]completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if(!image)return ;
            //计算image的高度
            CGFloat proportion = image.size.height / (SCREEN_HEIGHT * 0.25 - 21);
            //            NSLog(@"proportion:%f",proportion);
            CGFloat imageViewW = image.size.width / proportion;
            //            NSLog(@"imageViewW:%f",imageViewW);
            [self.headImg mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(imageViewW);
            }];
        }];
    }
    
    //如果有书名
    if(model.bookName){
        if([model.type isEqualToString:@"1"]){
            self.chapterLab.text = model.bookName;
        }
    }else{
        //没有书名
        self.chapterLab.text = model.nickName;
    }
        
    if(model.bookType){
        NSString *bookType = [model.bookType stringByReplacingOccurrencesOfString:@"," withString:@" "];
        [self.pageLab setText:bookType];
    }else{
        [self.pageLab setText:model.content];
    }
    //图片view
    if(model.contentImg){
        NSArray *array = [model.contentImg componentsSeparatedByString:@","];
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            NSString *str = array[i];
            str = [NSString stringWithFormat:@"%@%@",model.qiniu,str];
            [mutableArray addObject:str];
        }
        _imgArray = mutableArray;
//        [self setupImageGroupView];
    }
}

//-(void)setupImageGroupView{
//    [self layoutIfNeeded];
//    CGFloat w = (self.bgImgsView.width - 20) /3;
//    CGFloat h = (self.bgImgsView.width - 20) /3;
//
//    CGFloat edge = 10;
//    for (int i = 0; i<_imgArray.count; i++) {
//
//        int row = i / 3;
//        int loc = i % 3;
//        CGFloat x = (edge + w) * loc ;
//        CGFloat y = (edge + h) * row;
//
//        UIImageView * img =[[UIImageView alloc]init];
//        [img sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]]];
//        //        img.image = [UIImage imageNamed:_imgArray[i]];
//        img.backgroundColor = [UIColor greenColor];
//        img.frame = CGRectMake(x, y, w, h);
//        img.userInteractionEnabled = YES;
//        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
//        [img addGestureRecognizer:tap];
//        [_bgImgsView addSubview:img];
//        [_groupImgArr addObject:img];
//    }
//}

+ (CGFloat)cellHeightWithStr:(NSString *)str imgs:(NSArray *)imgs{
    CGFloat strH = [str heightWithWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - 40 font:14];
    CGFloat cellH = strH + 100;
    NSInteger row = imgs.count / 3;
    if (imgs.count) {
        if (imgs.count % 3 !=0) {
            row += 1;
        }
        cellH +=  row * imgHeight  + (row-1) * 10; // 图片高度 + 间隙
    }
    return  cellH;
}
@end
