//
//  Tool.m
//  TaxtTong
//
//  Created by ling on 2017/7/3.
//  Copyright © 2017年 ling. All rights reserved.
//

#import "Tool.h"
#import <CommonCrypto/CommonDigest.h>
#import "UpYun.h"
#import "BNCoreServices.h"
@implementation Tool

/**
 *MD5加密
 */
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",    // 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

/**
 *判断是否为手机号码
 */
+(BOOL)isMobileNumberClassification:(NSString *)mobileNum
{
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *按钮倒计时
 */
+(void)countDown:(UIButton *)btn
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        
        UIColor *mainColor = [UIColor colorWithRed:252.0f/255.0f green:85.0f/255.0f blue:182.0f/255.0f alpha:1];
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                btn.userInteractionEnabled = YES;
                btn.layer.borderColor = mainColor.CGColor;
                [btn setTitleColor:mainColor forState:UIControlStateNormal];
                [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
            });
        }else{
            //            int minutes = timeout / 60;
            int seconds = timeout % 60 == 0? 60 :(timeout % 60);
            NSString *redText = [NSString stringWithFormat:@"%.2d", seconds];
            NSString *strTime = [NSString stringWithFormat:@"%@s", redText];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                btn.userInteractionEnabled = NO;
                btn.layer.borderColor = [UIColor grayColor].CGColor;
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn setTitle:strTime forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**
 *UPYUN上传图片
 */
+(void)upyunLoadImg:(UIImage *)img imgStr:(void(^)(NSString *))imgStr{
    
    NSData *data = UIImageJPEGRepresentation(img, 0.1);
    UIImage *uploadImg = [UIImage imageWithData:data];
    
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"degetongback";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"oX7QNClbjhGus2cuMv/OkFct1lA=";
    
    __block UpYun *uy = [[UpYun alloc] init];
    
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"response body %@", responseData);
        if (responseData) {
            imgStr(responseData[@"url"]);
        }else{
            imgStr(@"");
        }
        
    };
    
    uy.failBlocker = ^(NSError * error) {

        NSString *message = error.description;
        imgStr(@"");
        //回调失败
        NSLog(@"error %@", message);
    };
    
    [uy uploadImage:uploadImg savekey:[Tool getSaveKeyWith:@"jpg"]];
}

//图片命名 /2016/12/26/1482761592.jpg
+ (NSString * )getSaveKeyWith:(NSString *)suffix {
    
    return [NSString stringWithFormat:@"/%@.%@", [Tool getDateString], suffix];
    
}

+ (NSString *)getDateString {
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}


/**
 * 时间戳->年月日
 */
+ (NSString *)transFormatData:(NSInteger)timestamp
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy年MM月dd日"];
    NSString * timeStr = [formater stringFromDate:date];
    return timeStr;
}

/**
 * 中文编码
 */
+ (NSString *)encodeUTF8:(NSString *)str{
    
    return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

/**
 * UITextView垂直居中
 */
+ (UITextView *)contentSizeToFit:(UITextView *)txtView {
    if([txtView.text length]>0) {
        CGSize contentSize = txtView.contentSize;
        //NSLog(@"w:%f h%f",contentSize.width,contentSize.height);
        UIEdgeInsets offset;
        CGSize newSize = contentSize;
        if(contentSize.height <= txtView.frame.size.height) {
            CGFloat offsetY = (txtView.frame.size.height - contentSize.height)/2;
            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
        }
        else {
            newSize = txtView.frame.size;
            offset = UIEdgeInsetsZero;
            CGFloat fontSize = 18;
            while (contentSize.height > txtView.frame.size.height) {
                [txtView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
                contentSize = txtView.contentSize;
            }
            newSize = contentSize;
        }
        [txtView setContentSize:newSize];
        [txtView setContentInset:offset];
    }
    return txtView;
}

+ (double)getRed:(double)d{
    
    return d*M_PI/180.0;
}

/**
 * 计算经纬度距离
 */
+ (NSString *)getGreatCircleDistance:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2
{
    double f = [Tool getRed:((lat1+lat2)/2)];
    double g = [Tool getRed:((lat1-lat2)/2)];
    double l = [Tool getRed:((lng1-lng2)/2)];
    
    double sg = sin(g);
    double sl = sin(l);
    double sf = sin(f);
    
    double s,c,w,r,d,h1,h2;
    double a = 6378137.0;
    double fl = 1/298.257;
    
    sg = sg*sg;
    sl = sl*sl;
    sf = sf*sf;
    
    s = sg*(1-sl) + (1-sf)*sl;
    c = (1-sg)*(1-sl) + sf*sl;
    
    w = atan(sqrt(s/c));
    r = sqrt(s*c)/w;
    d = 2*w*a;
    h1 = (3*r -1)/2/c;
    h2 = (3*r +1)/2/s;
    
    NSString *srt;
    double len_m = d*(1 + fl*(h1*sf*(1-sg) - h2*(1-sf)*sg));
    srt = [NSString stringWithFormat:@"%.2f",len_m/1000];
    
    return srt;
}


/**
 * 拨打手机号码
 */
+ (void)callPhone:(NSString *)num
{
    NSString *str =[[NSString alloc] initWithFormat:@"tel:%@",num];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:nil completionHandler:nil];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}



@end
