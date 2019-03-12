//
//  UITextView+tintColor.m
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/16.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import "UITextView+tintColor.h"

@implementation UITextView (tintColor)


//- (void)awakeFromNib
//{
//    //    UILabel *placeHolderLabel = [self valueForKey:@"_placeholderLabel"];
//    //    placeHolderLabel.textColor = [UIColor redColor];
//
//    //通过 kvc 赋值
//    //    [self setValue:[UIColor orangeColor] forKeyPath:@"_placeholderLabel.textColor"];
//    //设置光标颜色和文字颜色一致
//
//    self.tintColor = self.textColor;
//    [self resignFirstResponder];
//
//}
//
////文本框成为第一响应者 和放弃 时 设置文本框的 占位符的颜色
//- (BOOL)becomeFirstResponder
//{
//    [super becomeFirstResponder];
//    self.tintColor = ZZTSubColor;
//    return [super becomeFirstResponder];
//}
////
//- (BOOL)resignFirstResponder
//{
//    [super resignFirstResponder];
//    self.tintColor = ZZTSubColor;
//
//    return [super resignFirstResponder];
//}
@end
