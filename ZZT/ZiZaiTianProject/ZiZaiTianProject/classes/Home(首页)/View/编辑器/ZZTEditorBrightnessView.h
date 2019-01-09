//
//  ZZTEditorBrightnessView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat BrightnessToolBarHeight = 80.0f;

@protocol ZZTEditorBrightnessView <NSObject>

- (void)brightnessChangeWithTag:(NSInteger)tag Value:(CGFloat)value;

@end

@interface ZZTEditorBrightnessView : UIView

@property (nonatomic,weak) id<ZZTEditorBrightnessView> delegate;

@end
