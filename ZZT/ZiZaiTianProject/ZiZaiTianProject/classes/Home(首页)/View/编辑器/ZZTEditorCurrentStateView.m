//
//  ZZTEditorCurrentStateView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/21.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorCurrentStateView.h"

@interface ZZTEditorCurrentStateView()


@end

@implementation ZZTEditorCurrentStateView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.userInteractionEnabled = NO;
    //显示删除按钮
    UIButton *deletBtn = [[UIButton alloc] init];
    [deletBtn setImage:[UIImage imageNamed:@"deletMartarel"] forState:UIControlStateNormal];
    deletBtn.userInteractionEnabled = YES;
    [deletBtn addTarget:self action:@selector(deletBtnTarget) forControlEvents:UIControlEventTouchUpInside];
    _deletBtn = deletBtn;
    [self addSubview:deletBtn];
    //与后面的View一起动
}


-(void)deletBtnTarget{
    NSLog(@"321312312321321");
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [_deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.width.height.mas_equalTo(30);
    }];
    NSLog(@"1121321:%f",self.width);
//    _deletBtn.frame = CGRectMake(self.width - 30, 0, 30, 30);
}
@end
