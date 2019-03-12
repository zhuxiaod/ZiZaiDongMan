//
//  ZZTMoreFooterView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/13.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZTMoreFooterView : UICollectionReusableView

@property (nonatomic,copy) void (^moreBtnClick)(void);

@property (nonatomic,copy) void (^updateBtnClick)(void);

@property (nonatomic,strong) NSArray *dataArray;

-(void)cacultor:(NSInteger (^)(NSInteger))resultBlock;

-(void)loadDataWithPageNum:(NSInteger)pageNum url:(NSString *)url resultBlock:(void  (^)(NSArray * array))resultBlock;

@end
