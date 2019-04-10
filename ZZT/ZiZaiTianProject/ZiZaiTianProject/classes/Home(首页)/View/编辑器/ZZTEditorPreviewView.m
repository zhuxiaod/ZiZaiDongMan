//
//  ZZTEditorPreviewView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/23.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "ZZTEditorPreviewView.h"
#import "ZZTCartoonContentCell.h"

@interface ZZTEditorPreviewView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *backBtn;

@end

NSString *ZZTEditorPreviewViewIDF = @"ZZTEditorPreviewViewIDF";

@implementation ZZTEditorPreviewView

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //添加UI
        [self setupUI];
    }
    return self;
}

-(void)setImgArray:(NSArray *)imgArray{
    _imgArray = imgArray;
    [_tableView reloadData];
}

-(void)setupUI{
    //tableView
    _tableView= [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.contentInset = UIEdgeInsetsMake(-20 ,0,0,0);
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [UIView new];
    [_tableView registerClass:[ZZTCartoonContentCell class] forCellReuseIdentifier:ZZTEditorPreviewViewIDF];
    _tableView.showsVerticalScrollIndicator = YES;
    [self addSubview:_tableView];
    [self myViewController].automaticallyAdjustsScrollViewInsets = NO;
    
    //返回按钮
    UIButton *backBtn = [GlobalUI createButtonWithImg:[UIImage imageNamed:@"返回"] title:nil titleColor:nil];
    _backBtn = backBtn;
    [self addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)removeView{
    [self removeFromSuperview];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(14);
        make.height.mas_equalTo(ZZTLayoutDistance(72));
        make.width.mas_equalTo(ZZTLayoutDistance(72));
    }];

}

//搜索结果多少节
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imgArray.count;
}

//每行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //数据源
    ZZTCartoonContentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZZTEditorPreviewViewIDF];
    UIImage *image = _imgArray[indexPath.row];
    cell.cartoonImg = image;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SCREEN_HEIGHT;
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    
    CGRect rectInTableView = [_tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0]];
    
    [self.tableView setContentOffset:CGPointMake(0 , rectInTableView.origin.y+20) animated:NO];
    
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//    [self.tableView setContentMode:uic];

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *airView = [[UIView alloc] init];
    return airView;
}
@end
