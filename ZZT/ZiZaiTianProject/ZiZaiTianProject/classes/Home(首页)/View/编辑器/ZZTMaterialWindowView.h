//
//  ZZTMaterialWindowView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/25.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZZTMaterialWindowViewDelegate <NSObject>

@optional

- (void)materialTypeView:(UICollectionView *)materialTypeView index:(NSInteger)index;

- (void)materialContentView:(UICollectionView *)materialContentView index:(NSInteger)index;

@end

@interface ZZTMaterialWindowView : UIView

@property (nonatomic,strong)UIButton *collectViewBtn;

@property (nonatomic,strong)UIButton *cameraBtn;

@property (nonatomic,strong)UIButton *favoritesBtn;

@property(nonatomic,weak)id<ZZTMaterialWindowViewDelegate>   delegate;

@end
