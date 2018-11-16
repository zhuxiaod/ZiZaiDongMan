//
//  GGVerifyCodeViewBtn.m
//  GGGetValidationCode
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 RenZhengYang. All rights reserved.
//

#import "GGVerifyCodeViewBtn.h"

@interface GGVerifyCodeViewBtn ()
/*
 * 定时器
 */
@property(strong,nonatomic) NSTimer *timer;

/*
 * 定时多少秒
 */
@property(assign,nonatomic) NSInteger count;

@end


@implementation GGVerifyCodeViewBtn


#pragma mark - 初始化控件
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // 配置
        [self setup];
        
    }

    return self;
}

#pragma mark - 配置


- (void)setup
{
    
   [self setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:10.f];
    self.backgroundColor = [UIColor whiteColor];
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.layer setBorderWidth:2];
    
    self.layer.cornerRadius = 8.0f;
    self.layer.masksToBounds = YES;
    
}
#pragma mark - 添加定时器
- (void)timeFailBeginFrom:(NSInteger)timeCount
{
    self.count = timeCount;
    
    self.enabled = NO;
    
    // 加1个定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeDown) userInfo: nil repeats:YES];
    
    
}

#pragma mark - 定时器事件
- (void)timeDown
{
    if (self.count != 1){
        
        self.count -= 1;
        
        self.enabled = NO;
        
        [self setTitle:[NSString stringWithFormat:@"剩余%ld秒", self.count] forState:UIControlStateNormal];
    
    } else {
    
        self.enabled = YES;
        
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        [self.timer invalidate];
    }
    
}



@end
