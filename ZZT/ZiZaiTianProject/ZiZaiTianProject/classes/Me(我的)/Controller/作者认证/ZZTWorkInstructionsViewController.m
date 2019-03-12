//
//  ZZTWorkInstructionsViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/18.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTWorkInstructionsViewController.h"

@interface ZZTWorkInstructionsViewController ()

@end

@implementation ZZTWorkInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.viewNavBar.centerButton setTitle:@"投稿须知" forState:UIControlStateNormal];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SubmitContentImg"]];
    imageView.frame = CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:imageView];
    
    [self setMeNavBarStyle];
    
    [self.viewNavBar bringSubviewToFront:self.view];
    
    [self.view bringSubviewToFront:self.viewNavBar];
    
}



@end
