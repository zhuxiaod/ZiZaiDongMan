
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


+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
//分享图合成
+ (UIImage *)addImage:(NSString *)imageName1 withImage:(NSString *)imageName2 {
    //分享图
    UIImage *image1 = [UIImage imageNamed:imageName1];
    //轮播图
    NSData *resultData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageName2]];
    
    UIImage *image2 = [UIImage imageWithData:resultData];
    
    UIImage *logoImg = [UIImage imageNamed:@"logoImg"];
    
    CGFloat image1H;
    if(SCREEN_WIDTH == 414){
        image1H = 421;
    }else{
        image1H = 381;
    }
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, image1H), NO, 0);
    
    [image1 drawInRect:CGRectMake(0, 0, SCREEN_WIDTH, image1H)];
    
    //计算轮播图 应该显示多少高度
    CGFloat bannerH = image2.size.height * SCREEN_WIDTH / image2.size.width;
    
    [image2 drawInRect:CGRectMake(0,0, SCREEN_WIDTH, bannerH)];
    
    //logo的大小
    CGRect image2Rect = CGRectMake(0,0, SCREEN_WIDTH, bannerH);
    //添加logo
    [logoImg drawInRect:CGRectMake(CGRectGetMaxX(image2Rect) - 60, CGRectGetMaxY(image2Rect) - 60, 50, 50)];
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultingImage;
}

@end
