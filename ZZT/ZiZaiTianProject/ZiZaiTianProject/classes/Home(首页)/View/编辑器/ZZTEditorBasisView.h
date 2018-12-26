//
//  ZZTEditorBasisView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTEditorBasisView;

@protocol ZZTEditorBasisViewDelegate <NSObject>

@optional

- (void)setupViewForCurrentView:(ZZTEditorBasisView *)view;

@end

@interface ZZTEditorBasisView : UIView

@property(nonatomic,weak)id<ZZTEditorBasisViewDelegate>   delegate;

@end
