//
//  ZZTEditorDeskView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTEditorBasisView;

@interface ZZTEditorDeskView : UIView

@property (nonatomic,strong) ZZTEditorBasisView *currentView;

-(void)Editor_addSubView:(UIView *)view;

-(void)Editor_moveCurrentImageViewToLastLayer;

-(void)Editor_moveCurrentImageViewToNextLayer;

-(void)Editor_removeAllView;

@end
