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

    [self reportUserData];
}


-(void)reportUserData{
    ZZTAlertController *alertC = [ZZTAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertC addDestructiveAction:@"举报" handler:^{
        [self gotoReportVCWithModel];

    }];
    
    [alertC addDefaultAction:@"屏蔽" handler:^{
        if(self.reportblock){
            self.reportblock(self.model);
        }
    }];
    
    [alertC addCancelAction:@"取消" handler:^{
        
    }];
    
    [[self myViewController] presentViewController:alertC animated:YES completion:nil];
}

-(void)gotoReportVCWithModel{
    ZZTReportViewController *reportVC = [[ZZTReportViewController alloc] init];
    reportVC.model = _model;
    [[self myViewController].navigationController pushViewController:reportVC animated:YES];
}
@end
