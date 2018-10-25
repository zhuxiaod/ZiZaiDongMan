//
//  GGVerifyCodeViewBtn.h
//  GGGetValidationCode
//
//  Created by mac on 2017/6/11.
//  Copyright © 2017年 RenZhengYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGVerifyCodeViewBtn : UIButton
// 由于有些时间需求不同，特意露出方法，倒计时时间次数
- (void)timeFailBeginFrom:(NSInteger)timeCount;

@end
