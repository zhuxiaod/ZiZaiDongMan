//
//  UIImage+Extension.h
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

- (UIImage *)clipEllipseImage;

+ (UIImage *)cropSquareImage:(UIImage *)image;
//改变图片的透明度
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;

@end
