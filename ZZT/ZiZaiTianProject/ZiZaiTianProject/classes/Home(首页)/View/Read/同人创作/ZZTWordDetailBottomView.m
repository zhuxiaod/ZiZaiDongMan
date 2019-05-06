//
//  ZZTWordDetailBottomView.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/16.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTWordDetailBottomView.h"
#import "ZZTChapterlistModel.h"

@interface ZZTWordDetailBottomView ()

@property (nonatomic,strong) UIButton *readBtn;

@property (nonatomic,strong) UIButton *multiBtn;

@property (nonatomic,strong) UIButton *originalBtn;

@property (nonatomic,strong) UIView *leftView;

@property (nonatomic,strong) UIButton *selectBtn;


@end

@implementation ZZTWordDetailBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //左边View
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3 * 2, 70)];
    [leftView setBackgroundColor:[UIColor colorWithHexString:@"#D6D6D6" alpha:0.74]];
    _leftView = leftView;
    [self addSubview:leftView];
    
    //这里判断什么显示什么View
//    同人还是独创
    //都创建 然后在后面再看怎么显示
    UIButton *multiBtn = [self creatButtonWithImg:@"readedBtnImg" selImg:@"readedBtnImg_selected" title:@"同人 - 用户名"];
    _multiBtn = multiBtn;
    _multiBtn.tag = 2;
    _multiBtn.selected = YES;
    _selectBtn = _multiBtn;
    [multiBtn addTarget:self action:@selector(selectVersion:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:multiBtn];
    
    UIButton *originalBtn = [self creatButtonWithImg:@"readedBtnImg" selImg:@"readedBtnImg_selected" title:@"原版 - 第一话"];
    _originalBtn.tag = 1;
    _originalBtn = originalBtn;
    [originalBtn addTarget:self action:@selector(selectVersion:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:originalBtn];
    
    //右边View
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3 * 2, 0, SCREEN_WIDTH/3, leftView.height)];
    [self addSubview:rightView];
    
    UIButton *readBtn = [GlobalUI createButtonWithImg:nil title:@"开始阅读" titleColor:[UIColor whiteColor]];
    readBtn.backgroundColor = ZZTSubColor;
    readBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/3, rightView.height);
    _readBtn = readBtn;
    [readBtn addTarget:self action:@selector(readBtnTarget:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:readBtn];
    
}

-(UIButton *)creatButtonWithImg:(NSString *)img selImg:(NSString *)selImg title:(NSString *)title{
    UIButton *button = [GlobalUI createButtonWithImg:[UIImage imageNamed:img] title:title titleColor:[UIColor blackColor]];
    [button setImage:[UIImage imageNamed:selImg] forState:UIControlStateSelected];
    [button setTitleColor:ZZTSubColor forState:UIControlStateSelected];
    //让图片离文字远一点
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    button.adjustsImageWhenHighlighted = NO;
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button sizeToFit];
    return button;
}

- (void)setCartoonType:(NSString *)cartoonType{
    _cartoonType = cartoonType;

}

-(void)setupButtonLayout{
    //    如果是1 显示原版
    if([_cartoonType isEqualToString:@"1"] || self.lastMultiReadData == nil){
        _originalBtn.frame = CGRectMake(10, self.height / 2 - _originalBtn.height/2, [self getButtonWidth:_originalBtn] +10 , _originalBtn.height);
        _multiBtn.hidden = YES;
    }else{
        _multiBtn.hidden = NO;
        _multiBtn.frame = CGRectMake(10, self.height / 2 - _multiBtn.height - 4, [self getButtonWidth:_multiBtn] +10 ,  _multiBtn.height);
        _originalBtn.frame = CGRectMake(10, self.height / 2 + 4, [self getButtonWidth:_originalBtn] +10,  _originalBtn.height);
    }
    if(_lastReadData != nil || _lastMultiReadData != nil){
        [_readBtn setTitle:@"继续阅读" forState:UIControlStateNormal];
    }
}
//设置btn数据

//获取合适宽度
-(CGFloat)getButtonWidth:(UIButton *)btn{
    NSLog(@"btnW:%f _leftView:%f",btn.width,_leftView.width - 40);
    if(btn.width >= _leftView.width - 40){
        return _leftView.width - 40;
    }else{
        return btn.width;
    }
}

//下午  设置选中状态  开始阅读状态   同人 原版选择  开始阅读不同事件触发
//开始阅读事件
-(void)readBtnTarget:(UIButton *)btn
{
    //如果是开始阅读
    //打开原文第一章 就行了
    if([btn.titleLabel.text isEqualToString:@"开始阅读"]){
        if(self.startRead)self.startRead();
    }else{
        //继续阅读
        //如果是1  阅读同人
        //如果是2  阅读原版
        if(_selectBtn.tag == 2){
            //同人
            self.lastMultiReadBook();
        }else{
            //原版
            self.lastReadBook();
        }
    }
    //如果是继续阅读
    //查看当前选择的是哪一个
    //传一个数据过去玩
}

//选择版本
-(void)selectVersion:(UIButton *)btn{
    //改变按钮的状态
    _selectBtn.selected = !_selectBtn.selected;
    btn.selected = !btn.selected;
    _selectBtn = btn;
}

//设置样式
-(void)setLastReadData:(ZZTChapterlistModel *)lastReadData{
    _lastReadData = lastReadData;
    NSString *title = lastReadData == nil?@"原版-第01话":[NSString stringWithFormat:@"原版-第%@",lastReadData.chapterName];
    [_originalBtn setTitle:title forState:UIControlStateNormal];
    [_originalBtn sizeToFit];
}

//设置样式
-(void)setLastMultiReadData:(ZZTChapterlistModel *)lastMultiReadData{
    _lastMultiReadData = lastMultiReadData;
    //如果不为nil
    [_multiBtn setTitle:[NSString stringWithFormat:@"同人-%@(%@画)",lastMultiReadData.nickName,lastMultiReadData.chapterPage] forState:UIControlStateNormal];
    [_multiBtn sizeToFit];

    [self setupButtonLayout];
}
@end
