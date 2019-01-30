//
//  NSDictionary+Property.m
//  自动生成属性
//
//  Created by zxd on 2019/1/27.
//  Copyright © 2019年 zxd. All rights reserved.
//

#import "NSDictionary+Property.h"

@implementation NSDictionary (Property)

-(void)createPropertyCode{
   
    NSMutableString *codes = [NSMutableString string];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSLog(@"%@",[obj class]);
        
        NSString *code;
        
        if([obj isKindOfClass:[NSString class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic,strong) NSString *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            code = [NSString stringWithFormat:@"@property (nonatomic,assign) BOOL %@;",key];
        }else if ([obj isKindOfClass:[NSNumber class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic,assign) NSInteger %@;",key];
        }else if ([obj isKindOfClass:[NSArray class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic,strong) NSArray *%@;",key];
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            code = [NSString stringWithFormat:@"@property (nonatomic,strong) NSDictionary *%@;",key];
        }
        [codes appendFormat:@"\n%@\n",code];
    }];
    
    NSLog(@"%@",codes);
    

}
@end
