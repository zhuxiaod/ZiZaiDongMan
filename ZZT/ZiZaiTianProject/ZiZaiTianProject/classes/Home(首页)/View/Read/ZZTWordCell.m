//
//  ZZTWordCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/12.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTWordCell.h"
#import "ZZTCarttonDetailModel.h"

@interface ZZTWordCell()
@property (weak, nonatomic) IBOutlet UIImageView *ctImage;
@property (weak, nonatomic) IBOutlet UILabel *ctName;
@property (weak, nonatomic) IBOutlet UILabel *ctTime;
@property (weak, nonatomic) IBOutlet UILabel *praise;


@end
@implementation ZZTWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
}

-(void)setModel:(ZZTCarttonDetailModel *)model{
    self.ctName.text = model.bookName;
    [self.ctImage sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"peien"]];
    //时间
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
//    NSString *currentDateString = [dateFormatter stringFromDate:model.createdate];
//    self.ctTime.text = currentDateString;
    self.praise.text = [NSString stringWithFormat:@"%ld",model.praiseNum];
}
@end
