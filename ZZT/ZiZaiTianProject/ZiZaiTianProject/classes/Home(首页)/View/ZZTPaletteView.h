//
//  ZZTPaletteView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/31.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTPaletteView;
@class Palette;
@protocol PaletteViewDelegate<NSObject>

-(void)patetteView:(ZZTPaletteView *)patetteView patette:(Palette *)palette choiceColor:(UIColor *)color colorPoint:(CGPoint)colorPoint brightness:(CGFloat)brightness alpha:(CGFloat)alpha;


@optional

@end

typedef void (^TureBtnBlock)(UIButton *sender);

@interface ZZTPaletteView : UIView

@property (nonatomic,strong) TureBtnBlock buttonAction;

@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,weak) id<PaletteViewDelegate> delegate;

@end
