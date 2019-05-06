//
//  ZZTStatusCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTStatusTabCell.h"
#import "ZZTStatusViewModel.h"
#import "ZZTStatusPicView.h"
#import "ZZTCommentBtn.h"

@interface ZZTStatusTabCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *vipImg;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet ZZTStatusPicView *picView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet ZZTCommentBtn *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewBCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabCons;

@end

@implementation ZZTStatusTabCell

static CGFloat edgeMargin = 15;
static CGFloat itemMargin = 10;


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLabW.constant = SCREEN_WIDTH - 2 * 12;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushZoneVC)];
    [self.headImg addGestureRecognizer:tapGesture];

}

#pragma mark - 跳转空间页
-(void)pushZoneVC{
    //跳转页面
    ZZTMyZoneViewController *zoneVC = [[ZZTMyZoneViewController alloc] init];
    //用户id
    zoneVC.userId = _viewModel.userId;
    [[self myViewController].navigationController pushViewController:zoneVC animated:YES];
}

-(void)setViewModel:(ZZTStatusViewModel *)viewModel{
    _viewModel = viewModel;
    
    [_headImg sd_setImageWithURL:[NSURL URLWithString:viewModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"用户头像"]];
    
    _userName.text = viewModel.nickName;
    
    _contentLab.text = viewModel.content;
    
    _contentLabCons.constant = _contentLab.text.length == 0?0:8;
    
    _dateLab.text = viewModel.dataText;

    _attentionBtn.selected = viewModel.ifConcern;
    
    _attentionBtn.hidden = viewModel.isUser;
    
    //设置Size
    CGSize picViewSize = [self calculatePicViewSize:viewModel.imgArray.count];
    _picViewW.constant = picViewSize.width;
    _picViewH.constant = picViewSize.height;
    _picView.imgArray = viewModel.imgArray;

    //评论按钮
    [_commentBtn setTitle:viewModel.replyCount forState:UIControlStateNormal];
    
    //点赞
    [_likeBtn setTitle:viewModel.praisecount forState:UIControlStateNormal];

    [_likeBtn setSelected:viewModel.ifPraise];

    _reportBtn.hidden = viewModel.isUser;
    
    _vipImg.hidden = !viewModel.isVip;
}

- (IBAction)attentionBtnClick:(UIButton *)sender {
    //关注事件
    [SBAFHTTPSessionManager.sharedManager sendAttentionDataWithAuthorId:_viewModel.userId finished:^(id  _Nullable responseObject, NSError *error) {
        if(error != nil){
            NSLog(@"%@",error);
            [MBProgressHUD showSuccess:@"关注失败"];
            return;
        }
        sender.selected = !sender.selected;
    }];
}
//评论
- (IBAction)commentBtnClick:(ZZTCommentBtn *)sender {
    [sender gotoCommentViewWithId:_viewModel.userId];
}

//点赞
- (IBAction)likeBtnClick:(UIButton *)sender {
    [SBAFHTTPSessionManager.sharedManager sendUserLikeData:_viewModel.statusId finished:^(id  _Nullable responseObject, NSError *error) {
        if(error != nil){
            NSLog(@"%@",error);
            [MBProgressHUD showSuccess:@"点赞失败"];
            return;
        }
        if(self.reloadDataBlock){
            self.reloadDataBlock();
        }
    }];
}

//举报
- (IBAction)reportBtnClick:(ZZTReportBtn *)sender {
    ZZTReportModel *model = [ZZTReportModel initWithName:_viewModel.nickName Content:_viewModel.content Index:_viewModel.modelIndex];
    sender.model = model;
    [sender reportUserData];
}

-(CGSize)calculatePicViewSize:(NSInteger)count{
    if(count == 0){
        _collectionViewBCons.constant = 0;
        return CGSizeZero;
    }
    
    _collectionViewBCons.constant = 8;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.picView.collectionViewLayout;
    
    if(count == 1){
        NSString *urlStr = _viewModel.imgArray.lastObject;
        UIImage *img = [SDWebImageManager.sharedManager.imageCache imageFromDiskCacheForKey:urlStr];
        CGFloat W = 0.0;
        CGFloat H = 0.0;
        if(img.size.width == 0 && img.size.height == 0){
            return CGSizeMake(0,0);
        }
        if(img.size.width > img.size.height){
            CGFloat height = 120;
            W = height * img.size.width / img.size.height;
            H = height;
        }else{
            CGFloat width = 120;
            H = width * img.size.height / img.size.width;
            W = width;
        }
        layout.itemSize = CGSizeMake(W, H);
        return CGSizeMake(W, H);
    }
    
    CGFloat imageViewHW = (SCREEN_WIDTH - 2 * edgeMargin - 2 * itemMargin) / 3;
    
    layout.itemSize = CGSizeMake(imageViewHW, imageViewHW);
    
    if(count == 4){
        CGFloat picViewWH = imageViewHW * 2 + itemMargin;
        return CGSizeMake(picViewWH + 2, picViewWH);
    }
    
    NSInteger rows = (count - 1) / 3 + 1;
    
    CGFloat picViewH = rows * imageViewHW + (rows - 1) * itemMargin;
    
    CGFloat picViewW = SCREEN_WIDTH - 2 * edgeMargin;

    return CGSizeMake(picViewW, picViewH);
}

@end
