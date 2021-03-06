//
//  ViewController.m
//  XDFriendShare
//
//  Created by 郎学东 on 2017/12/1.
//  Copyright © 2017年 郎学东. All rights reserved.
//

#import "GlobalUI.h"
#import "NSString+Extension.h"

@implementation GlobalUI

+ (UIImageView *)createImageViewbgColor:(UIColor *)bgColor {
    UIImageView * img = [[UIImageView alloc] init];
    img.backgroundColor = bgColor;
    return img;
}

+ (UILabel *)createLabelFont:(CGFloat )fontsize titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor{
    UILabel * lab = [[UILabel alloc]init];
    lab.font = [UIFont systemFontOfSize:fontsize];
    lab.textColor = titleColor;
    lab.backgroundColor = bgColor;
    return  lab;
}
+ (UIButton *)createButtonWithImg:(UIImage *)img title:(NSString *)title titleColor:(UIColor *)titleColor{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn  setTitleColor:titleColor forState:UIControlStateNormal];
    return  btn;
}

+ (UIButton *)createButtonWithTopImg:(UIImage *)img title:(NSString *)title titleColor:(UIColor *)titleColor{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:img forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setTitleEdgeInsets:
     UIEdgeInsetsMake(btn.frame.size.height/2,
                      (btn.frame.size.width-btn.titleLabel.intrinsicContentSize.width)/2-btn.imageView.frame.size.width,
                      0,
                      (btn.frame.size.width-btn.titleLabel.intrinsicContentSize.width)/2)];
    [btn setImageEdgeInsets:
     UIEdgeInsetsMake(
                      0,
                      (btn.frame.size.width-btn.imageView.frame.size.width)/2,
                      btn.titleLabel.intrinsicContentSize.height,
                      (btn.frame.size.width-btn.imageView.frame.size.width)/2)];
    return  btn;
}

//高度有问题
//时间显示过大了
+ (CGFloat)cellHeightWithModel:(ZZTMyZoneModel *)model{
    CGFloat strH = [model.content heightWithWidth:CGRectGetWidth([UIScreen mainScreen].bounds) - 24 font:MomentFontSize];
    if([model.content isEqualToString:@""]){
        strH = 0;
    }else{
        strH += 10;
    }
    CGFloat cellH = strH + 120;
    
    CGFloat bgH = 0.0f;
    
    NSArray *array = [model.contentImg componentsSeparatedByString:@","];
    CGFloat high = [model.high floatValue];
    CGFloat wide = [model.wide floatValue];
    
    if(array.count == 1){
        if(wide > high){
            bgH = 120;
        }else{
            CGFloat width = 120;
            bgH = width * high / wide;
        }
        if(wide == 0 && high == 0){
            bgH = 0;
        }
    }else if (array.count == 2){
        bgH = (SCREEN_WIDTH - 24 - 10)/2;
    }else if (array.count == 4){
        bgH = SCREEN_WIDTH - SafetyW - SafetyW;
    }else{
        NSInteger row = array.count / 3;// 多少行图片
        if (array.count % 3 != 0) {
            ++row;
        }
        bgH = array.count ? row * imgHeight + (row - 1) * 10 :0;
    }
    
    if (array.count) {
        cellH += bgH;
    }
    return  cellH - 10;
}

//快速创建btn
+(UIButton *)createButtionWithImg:(NSString *)img selTaget:(SEL)selTaget{
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [Btn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    
    [Btn addTarget:self action:selTaget forControlEvents:UIControlEventTouchUpInside];
    return Btn;
}

-(void)addLineSpacing:(UILabel *)label
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSKernAttributeName : @(1.5f)}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label.text.length)];
    
    [label setAttributedText:attributedString];
    
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
}

+(UIButton *)initButton:(UIButton*)btn{
    float  spacing = 4;//图片和文字的上下间距
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize textSize = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : btn.titleLabel.font}];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    CGFloat totalHeight = (imageSize.height + titleSize.height + spacing);
    btn.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height), 0);
    return btn;
}

+(UITextView *)initTextViewWithBgColor:(UIColor *)BgColor fontSize:(NSInteger)fontSize text:(NSString *)text textColor:(UIColor *)textColor{
    
    UITextView *kTextView = [UITextView new];
    kTextView.backgroundColor = BgColor;
    kTextView.font = [UIFont systemFontOfSize:fontSize];
    kTextView.layer.cornerRadius = 5;
    kTextView.text = text;
    kTextView.textColor = textColor;
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle
                                 };
    kTextView.typingAttributes = attributes;
    kTextView.returnKeyType = UIReturnKeySend;
    return kTextView;
    
}

//naviba的高度
+(CGFloat)getNavibarHeight{
    return Height_NavBar;
}
@end
