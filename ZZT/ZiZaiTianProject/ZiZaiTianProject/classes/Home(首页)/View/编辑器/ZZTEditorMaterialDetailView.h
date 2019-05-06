//
//  ZZTEditorMaterialDetailView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/29.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTDetailModel;

@protocol ZZTEditorMaterialDetailViewDelegate <NSObject>

@optional

-(void)sendMaterialDetailWithKindIndex:(NSInteger)index materialImage:(UIImage *)materialImage model:(ZZTDetailModel *)model;

-(void)materialDetailViewRemoveTarget;

@end


@interface ZZTEditorMaterialDetailView : UIView

@property (nonatomic,strong) NSArray *imgArray;

@property (nonatomic,strong) ZZTDetailModel *model;

@property (nonatomic,assign) NSInteger kindIndex;

@property (nonatomic,strong) UIButton *collectViewBtn;

@property (nonatomic,strong) NSString *superId;

@property(nonatomic,weak)id<ZZTEditorMaterialDetailViewDelegate>   delegate;


@end
