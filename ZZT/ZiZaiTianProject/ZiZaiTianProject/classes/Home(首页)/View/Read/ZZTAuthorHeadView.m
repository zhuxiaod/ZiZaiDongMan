//
//  ZZTAuthorHeadView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTAuthorHeadView.h"
@interface ZZTAuthorHeadView ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *authorName;

@end

@implementation ZZTAuthorHeadView

+(instancetype)AuthorHeadView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZZTAuthorHeadView" owner:nil options:nil]lastObject];
}

-(void)setUserModel:(UserInfo *)userModel{
    _userModel = userModel;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:userModel.headimg] placeholderImage:[UIImage imageNamed:@"peien"]];
    self.authorName.text = userModel.nickName;
}
@end
