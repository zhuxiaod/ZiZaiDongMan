//
//  ZXDLoginRegisterView.m
//  loginDemo
//
//  Created by zxd on 2018/6/22.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "ZXDLoginRegisterView.h"
#import "ZXDLoginRegisterTextField.h"
#import "ZXDLoginRegisterTextField.h"
@interface ZXDLoginRegisterView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginRegisterButton;

@property (weak, nonatomic) IBOutlet UIButton *verificationButton;

@property (weak, nonatomic) IBOutlet ZXDLoginRegisterTextField *phoneNumber1;

@property (weak, nonatomic) IBOutlet ZXDLoginRegisterTextField *phoneNumber2;

@property (weak, nonatomic) IBOutlet ZXDLoginRegisterTextField *verificationFild;
@property (weak, nonatomic) IBOutlet UIButton *verificationBtn;

@end

@implementation ZXDLoginRegisterView

+(instancetype)loginView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self)  owner:nil options:nil] firstObject];
}
//登录注册
- (IBAction)clickRegister:(id)sender {
    // 判断下这个block在控制其中有没有被实现
    if (self.LogBtnClick) {
        // 调用block传入参数
        self.LogBtnClick(sender);
    }
}

//验证码
- (IBAction)getVerification:(UIButton *)sender {
    if (self.buttonAction) {
        // 调用block传入参数
        self.buttonAction(sender);
    }
}

+(instancetype)registerView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self)  owner:nil options:nil] lastObject];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    //获得当前button的图片
    UIImage *image = _loginRegisterButton.currentBackgroundImage;
    
    //可拉伸的宽度
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    // 让按钮背景图片不要被拉伸
    [_loginRegisterButton setBackgroundImage:image forState:UIControlStateNormal];
    
    //tag
    _verificationButton.tag = 0;
    _loginRegisterButton.tag = 1;
    
    self.phoneNumber1.delegate = self;
    self.phoneNumber1.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumber = _phoneNumber1;
    _verification = _verificationFild;
    
    self.verificationBtn.layer.borderWidth = 1.0f;
    self.verificationBtn.layer.borderColor = [UIColor colorWithRGB:@"215,216,217"].CGColor;
    self.verificationBtn.layer.cornerRadius = 10;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //传值出去
    NSUInteger lengthOfString = string.length;  //lengthOfString的值始终为1
    
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {
        
        unichar character = [string characterAtIndex:loopIndex]; //将输入的值转化为ASCII值（即内部索引值），可以参考ASCII表
        
        // 48-57;{0,9};65-90;{A..Z};97-122:{a..z}
        
        if (character < 48) return NO; // 48 unichar for 0
        
        if (character > 57 && character < 65) return NO; //
        
        if (character > 90 && character < 122) return NO;
        
        if (character > 122) return NO;
        
        
    }
    
    // Check for total length
    
    NSUInteger proposedNewLength = textField.text.length - range.length + string.length;
    
    if (proposedNewLength > 11) {
        
        return NO;//限制长度
        
    }
    
    return YES;
}
@end
