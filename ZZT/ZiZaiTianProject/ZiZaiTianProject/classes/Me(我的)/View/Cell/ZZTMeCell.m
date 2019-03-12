//
//  ZZTMeCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTMeCell.h"
@interface ZZTMeCell ()

@property (nonatomic,weak) UIView *bottomView;

@end

@implementation ZZTMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.textColor = [UIColor darkGrayColor];
        [self setupCell];
    }
    return self;
}

-(void)setupCell{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.accessoryType = UITableViewCellAccessoryNone; //显示最右边的箭头
    
    UIView *bottomView = [[UIView alloc] init];
    
    bottomView.backgroundColor = [UIColor colorWithRGB:@"232,232,232"];
    _bottomView = bottomView;
    [self.contentView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.height.mas_equalTo(1);
        make.right.equalTo(self.contentView.mas_right);
        make.left.equalTo(self.contentView.mas_left);
    }];
}

-(void)setCellCount:(NSInteger)cellCount{
    _cellCount = cellCount;
   
}

-(void)setCellIndex:(NSInteger)cellIndex{
    _cellIndex = cellIndex;
    if(cellIndex == (_cellCount - 1)){
        [_bottomView removeFromSuperview];
    }
}
@end
