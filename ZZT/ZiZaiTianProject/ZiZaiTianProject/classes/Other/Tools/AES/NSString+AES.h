//
//  NSString+AES.h
//  ZiZaiTianProject
//
//  Created by mac on 2018/11/29.
//  Copyright © 2018年 ZiZaiTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)
/**< 加密方法 */
- (NSString*)aci_encryptWithAES;

/**< 解密方法 */
- (NSString*)aci_decryptWithAES;
@end
