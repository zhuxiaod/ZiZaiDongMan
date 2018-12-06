//
//  ZZTSearchCartoonCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTSearchCartoonCell.h"
@interface ZZTSearchCartoonCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet UILabel *suggestionName;
@property (weak, nonatomic) IBOutlet UILabel *suggestionAuthor;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
@property (weak, nonatomic) IBOutlet UIImageView *suggestionImage;

@end

@implementation ZZTSearchCartoonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"searchCartoonCell";
    //1.判断是否存在可重用cell
    ZZTSearchCartoonCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        //2.为nib文件注册并指定可重用标识
        [tableView registerNib:[UINib nibWithNibName:@"ZZTSearchCartoonCell" bundle:nil] forCellReuseIdentifier:ID];
        //3.重新获取cell
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
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

}
@end
