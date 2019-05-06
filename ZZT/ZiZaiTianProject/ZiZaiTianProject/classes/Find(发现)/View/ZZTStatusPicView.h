//
//  ZZTStatusPicView.h
//  ZiZaiTianProject
//
//  Created by mac on 2019/4/22.
//  Copyright © 2019 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZTStatusPicView : UICollectionView

@property (nonatomic, strong) NSArray *imgArray;


@end


@interface ZZTStatusPicCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (strong, nonatomic)  NSString *imgUrl;

@end

NS_ASSUME_NONNULL_END
