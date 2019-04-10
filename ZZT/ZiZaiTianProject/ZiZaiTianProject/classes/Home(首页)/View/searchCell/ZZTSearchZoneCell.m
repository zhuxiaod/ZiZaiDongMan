//
//  ZZTSearchZoneCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/20.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTSearchZoneCell.h"
@interface ZZTSearchZoneCell()

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userIntro;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UILabel *praiseNum;
@property (weak, nonatomic) IBOutlet UILabel *likeNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headKW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageW;

@end

@implementation ZZTSearchZoneCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"searchZoneCell";
    //1.判断是否存在可重用cell
    ZZTSearchZoneCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        //2.为nib文件注册并指定可重用标识
        [tableView registerNib:[UINib nibWithNibName:@"ZZTSearchZoneCell" bundle:nil] forCellReuseIdentifier:ID];
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
    self.headKW.constant = self.contentView.height - 8;
    self.headImageW.constant = self.contentView.height - 15.5;
}

-(void)setModel:(UserInfo *)model{
    _model = model;
    
    [_headImage sd_setImageWithURL:[NSURL URLWithString:model.headimg]];
    
    _userName.text = model.nickName;
    
    _userIntro.text = model.intro;
}

@end
