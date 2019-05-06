//
//  ZZTContinueToDrawHeadView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/8/23.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTContinueToDrawHeadView.h"
#import "ZZTCartoonModel.h"
#import "ZZTChapterlistModel.h"
#import "ZZTXuHuaUserView.h"

@interface ZZTContinueToDrawHeadView ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UIButton *xuHuaBtn;

@end

@implementation ZZTContinueToDrawHeadView

+(instancetype)ContinueToDrawHeadView{
    return [[[NSBundle mainBundle] loadNibNamed:@"ZZTContinueToDrawHeadView" owner:nil options:nil]lastObject];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [GlobalUI initButton:self.xuHuaBtn];
    
     

}

- (IBAction)creatNewWord:(UIButton *)sender {
    if(self.xuHuaBtnBlock){
        self.xuHuaBtnBlock();
    }
}

-(void)setArray:(NSArray *)array{
    _array = array;
    _xuHuaUserView.dataArray = array;
}

-(void)setBookDetail:(ZZTCarttonDetailModel *)bookDetail{
    _bookDetail = bookDetail;
    _xuHuaUserView.bookDetail = bookDetail;
}
-(void)setLastReadModel:(ZZTJiXuYueDuModel *)lastReadModel{
    _xuHuaUserView.lastReadModel = lastReadModel;
}

-(void)pushMultiCartoonEditorVC:(ZZTChapterlistModel *)model{
    //bookID
    //页码
    ZZTEditorCartoonViewController *ecVC = [[ZZTEditorCartoonViewController alloc] init];
    ecVC.xuHuaModel = model;
    ecVC.hidesBottomBarWhenPushed = YES;
    [[self myViewController].navigationController pushViewController:ecVC animated:YES];
}
@end
