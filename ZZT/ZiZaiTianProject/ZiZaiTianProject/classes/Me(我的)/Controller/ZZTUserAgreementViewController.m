//
//  ZZTUserAgreementViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/19.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZZTUserAgreementViewController.h"

@interface ZZTUserAgreementViewController ()

@end

@implementation ZZTUserAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    self.navigationController.title = @"用户协议";
    
//    [self addBackBtn];
    
    [self.viewNavBar.centerButton setTitle:@"用户协议" forState:UIControlStateNormal];
    
    [self setMeNavBarStyle];

    //设置TextView
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, navHeight, SCREEN_WIDTH, SCREEN_HEIGHT)];
    textView.editable = NO;
    textView.font = [UIFont fontWithName:@"Arial" size:18.0];
    textView.textColor = [UIColor blackColor];
    [self.view addSubview:textView];
    //读取文本
    NSString *path = [[NSBundle mainBundle] pathForResource:@"userAgreement" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //间距
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 10;
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    NSNumber *kern=[NSNumber numberWithFloat:1.5];

    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    [attributes setObject:kern forKey:NSKernAttributeName];
    textView.attributedText = [[NSAttributedString alloc] initWithString:content attributes:attributes];
}
@end
