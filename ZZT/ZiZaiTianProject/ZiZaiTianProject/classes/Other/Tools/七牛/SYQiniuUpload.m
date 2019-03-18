//
//  SYQiniuUpload.m
//  YLB
//
//  Created by chenjiangchuan on 16/11/9.
//  Copyright © 2016年 Sayee Intelligent Technology. All rights reserved.
//

#import "SYQiniuUpload.h"

@implementation SYQiniuUpload
//单图上传
+ (NSString *)QiniuPutSingleImage:(NSString *)imagePath complete:(void (^)(QNResponseInfo *info, NSString *key, NSDictionary *resp))complete; {
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    UIImage *newImage = [UIImage imageWithContentsOfFile:imagePath];
    NSData *data = UIImageJPEGRepresentation(newImage, 1.0);

    NSString *keyTime = [self currentTime];
    NSString *keyRandom = [self randomString];
    NSString *keyString = [NSString stringWithFormat:@"%@%@.jpg",keyTime,keyRandom];
    NSLog(@"keyString = %@", keyString);
    
    AFNHttpTool *tool = [[AFNHttpTool alloc] init];
    NSString *toke = [tool makeToken:ZZTAccessKey secretKey:ZZTSecretKey];
    
    // key为图片的名字，这里的规范是：ios/pm/时间/10位数随机数.png
    [upManager putData:data key:keyString token:toke complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        if (complete) {
            complete(info, key, resp);
        }
    } option:nil];
    
    return keyString;
}

//多图上传
+ (NSString *)QiniuPutImageArray:(NSArray *)images complete:(void (^)(QNResponseInfo *info, NSString *key, NSDictionary *resp))complete uploadComplete:(void (^)(NSString *imgsStr))uploadComplete{
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    
    NSMutableString *imageMString = [NSMutableString string];
    
    for (int i = 0; i < images.count; i++) {
    
        UIImage *newImage = images[i];
        
        NSData *data = UIImagePNGRepresentation(newImage);

//        NSData *data = [self resetSizeOfImageData:newImage maxSize:400];
        NSString *keyTime = [self currentTime];
        
        NSString *keyRandom = [self randomString];
        
        NSString *keyString = [NSString stringWithFormat:@"%@%@.jpg",keyTime,keyRandom];
        NSLog(@"keyString = %@", keyString);
        
        [imageMString appendFormat:@"http://img.cdn.zztian.cn/%@,", keyString];
        
        AFNHttpTool *tool = [[AFNHttpTool alloc] init];
        NSString *toke = [tool makeToken:ZZTAccessKey secretKey:ZZTSecretKey];
        
        // key为图片的名字
        [upManager putData:data key:keyString token:toke complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (complete) {
                complete(info, key, resp);
            }
        } option:nil];
    }
    if(uploadComplete){
        uploadComplete([imageMString substringToIndex:imageMString.length - 1]);
    }
    return [imageMString substringToIndex:imageMString.length - 1];
}


/**
 *  动态发布图片压缩
 *
 *  @param source_image 原图image
 *  @param maxSize      限定的图片大小
 *
 *  @return 返回处理后的图片数据流
 */
+ (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
//
//    CGFloat tempHeight = newSize.height / 1024;
//    CGFloat tempWidth = newSize.width / 1024;
//
//    if (tempWidth > 1.0 && tempWidth != tempHeight) {
//        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
//    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);

    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    //格式转换
    //
    NSData *imageData = UIImagePNGRepresentation(newImage);
//    NSUInteger sizeOrigin = [imageData length];
//    NSUInteger sizeOriginKB = sizeOrigin / 1024;
//    NSLog(@"sizeOriginKB === %ld",sizeOriginKB);
//    if (sizeOriginKB > maxSize) {
//        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
//        NSLog(@"finallImageDataKB === %ld",[finallImageData length]/1024);
//        return finallImageData;
//    }
//    //    NSData *imageData = [PMRequest image:newImage maxSize:maxSize];
//    NSLog(@"imageDataKB === %ld",[imageData length]/1024);
    return imageData;
}

+ (NSString *)currentTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyyMMddHHmmss"]];
    return [formatter stringFromDate:date];
}

+ (NSString *)randomString {
    NSString *kRandomAlphabet = @"0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        [randomString appendFormat: @"%C", [kRandomAlphabet characterAtIndex:arc4random_uniform((u_int32_t)[kRandomAlphabet length])]];
    }
    return randomString;
}

@end
