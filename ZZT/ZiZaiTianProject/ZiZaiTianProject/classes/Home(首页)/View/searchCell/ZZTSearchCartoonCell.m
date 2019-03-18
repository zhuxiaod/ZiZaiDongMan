//
//  ZZTSearchCartoonCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTSearchCartoonCell.h"
#import "ZZTDetailModel.h"

@interface ZZTSearchCartoonCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet UILabel *suggestionName;
@property (weak, nonatomic) IBOutlet UILabel *suggestionAuthor;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
@property (weak, nonatomic) IBOutlet UIImageView *suggestionImage;
@property (weak, nonatomic) IBOutlet UIImageView *likeImg;
@property (weak, nonatomic) IBOutlet UIImageView *commentImg;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;

@end

@implementation ZZTSearchCartoonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView identify:(NSString *)identify{
//    static NSString *ID = @"searchCartoonCell";
    //1.判断是否存在可重用cell
    ZZTSearchCartoonCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZZTSearchCartoonCell" owner:nil options:nil] firstObject];
//        //2.为nib文件注册并指定可重用标识
//        [tableView registerNib:[UINib nibWithNibName:@"ZZTSearchCartoonCell" bundle:nil] forCellReuseIdentifier:ID];
//        //3.重新获取cell
//        cell = [tableView dequeueReusableCellWithIdentifier:ID];
    }
    //不要选中状态
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //4.返回cell
    return cell;
}

+ (instancetype)materialCellWithTableView:(UITableView *)tableView identify:(NSString *)identify{
//    static NSString *ID = @"searchCartoon";
    //1.判断是否存在可重用cell
    ZZTSearchCartoonCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
//        //2.为nib文件注册并指定可重用标识
//        [tableView registerNib:[UINib nibWithNibName:@"ZZTSearchCartoonCell" bundle:nil] forCellReuseIdentifier:ID];
//        //3.重新获取cell
//        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZZTSearchCartoonCell" owner:nil options:nil] firstObject];
    }
    //不要选中状态
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //4.返回cell
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.suggestionImage.layer.cornerRadius = 10;
    self.suggestionImage.layer.masksToBounds = YES;
}

-(void)setModel:(ZZTCarttonDetailModel *)model{
    _model = model;
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];

    [self.suggestionImage sd_setImageWithURL:[NSURL URLWithString:[@"http://img.cdn.zztian.cn/"stringByAppendingString:model.cover]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //cell高度
        if(!image)return ;

        CGFloat cellH = SCREEN_HEIGHT * 0.22;
        CGFloat cellW = cellH * 1080 / 1920;
        NSLog(@"cellW:%f",cellW);
        self.imageWidth.constant = cellW;
    }];
    
    //书名
    [self.suggestionName setText:model.bookName];
    
    //作者
    [self.suggestionAuthor setText:model.author];
    //收藏
    
    //like
    [self.likeNum setText:[NSString stringWithFormat:@"%ld",model.clickNum]];
    
    //comment
    [self.commentNum setText:[NSString stringWithFormat:@"%ld",model.commentNum]];
    
    self.collectButton.selected = [model.ifauthor integerValue];
    
    [self.collectButton setImage:[UIImage imageNamed:@"未收藏"] forState:UIControlStateNormal];
    
    [self.collectButton setImage:[UIImage imageNamed:@"已收藏"] forState:UIControlStateSelected];
    
    [self.collectButton addTarget:self action:@selector(collectCartoon:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)collectCartoon:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    NSDictionary *dic = @{
                          @"userId":[UserInfoManager share].ID,
                          @"authorId":self.model.id
                          };
    //    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    AFHTTPSessionManager *manager = [SBAFHTTPSessionManager getManager];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark - 设置素材搜索
-(void)setMaterialModel:(ZZTDetailModel *)materialModel{
    _materialModel = materialModel;
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    if([[materialModel.img substringFromIndex:[materialModel.img length] - 3] isEqualToString:@"jpg"]){
        [self.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    [self.suggestionImage sd_setImageWithURL:[NSURL URLWithString:materialModel.img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        //cell高度
        if(!image)return ;
        
        CGFloat cellH = SCREEN_HEIGHT * 0.22;
        CGFloat cellW = cellH * 1080 / 1920;
        NSLog(@"cellW:%f",cellW);
        self.imageWidth.constant = cellW;
    }];
    //书名
    [self.suggestionName setText:materialModel.fodderName];
    
    //作者
    [self.suggestionAuthor setHidden:YES];
    
    //like
    [self.likeNum setHidden:YES];
    
    //comment
    [self.commentNum setHidden:YES];
    
    [self.likeImg setHidden:YES];
    
    [self.commentImg setHidden:YES];
    
    self.collectButton.hidden = YES;
    
//    [self.collectButton setImage:[UIImage imageNamed:@"未关注"] forState:UIControlStateNormal];
//
//    [self.collectButton setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateSelected];
//
//    [self.collectButton addTarget:self action:@selector(attentionMaterial:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)attentionMaterial:(UIButton *)btn{
    NSLog(@"加关注");
}


@end
