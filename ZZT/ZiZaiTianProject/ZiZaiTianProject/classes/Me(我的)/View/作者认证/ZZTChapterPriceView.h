//
//  ZZTChapterPriceView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/17.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZZTChapterlistModel;
@class ZZTLittleBoxView;

@protocol chapterPriceViewDelegate <NSObject>

@optional

- (void)setChapterPriceViewModel:(ZZTChapterlistModel *)model;

- (void)setupPriceEnding:(NSString *)price;

@end

@interface ZZTChapterPriceView : UIView

@property (nonatomic,strong) NSArray *dataArray;

@property(nonatomic,weak)id<chapterPriceViewDelegate>   delegate;

@property (nonatomic,strong) ZZTLittleBoxView *littleBox;

@end
