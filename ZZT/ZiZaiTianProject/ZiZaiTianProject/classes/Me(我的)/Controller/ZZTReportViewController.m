//
//  ZZTReportViewController.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/3.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTReportViewController.h"
#import "ZZTMyZoneModel.h"
#import "ZZTCircleModel.h"
#import "customer.h"

@interface ZZTReportViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *reportMessageView;

@property (weak, nonatomic) IBOutlet UILabel *reportMessage;

@property (weak, nonatomic) IBOutlet UIView *reportReasonView;

@property (weak, nonatomic) IBOutlet UITextView *reportReason;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic,assign) NSInteger nowBtnTag;

@property (nonatomic,strong) NSMutableAttributedString *reportStr;


@end

@implementation ZZTReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.reportReason.delegate = self;
    
    [self.viewNavBar.centerButton setTitle:@"举报" forState:UIControlStateNormal];
    
    [self setMeNavBarStyle];
    
    _reportReason.text = @"请详细的描述举报理由";
    _reportReason.textColor = [UIColor lightGrayColor];

    //设置样式
    self.reportMessageView.layer.cornerRadius = 10.0;
    
    self.reportReasonView.layer.borderColor = [UIColor colorWithRGB:@"240,240,240"].CGColor;
    
    self.reportReasonView.layer.borderWidth = 1.0f;
    
    self.reportReasonView.layer.cornerRadius = 10.0;

    if(SCREEN_HEIGHT == 812){
        self.topConstraint.constant = 64;
    }
    
    self.nowBtnTag = 1;
    
    
    self.reportMessage.attributedText = _reportStr;
}

- (IBAction)btnClickTarget:(UIButton *)sender{
    //获取现在被选中的btn 改状态
    UIButton *nowButton = (UIButton *)[self.view viewWithTag:self.nowBtnTag];
    nowButton.selected = !nowButton.selected;
    //然后将现在的btn 改状态
    sender.selected = !sender.selected;
    self.nowBtnTag = sender.tag;
}

- (IBAction)report:(UIButton *)sender {
    [MBProgressHUD showSuccess:@"提交成功"];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    if([textView.text isEqualToString:@"请详细的描述举报理由"]){
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length <= 0 )
    {
        _reportReason.text = @"请详细的描述举报理由";
        textView.textColor = [UIColor lightGrayColor];
    }
}

-(void)setModel:(ZZTReportModel *)model{
    _model = model;
    NSString *reportString = [NSString stringWithFormat:@"@%@:%@",model.name,model.content];
    //数字紫色  zb 黑色 大小不同
    NSMutableAttributedString *attriStr1 = [[NSMutableAttributedString alloc] initWithString:reportString];
    [attriStr1 addAttribute:NSForegroundColorAttributeName value:ZZTSubColor range:NSMakeRange(0, model.name.length + 2)];
    _reportStr = attriStr1;
}



@end
