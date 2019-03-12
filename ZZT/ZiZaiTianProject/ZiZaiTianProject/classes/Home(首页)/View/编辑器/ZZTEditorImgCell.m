//
//  ZZTEditorImgCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/29.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorImgCell.h"
#import "ZZTDetailModel.h"

@interface ZZTEditorImgCell ()


@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *folderImg;
@property (nonatomic,strong) UIImageView *collectImg;
@end

@implementation ZZTEditorImgCell

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    UILabel *label = [[UILabel alloc] init];
    _label = label;
    [self addSubview:label];
    
    //image
    //name
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    self.imageView.clipsToBounds = YES;
    
    self.imageView.layer.cornerRadius = 10.0f;
    
    self.imageView.layer.masksToBounds = YES;
    
    self.imageView.userInteractionEnabled = YES;
    
    [self addSubview:imageView];
    
    //文件夹
    UIImageView *folderImg = [[UIImageView alloc] init];
    _folderImg = folderImg;
    folderImg.userInteractionEnabled = YES;
    [folderImg setImage:[UIImage imageNamed:@"editCellFolder"]];
    [self addSubview:folderImg];
    
    //收藏
    UIImageView *collectImg = [[UIImageView alloc] init];
    _collectImg = collectImg;
    collectImg.userInteractionEnabled = YES;
    [collectImg setImage:[UIImage imageNamed:@"editCellCollect"]];
    [self addSubview:collectImg];
}

-(void)layoutSubviews{
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self);
        make.height.mas_equalTo(0);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self);
        make.bottom.equalTo(self.label.mas_top);
    }];
    
    [self.collectImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.left.equalTo(self).offset(2);
        make.height.width.mas_equalTo(20);
    }];
    
    [self.folderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-2);
        make.left.equalTo(self).offset(2);
        make.height.width.mas_equalTo(20);
    }];
}

-(void)setCellState:(NSInteger)cellState{
    _cellState = cellState;
    if(cellState == 1){
        [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(16);
        }];
    }
}

-(void)setModel:(ZZTDetailModel *)model{
    _model = model;
    
    if([model.img isEqualToString:@"editorUpload"]){
        [self.imageView setImage:[UIImage imageNamed:model.img]];
    }else{
          [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:[UIImage imageNamed:@"bannerPlaceV"] options:SDWebImageProgressiveDownload | SDWebImageCacheMemoryOnly];
    }

    _folderImg.hidden = YES;
    _collectImg.hidden = YES;

    if(model.flag == 1){
        _folderImg.hidden = NO;
    }
    if(model.ifCollect == 1){
        _collectImg.hidden = NO;
    }
    //通过判断显示不同的mode
    
}

-(void)setImageStr:(NSString *)imageStr{
    _imageStr = imageStr;
    [self.imageView setImage:[UIImage imageNamed:imageStr]];
//    [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
//    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];


}
@end
