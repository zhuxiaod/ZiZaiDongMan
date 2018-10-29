//
//  ZZTStoryDetailCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/17.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTStoryDetailCell.h"
#import "ZZTStoryModel.h"

@interface ZZTStoryDetailCell()

@property (strong, nonatomic) UILabel *storyContent;
@property (assign,nonatomic) BOOL isReload;
@end

@implementation ZZTStoryDetailCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
        _isReload = NO;
    }
    return self;
}

-(void)setupUI{
    UILabel *storyContent = [[UILabel alloc] init];
    _storyContent = storyContent;
    storyContent.lineBreakMode = NSLineBreakByWordWrapping;
    storyContent.numberOfLines = 0;
    [storyContent sizeToFit];
    [self.contentView addSubview:storyContent];
    storyContent.font = [UIFont systemFontOfSize:SectionHeaderBigFontSize];
//    _storyContent.sd_layout.autoHeightRatio(0);
//    [self setupAutoHeightWithBottomView:self.storyContent bottomMargin:0];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.storyContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).with.offset(0);
        make.left.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
}

-(void)setStr:(NSString *)str{
    _str = str;
    NSString *htmlString = @"";

    NSError *error;
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    if([[str substringToIndex:5]isEqualToString:@"/var/"])
    {
        htmlString = [[NSString alloc] initWithContentsOfFile:str encoding:enc error:&error];
    }else{
        htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:str] encoding:enc error:&error];
    }
    
    if(!error){
        htmlString = [self getZZwithString:htmlString];

        if(_isReload == NO){
            //更新高度
            if ([self.delegate respondsToSelector:@selector(updataStoryCellHeight:index:)]) {
                [self.delegate updataStoryCellHeight:htmlString index:_index];
            }
            _isReload = YES;
            [self.storyContent setText:htmlString];
        }
        
    }else{
        NSLog(@"error:%@",error);
    }
}

-(void)setIndex:(NSUInteger)index{
    _index = index;
}
//取消多余字符
- (NSString *)getZZwithString:(NSString *)string{
    
    NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0 error:nil];
    
    string = [regularExpretion stringByReplacingMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) withTemplate:@""];
    
    return string;
}

-(void)setModel:(ZZTStoryModel *)model{
    _model = model;
    if([[NSString stringWithFormat:@"%@",[model.content class]] isEqualToString:@"__NSCFString"]){
        [self.storyContent setText:model.content];
    }else{
        [self.storyContent setText:model.content];
    }
    
}
@end
