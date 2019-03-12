//
//  ZZTMallListModel.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZZTMallListModel : NSObject

@property (nonatomic,assign) NSInteger pageSize;

@property (nonatomic,assign) BOOL hasNextPage;

@property (nonatomic,assign) NSInteger pages;

@property (nonatomic,assign) NSInteger lastPage;

@property (nonatomic,assign) NSInteger pageNum;

@property (nonatomic,assign) BOOL isLastPage;

@property (nonatomic,assign) NSInteger navigateFirstPage;

@property (nonatomic,assign) NSInteger navigateLastPage;

@property (nonatomic,assign) NSInteger navigatePages;

@property (nonatomic,assign) BOOL hasPreviousPage;

@property (nonatomic,assign) NSInteger nextPage;

@property (nonatomic,assign) NSInteger size;

@property (nonatomic,assign) NSInteger startRow;

@property (nonatomic,assign) NSInteger total;

@property (nonatomic,assign) NSInteger prePage;

@property (nonatomic,assign) NSInteger firstPage;

@property (nonatomic,assign) BOOL isFirstPage;

@property (nonatomic,assign) NSInteger endRow;

@end
