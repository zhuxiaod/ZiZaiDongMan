//
//  ZZTCommentOpenCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTCommentOpenCell.h"

@interface ZZTCommentOpenCell ()

@property (nonatomic,strong)UIButton *openBtn;

@end

@implementation ZZTCommentOpenCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //背景
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-SectionHeaderHorizontalSpace);
        make.left.equalTo(@(36 + SectionHeaderHorizontalSpace * 2));
    }];
    
    //设置一个按钮
    UIButton *openBtn = [[UIButton alloc] init];
    [openBtn setTitle:@"是否打开" forState:UIControlStateNormal];
    
    _openBtn = openBtn;
    //颜色
    UIColor *linkColor = [UIColor colorWithRGB:@"54,71,121"];
    [openBtn setTitleColor:linkColor forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(openReply) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:openBtn];
    openBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    openBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    openBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView);
        make.left.equalTo(@(64));
        make.right.equalTo(self.contentView).offset(-SectionHeaderHorizontalSpace);
        make.bottom.equalTo(self.contentView);
    }];
}

-(void)setCellNum:(NSInteger)cellNum{
    _cellNum = cellNum;
    [_openBtn setTitle:[NSString stringWithFormat:@"共%ld条回复 ＞",cellNum] forState:UIControlStateNormal];
}

-(void)openReply{
    if(_openBtnBlock){
        self.openBtnBlock();
    }
}

@end
