
//
//  UIImage+Extension.m
//  kuaikanCartoon
//
//  Created by dengchen on 16/4/30.
//  Copyright © 2016年 name. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

- (UIImage *)clipEllipseImage{
    
    UIGraphicsBeginImageContext(self.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat size = MAX(self.size.width, self.size.height);
    CGRect rect  = CGRectMake(0, 0, size, size);

    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [self drawInRect:rect];
    
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newimg;
}

+(UIImage *)cropSquareImage:(UIImage *)image{
    CGImageRef sourceImageRef = [image CGImage];
    //将UIImage转换成CGImageRef
    NSInteger left = 30;
    NSInteger widthHeight = SCREEN_WIDTH - 2 * left;
    NSInteger top = (SCREEN_WIDTH  - widthHeight) / 2;
    CGRect cropRect = CGRectMake(0, top - 64, SCREEN_WIDTH, Screen_Height * 0.36);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
    //按照给定的矩形区域进行剪裁
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

@end
