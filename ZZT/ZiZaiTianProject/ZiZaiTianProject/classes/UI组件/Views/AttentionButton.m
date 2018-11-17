//
//  AttentionButton.m
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/8.
//  Copyright © 2018年 zxd. All rights reserved.
//

#import "AttentionButton.h"

//关注接口
static NSString * const likeUrl = @"http://api.kuaikanmanhua.com/v1/comics";

static NSString * const normalImageName = @"加关注";
static NSString * const pressedImageName = @"已关注";

@implementation AttentionButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    [self addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    
//    self.isAttention = false;
}

-(void)setIsAttention:(BOOL)isAttention{
    _isAttention = isAttention;
    NSString *imageName;
    if (isAttention == 1) {
        imageName = pressedImageName;
    }else{
        imageName = normalImageName;
    }
    
    [self setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}


- (void)like {
    
    if([[UserInfoManager share] hasLogin] == NO){
        [UserInfoManager needLogin];
        return;
    }
    //设置相反状态
    self.isAttention = !self.isAttention;
    
    //点击block
    if (self.onClick) {
        self.onClick(self);
    }
    
    if(self.isAttention == YES){
        [UIView animateWithDuration:0.25 animations:^{
            
            self.imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.imageView.transform = CGAffineTransformIdentity;
                self.userInteractionEnabled = YES;
            }];
            
        }];
    }
    
    //发送关注请求
    UserInfo *user = [Utilities GetNSUserDefaults];
    NSDictionary *dic = @{
                          @"userId":[NSString stringWithFormat:@"%ld",user.id],
                          @"authorId":self.requestID
                          };
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager POST:[ZZTAPI stringByAppendingString:@"record/ifUserAtAuthor"]  parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(void)setRequestID:(NSString *)requestID{
    _requestID = requestID;
}
@end
