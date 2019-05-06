//
//  ZZTMyZoneCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMyZoneCell.h"
#import "ZZTCommentBtn.h"
#import "HZPhotoBrowser.h"
#import "ZZTStatusViewModel.h"
#import "ZZTStatusPicView.h"

@interface ZZTMyZoneCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet ZZTStatusPicView *picView;

@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet ZZTCommentBtn *commentBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picViewBCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabCons;


@end

@implementation ZZTMyZoneCell

static CGFloat edgeMargin = 15;
static CGFloat itemMargin = 10;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLabW.constant = SCREEN_WIDTH - 2 * 12;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //长按删除
    UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    longPressGesture.minimumPressDuration = 1.5f;//设置长按 时间
    [self addGestureRecognizer:longPressGesture];
}

-(void)cellLongPress:(UIGestureRecognizer *)gesture{
    if(self.longPressBlock){
        self.longPressBlock(self.model);
    }
}

-(void)setModel:(ZZTStatusViewModel *)model{
    _model = model;
    
    _dateLab.attributedText = [self getPriceAttribute:model.publishtime];
    
    _contentLab.text = model.content;
    
    _contentLabCons.constant = _contentLab.text.length == 0?0:8;

    //设置Size
    CGSize picViewSize = [self calculatePicViewSize:model.imgArray.count];
    _picViewW.constant = picViewSize.width;
    _picViewH.constant = picViewSize.height;
    _picView.imgArray = model.imgArray;
    
    //评论按钮
    [_commentBtn setTitle:model.replyCount forState:UIControlStateNormal];
    
    //点赞
    [_likeBtn setTitle:model.praisecount forState:UIControlStateNormal];
    
    [_likeBtn setSelected:model.ifPraise];
    
    _reportBtn.hidden = model.isUser;
}

//评论
- (IBAction)commentBtnClick:(ZZTCommentBtn *)sender {
    [sender gotoCommentViewWithId:_model.userId];
}

//点赞
- (IBAction)likeBtnClick:(UIButton *)sender {
    [SBAFHTTPSessionManager.sharedManager sendUserLikeData:_model.statusId finished:^(id  _Nullable responseObject, NSError *error) {
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
    ZZTReportModel *model = [ZZTReportModel initWithName:_model.nickName Content:_model.content Index:_model.modelIndex];
    sender.model = model;
    [sender reportUserData];
}

//年月混排
-(NSMutableAttributedString *)getPriceAttribute:(NSString *)string{
    //时间
    NSString *time = [NSString timeWithStr:[NSString stringWithFormat:@"%@",string]];
    
    NSArray *times = [time componentsSeparatedByString:@"-"];
    
    time = [NSString stringWithFormat:@"%@%@月",times[2],times[1]];
    
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:time];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange pointRange = NSMakeRange(0, 2);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:30];
    dic[NSKernAttributeName] = @2;
    //赋值
    [attribut addAttributes:dic range:pointRange];
    return attribut;
}

-(CGSize)calculatePicViewSize:(NSInteger)count{
    if(count == 0){
        _picViewBCons.constant = 0;
        return CGSizeZero;
    }
    
    _picViewBCons.constant = 8;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.picView.collectionViewLayout;
    
    if(count == 1){
        NSString *urlStr = _model.imgArray.lastObject;
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
        NSLog(@"W:%f,H:%f",W,H);
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
