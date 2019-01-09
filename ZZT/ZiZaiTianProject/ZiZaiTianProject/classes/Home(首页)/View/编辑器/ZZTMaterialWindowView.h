//
//  ZZTMaterialWindowView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZTDetailModel.h"

@class ZZTDetailModel;

typedef void (^favoritesBtnBlock)(void);//给block重命名,方便调用

@protocol ZZTMaterialWindowViewDelegate <NSObject>

@optional

- (void)materialTypeView:(UICollectionView *)materialTypeView index:(NSInteger)index;

- (void)materialContentView:(UICollectionView *)materialContentView materialModel:(ZZTDetailModel *)model kindIndex:(NSInteger)index;

@end


@interface ZZTMaterialWindowView : UIView

@property (nonatomic,strong)UIButton *collectViewBtn;

@property (nonatomic,strong)UIButton *cameraBtn;

@property (nonatomic,strong)UIButton *favoritesBtn;

@property (nonatomic,strong)NSArray *materialArray;

@property (nonatomic, copy) favoritesBtnBlock favoritesBlock;//声明一个block属性

@property(nonatomic,weak)id<ZZTMaterialWindowViewDelegate>   delegate;



@end
