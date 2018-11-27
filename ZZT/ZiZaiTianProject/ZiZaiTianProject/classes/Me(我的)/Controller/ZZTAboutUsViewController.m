//
//  ZZTAboutUsViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAboutUsViewController.h"

@interface ZZTAboutUsViewController ()

@end

@implementation ZZTAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self addBackBtn];
    
    [self.viewNavBar.centerButton setTitle:@"关于我们" forState:UIControlStateNormal];
    
    [self setMeNavBarStyle];

    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImage:[UIImage imageNamed:@"Me_aboutUsImage"]];
    [self.view addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.bottom.equalTo(self.view);
    }];
    
    [self.view bringSubviewToFront:self.viewNavBar];
}



@end
