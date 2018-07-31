//
//  ColorHexString.h
//  轮播图
//
//  Created by xhkj on 2018/7/31.
//  Copyright © 2018年 WXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ColorHexString : NSObject

#pragma mark - 16进制颜色
+ (UIColor *) colorWithHexString: (NSString *)color;

@end
