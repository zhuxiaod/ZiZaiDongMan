//
//  ZZTReportBtn.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/7.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTReportBtn.h"
#import "ZZTCircleModel.h"
#import "ZZTMyZoneModel.h"
#import "ZZTReportModel.h"
@interface ZZTReportBtn ()

@property (nonatomic,strong) ZZTReportModel *model;

@end

@implementation ZZTReportBtn

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //举报
        [self setImage:[[UIImage imageNamed:@"commentReport"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [self addTarget:self action:@selector(cellLongPress:) forControlEvents:UIControlEventTouchUpInside];
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    }
    return self;
}


//设置数据
-(void)setZoneModel:(ZZTMyZoneModel *)zoneModel{
    _zoneModel = zoneModel;
    //名字
    //内容
    //index
    _model = [ZZTReportModel initWithName:zoneModel.nickName Content:zoneModel.content Index:zoneModel.index];
}

-(void)setCircleModel:(ZZTCircleModel *)circleModel{
    _circleModel = circleModel;
    _model = [ZZTReportModel initWithName:circleModel.customer.nickName Content:circleModel.content Index:circleModel.indexRow];

}

-(void)cellLongPress:(UILongPressGestureRecognizer *)gesture{
    //代理出去
//    if(![[NSString stringWithFormat:@"%ld",[Utilities GetNSUserDefaults].id] isEqualToString:self.model.userId]){
//        if(self.LongPressBlock){
//            self.LongPressBlock(self.model);
//        }
//    }
    [self reportUserData];
}

-(void)reportUserData{
    //弹出举报框
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reportBtn = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        [self gotoReportVCWithModel];
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"屏蔽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shieldingMessage:)])
        {
            // 调用代理方法
            [self.delegate shieldingMessage:self.model.index];
        }
        [MBProgressHUD showSuccess:@"屏蔽成功"];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:reportBtn];
    [actionSheet addAction:action];
    [actionSheet addAction:action2];
    
    [[self myViewController] presentViewController:actionSheet animated:YES completion:nil];
    
}

-(void)gotoReportVCWithModel{
    ZZTReportViewController *reportVC = [[ZZTReportViewController alloc] init];
    reportVC.model = self.model;
    [[self myViewController].navigationController pushViewController:reportVC animated:YES];
}
@end
