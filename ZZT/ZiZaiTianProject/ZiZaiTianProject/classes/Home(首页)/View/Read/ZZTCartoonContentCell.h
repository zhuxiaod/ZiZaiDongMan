//
//  ZZTCartoonContentCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/7/16.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTCartoonModel;

//代理
@protocol ZZTCartoonContentCellDelegate <NSObject>

- (void)cellHeightUpdataWithIndex:(NSUInteger)index Height:(CGFloat)height;

- (void)saveImageUrl:(NSURL *)url index:(NSUInteger)index;

@end

@interface ZZTCartoonContentCell : UITableViewCell

@property (nonatomic,strong,readonly) UIImageView *content;

@property (nonatomic, weak) id <ZZTCartoonContentCellDelegate> delegate;

@property (nonatomic,strong) ZZTCartoonModel *model;

@property (nonatomic,strong) UIImage *cartoonImg;

-(NSNumber *)getImgaeHeight;

@end
