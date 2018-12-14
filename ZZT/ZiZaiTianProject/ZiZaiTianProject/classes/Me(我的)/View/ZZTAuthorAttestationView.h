//
//  ZZTAuthorAttestationView.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/13.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZZTAuthorAttestationViewDelegate <NSObject>

@optional

- (void)getBoxStateWithTag:(NSInteger)tag state:(NSString *)state;

@end

@interface ZZTAuthorAttestationView : UIView

@property(nonatomic,weak)id<ZZTAuthorAttestationViewDelegate>   delegate;

+(instancetype)AuthorAttestationView;

@end
