//
//  ZZTXuHuaUserView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTXuHuaUserView : UICollectionView

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) ZZTJiXuYueDuModel *lastReadModel;

@property (nonatomic,strong) ZZTCarttonDetailModel *bookDetail;

//didItem
@property (nonatomic,copy) void (^didUserItem)(ZZTChapterlistModel *xuHuaChapter);


@end

NS_ASSUME_NONNULL_END
