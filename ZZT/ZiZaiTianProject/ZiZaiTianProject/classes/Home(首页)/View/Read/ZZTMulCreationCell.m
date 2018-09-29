//
//  ZZTMulCreationCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/28.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMulCreationCell.h"
#import "ZZTChapterlistModel.h"

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

-(void)setTypeStr:(NSString *)typeStr{
    _typeStr = typeStr;
}

-(void)setXuHuaModel:(ZZTChapterlistModel *)xuHuaModel{
    _xuHuaModel = xuHuaModel;
    //1是漫画 2是文章
    if([_typeStr isEqualToString:@"1"]){
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:xuHuaModel.chapterCover] placeholderImage:[UIImage imageNamed:@"peien"]];
        _wordName.text = xuHuaModel.chapterName;
        _wordChapter.text = [NSString stringWithFormat:@"%@画",xuHuaModel.chapterPage];
        _xuZuoNum.text = xuHuaModel.xuhuaNum;
    }else{
        [self.headImg2 sd_setImageWithURL:[NSURL URLWithString:xuHuaModel.chapterCover] placeholderImage:[UIImage imageNamed:@"peien"]];
        self.wordName2.text = xuHuaModel.chapterName;
        [self.wordChapter2 setText:[NSString stringWithFormat:@"%@画",xuHuaModel.chapterPage]];
        self.xuZuoNum2.text = xuHuaModel.xuhuaNum;
    }
}

@end
