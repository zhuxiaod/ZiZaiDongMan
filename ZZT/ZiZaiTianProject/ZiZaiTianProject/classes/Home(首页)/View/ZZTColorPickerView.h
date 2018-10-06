//
//  ZZTColorPickerView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/10/6.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTColorPickerView;

@protocol ZZTColorPickerViewDelegate<NSObject>

-(void)colorPickerViewWithColor:(ZZTColorPickerView *)view color:(UIColor *)color;


@end

@interface ZZTColorPickerView : UIView

@property (nonatomic,strong)id<ZZTColorPickerViewDelegate>delegate;

@end
