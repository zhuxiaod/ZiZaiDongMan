//
//  ZZTMulCreationCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMulCreationCell.h"
@interface ZZTMulCreationCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *wordName;
@property (weak, nonatomic) IBOutlet UILabel *wordChapter;
@property (weak, nonatomic) IBOutlet UILabel *xuZuoNum;

@property (weak, nonatomic) IBOutlet UIImageView *headImg2;
@property (weak, nonatomic) IBOutlet UILabel *wordName2;
@property (weak, nonatomic) IBOutlet UILabel *wordChapter2;
@property (weak, nonatomic) IBOutlet UILabel *xuZuoNum2;

@end

@implementation ZZTMulCreationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)mulCreationCellWith:(UITableView *)tableView NSString:(NSString *)string{
    NSString *identifier = @"";
    NSInteger index = 0;
    //漫画
    if ([string isEqualToString:@"1"]) {
        identifier = @"ZZTMulCreationCellOne";
        index = 0;
    }else{
        identifier = @"ZZTMulCreationCellTwo";
        index = 1;
    }
    ZZTMulCreationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZZTMulCreationCell" owner:self options:nil] objectAtIndex:index];
    }
    return cell;
}


@end
