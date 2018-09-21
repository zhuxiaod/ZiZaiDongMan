//
//  ZZTMyZoneCell.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/20.
//  Copyright © 2018年 zxd. All rights reserved.
//
#define imgHeight  (CGRectGetWidth([UIScreen mainScreen].bounds) - 80)/3

#import "ZZTMyZoneCell.h"
#import "ZZTMyZoneModel.h"
#import <XHImageViewer.h>

@interface ZZTMyZoneCell ()

@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UILabel *contentLab;
@property (nonatomic,strong) UIView  *bgImgsView; // 9张图片bgView
@property (nonatomic,strong) NSMutableArray * groupImgArr;
@property (nonatomic,strong) NSArray *imgArray;
@property (nonatomic,strong) UIView *bottomView;

@end

@implementation ZZTMyZoneCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    //时间lab
    _dateLab = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    //内容lab
    _contentLab = [GlobalUI createLabelFont:14 titleColor:[UIColor blackColor] bgColor:[UIColor whiteColor]];
    //多图
    _bgImgsView = [[UIView alloc]init];
    
    [self.contentView addSubview:_dateLab];
    [self.contentView addSubview:_contentLab];
    [self.contentView addSubview:_bgImgsView];
    _groupImgArr = [NSMutableArray array];
    //分割线
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:_bottomView];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    _dateLab.frame = CGRectMake(10, 10, 100, 50);
    
    CGFloat contentHeight = [_contentLab.text heightWithWidth:CGRectGetWidth(self.contentView.bounds) - 40 font:14];
    _contentLab.frame = CGRectMake(10, CGRectGetMaxY(_dateLab.frame) + 10, CGRectGetWidth(self.contentView.bounds) - 20, contentHeight);
    
    NSInteger row = _imgArray.count / 3;// 多少行图片
    //还有多的 就最加一行  未做  9个以上的话加号
    if (_imgArray.count %3 !=0) {
        ++row;
    }
    
    // 是否有图片，如果有图片  高度= 图片的总高度 + 中间的间距 ，如果没有 ，高度=0
    CGFloat bgH = _imgArray.count ? row * imgHeight + (row-1) * 10 :0;
    _bgImgsView.frame = CGRectMake(10, CGRectGetMaxY(_contentLab.frame) + 10, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, bgH);
    //分割线
    _bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contentView.frame), SCREEN_WIDTH, 1);
}


- (void)setModel:(ZZTMyZoneModel *)model{
    if (_groupImgArr.count) {
        [_groupImgArr enumerateObjectsUsingBlock:^(UIImageView * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        [_groupImgArr removeAllObjects];
    }
    _imgArray = [model.contentImg componentsSeparatedByString:@","];
    
    if (_imgArray.count) {
        //拼接字符串
        NSMutableArray *urlArray = [NSMutableArray array];
        for(int i = 0; i < _imgArray.count;i++){
            NSString *imgUrl = [NSString stringWithFormat:@"%@%@",model.qiniu,_imgArray[i]];
            [urlArray addObject:imgUrl];
        }
        _imgArray = urlArray;
        [self setupImageGroupView];
    }

    _contentLab.text = model.content;
    
    //时间戳显示
    NSString *time = [NSString timeWithStr:[NSString stringWithFormat:@"%f",model.publishtime]];
    NSArray *times = [time componentsSeparatedByString:@"-"];
    time = [NSString stringWithFormat:@"%@%@月",times[2],times[1]];
    _dateLab.attributedText = [self getPriceAttribute:time];;

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

//年月混排
-(NSMutableAttributedString *)getPriceAttribute:(NSString *)string{
    NSMutableAttributedString *attribut = [[NSMutableAttributedString alloc]initWithString:string];
    //目的是想改变 ‘/’前面的字体的属性，所以找到目标的range
    NSRange pointRange = NSMakeRange(0, 2);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSFontAttributeName] = [UIFont systemFontOfSize:30];
    dic[NSKernAttributeName] = @2;
    //赋值
    [attribut addAttributes:dic range:pointRange];
    return attribut;
}

- (void)setupImageGroupView{
    CGFloat w = imgHeight;
    CGFloat h = imgHeight;
    
    CGFloat edge = 10;
    for (int i = 0; i<_imgArray.count; i++) {
        
        int row = i / 3;
        int loc = i % 3;
        CGFloat x = (edge + w) * loc ;
        CGFloat y = (edge + h) * row;
        
        UIImageView * img =[[UIImageView alloc]init];
        [img sd_setImageWithURL:[NSURL URLWithString:_imgArray[i]]];
//        img.image = [UIImage imageNamed:_imgArray[i]];
        img.backgroundColor = [UIColor greenColor];
        img.frame = CGRectMake(x, y, w, h);
        img.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(browerImage:)];
        [img addGestureRecognizer:tap];
        [_bgImgsView addSubview:img];
        [_groupImgArr addObject:img];
    }
}

#pragma mark - brower image
- (void)browerImage:(UITapGestureRecognizer *)gest{
    UIImageView *tapView = (UIImageView *)gest.view;
    XHImageViewer *brower  = [[XHImageViewer alloc]init];
    [brower showWithImageViews:_groupImgArr selectedView:tapView];
}

//高度有问题
//时间显示过大了
+ (CGFloat)cellHeightWithStr:(NSString *)str imgs:(NSArray *)imgs{
    CGFloat strH = [str heightWithWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - 40 font:14];
    CGFloat cellH = strH + 160;
    NSInteger row = imgs.count / 3;
    if (imgs.count) {
        if ( imgs.count % 3 !=0) {
            row += 1;
        }
        cellH +=  row * imgHeight  + (row-1) * 10; // 图片高度 + 间隙
    }
    return  cellH;
}

+ (ZZTMyZoneCell *)dynamicCellWithTable:(UITableView *)table{
    ZZTMyZoneCell * cell = [table dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    if (!cell) {
        cell = [[ZZTMyZoneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
