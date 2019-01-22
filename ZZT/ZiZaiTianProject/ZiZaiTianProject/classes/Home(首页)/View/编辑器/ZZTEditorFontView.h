//
//  ZZTEditorFontView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/10.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZTEditorFontViewDelegate <NSObject>

@optional

-(void)editorFontViewSliderTarget:(UISlider *)slider;

-(void)editorFontViewColorTarget:(NSString *)colorStr;

@end

@interface ZZTEditorFontView : UIView

@property(nonatomic,weak)id<ZZTEditorFontViewDelegate>   delegate;

@property (nonatomic,assign) CGFloat fontValue;

@property (nonatomic,strong) NSString *currentView;


@end
