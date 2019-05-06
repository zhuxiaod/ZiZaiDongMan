//
//  ZZTAlertController.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/23.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import "ZZTAlertController.h"

@interface ZZTAlertController ()

@end

@implementation ZZTAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)addDefaultAction:(NSString *)title handler:(void (^)(void))handler{
    UIAlertAction *reportBtn = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    [self addAction:reportBtn];
}

-(void)addDestructiveAction:(NSString *)title handler:(void (^)(void))handler{
    UIAlertAction *reportBtn = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    [self addAction:reportBtn];
}

-(void)addCancelAction:(NSString *)title handler:(void (^)(void))handler{
    UIAlertAction *reportBtn = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    [self addAction:reportBtn];
}


-(void)reportUserData{
    //弹出举报框
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *reportBtn = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
//        [self gotoReportVCWithModel];
        
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"屏蔽" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(shieldingMessage:)])
//        {
//            // 调用代理方法
//            [self.delegate shieldingMessage:self.model.index];
//        }
        [MBProgressHUD showSuccess:@"屏蔽成功"];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:reportBtn];
    [actionSheet addAction:action];
    [actionSheet addAction:action2];
    
}

@end
