//
//  ZZTMulPlayCell.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/9/29.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZZTChapterlistModel;

@interface ZZTMulPlayCell : UITableViewCell

@property (nonatomic,strong) ZZTChapterlistModel *xuHuaModel;

@property (nonatomic,strong) NSString *str;
@property (nonatomic,assign) BOOL isHave;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
