//
//  ZZTAuthorAttestationView.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/12/13.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import "ZZTAuthorAttestationView.h"

@implementation ZZTAuthorAttestationView

+(instancetype)AuthorAttestationView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

@end
