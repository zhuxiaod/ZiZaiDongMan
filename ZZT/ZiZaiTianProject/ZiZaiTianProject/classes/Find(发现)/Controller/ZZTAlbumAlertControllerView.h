//
//  ZZTAlbumAlertControllerView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/1/7.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZTAlbumAlertControllerViewDelegate <NSObject>

@optional

- (void)albumAlertControllerViewWithImg:(UIImage *)image;

@end





@interface ZZTAlbumAlertControllerView : UIAlertController

@property(nonatomic,weak)id <ZZTAlbumAlertControllerViewDelegate>   delegate;

- (void)showZCAlert;

+ (instancetype)initAlbumAlertControllerViewWithAlertAction:(void (^)(NSInteger index))alertAction;


- (void)takePhoto;

- (void)pushTZImagePickerController;


@end
