//
//  ZZTEditorBrightnessView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTEditorImageView;

static CGFloat BrightnessToolBarHeight = 160.0f;

@protocol ZZTEditorBrightnessView <NSObject>

- (void)brightnessChangeWithTag:(NSInteger)tag Value:(CGFloat)value;

@end

@interface ZZTEditorBrightnessView : UIView

@property (nonatomic,strong) UISlider *brightnessSlider;

@property (nonatomic,strong) UISlider *saturationSlider;

@property (nonatomic,strong) UISlider *contrastSlider;

@property (nonatomic,strong) UISlider *hueSlider;

@property (nonatomic,strong) UISlider *alphaSlider;

@property (nonatomic,weak) id<ZZTEditorBrightnessView> delegate;

@property (nonatomic,weak) ZZTEditorImageView *imageViewModel;

@end
