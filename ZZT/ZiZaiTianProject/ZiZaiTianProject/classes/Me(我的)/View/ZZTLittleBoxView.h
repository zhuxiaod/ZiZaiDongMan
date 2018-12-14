//
//  ZZTLittleBoxView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/13.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTLittleBoxView;
@protocol ZZTLittleBoxViewDelegate <NSObject>

@optional

- (void)clickLittleBoxView:(ZZTLittleBoxView *)littleBoxView selectState:(NSString *)selectState;

@end

typedef void (^LittleBoxBlock) (BOOL isSelect);

@interface ZZTLittleBoxView : UIView

@property (nonatomic,strong) UIButton *button;

@property (nonatomic,assign) BOOL isSelect;

@property(nonatomic,weak)id<ZZTLittleBoxViewDelegate>  delegate;

@property (nonatomic,copy) LittleBoxBlock LittleBoxBlock;

@end
