//
//  Tool.h
//  TaxtTong
//
//  Created by ling on 2017/7/3.
//  Copyright © 2017年 ling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tool : NSObject

/** MD5加密 */
+ (NSString *)md5:(NSString *)str;

//判断是否为手机号码
+ (BOOL)isMobileNumberClassification:(NSString *)mobileNum;

//按钮倒计时
+(void)countDown:(UIButton *)btn;

//UPYUN上传图片
+(void)upyunLoadImg:(UIImage *)img imgStr:(void(^)(NSString *))imgStr;

/**
 * 时间戳->年月日
 */
+ (NSString *)transFormatData:(NSInteger)timestamp;

/**
 * 中文编码
 */
+ (NSString *)encodeUTF8:(NSString *)str;

/**
 * UITextView垂直居中
 */
+ (UITextView *)contentSizeToFit:(UITextView *)txtView;

/**
 * 计算经纬度距离
 */
+ (NSString *)getGreatCircleDistance:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2;

/**
 * 拨打手机号码
 */
+ (void)callPhone:(NSString *)num;


@end
