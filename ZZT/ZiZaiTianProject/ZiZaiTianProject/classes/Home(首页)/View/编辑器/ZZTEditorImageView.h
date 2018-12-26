//
//  ZZTEditorImageView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/26.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTEditorBasisView.h"

//定义枚举类型
typedef enum ZZTEditorImageViewType {
    editorImageViewTypeChat  = 0,

} Editor_ImageViewType;

@class ZZTEditorImageView;

@protocol ZZTEditorImageViewDelegate <NSObject>

@optional

- (void)sendCurrentViewToDeskView:(ZZTEditorImageView *)imageView;

@end

@class ZZTEditorBasisView;

@interface ZZTEditorImageView : ZZTEditorBasisView

//设置数据
@property (nonatomic,strong) NSString *imageUrl;

@property (nonatomic,assign) Editor_ImageViewType type;

@property(nonatomic,weak)id<ZZTEditorImageViewDelegate>   imageViewDelegate;

@end
