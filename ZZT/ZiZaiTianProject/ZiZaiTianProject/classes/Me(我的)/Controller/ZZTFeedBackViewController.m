//
//  ZZTFeedBackViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/21.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTFeedBackViewController.h"

@interface ZZTFeedBackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *problemStatementLab;
@property (weak, nonatomic) IBOutlet UILabel *contactLab;

@property (weak, nonatomic) IBOutlet UITextView *problemStatementTextView;
@property (weak, nonatomic) IBOutlet UITextView *contactTextView;

@property (nonatomic,assign) NSInteger nowBtnTag;

@end

//第一个btn 被选中 记录
//点击btn 设置为
@implementation ZZTFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self addBackBtn];
    
    [self.viewNavBar.centerButton setTitle:@"问题反馈" forState:UIControlStateNormal];
    
    [self setMeNavBarStyle];

    
    self.problemStatementTextView.delegate = self;
    self.contactTextView.delegate = self;
    //如果联系方式开始写字  那么lab 透明度为0
    
    self.problemStatementTextView.font = [UIFont systemFontOfSize:17];
    self.contactTextView.font = [UIFont systemFontOfSize:17];
    
    self.nowBtnTag = 1;
}
//提交问题
- (IBAction)SubmitQuestions:(UIButton *)sender {
    //显示提交成功
    [MBProgressHUD showMessage:@"正在提交" toView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showSuccess:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (IBAction)btnClickTarget:(UIButton *)sender {
    //获取现在被选中的btn 改状态
    UIButton *nowButton = (UIButton *)[self.view viewWithTag:self.nowBtnTag];
    nowButton.selected = !nowButton.selected;
    //然后将现在的btn 改状态
    sender.selected = !sender.selected;
    self.nowBtnTag = sender.tag;
}


- (void)textViewDidChange:(UITextView *)textView
{
    if(textView == _problemStatementTextView){
        if (textView.text.length == 0 )
        {
            _problemStatementLab.text = @"更详细的描述问题,能让我们更快的为您解决问题。";
        }
        else
        {
            _problemStatementLab.text = @"";
        }
    }else{
        if (textView.text.length == 0 )
        {
            _contactLab.text = @"便于我们联系您(QQ/微信/邮箱)";
        }
        else
        {
            _contactLab.text = @"";
        }
    }
}



@end
