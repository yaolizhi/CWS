//
//  NSString+Conversion.h
//  MIT-AffordSuperMarket
//
//  Created by apple on 15/11/28.
//  Copyright © 2015年 河南大实惠电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Conversion)
///把空字符串转换成 @“”
+ (NSString*)stringISNull:(NSString*)_str;
///判断字符串是否可用(可能是整型)
+ (NSString*)stringTransformObject:(id)object;
+ (NSString*)numConversionWithStr:(NSString*)unitNum;
///判断字符串最后两位是否是0
+ (NSString*)marketLastTwoByteOfStringIsZero:(NSString*)_str;
///计算小数点有几位
+ (NSString*)decimalPrecisionWithString:(NSString*)_str;
///转换图片路径
+ (NSString*)appendImageUrl:(NSString*)imageUrl;
///获取当前日期
+ (NSString*)getCurrentDate;
///把秒转换成时分秒
+(NSString*)getHHMMSSFromS:(NSString *)totalTime;
///格式化时间
+(NSString*)formateDate:(NSString*)datastring;
///把时间戳转换成日期
+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString;
//+ (NSString *)timeWithSecondTimeIntervalString:(NSString *)timeString;
///获取n天前日期
+ (NSString*)getBeforeOfNDay:(NSDate *)date withDay:(int)day;
///获取日期时间通过时间戳
+ (NSString*)getDateWithTimestamp:(NSString*)timestamp;
///转换地址格式
+ (NSString*)convertAddress:(NSString*)address;
///转码字符串
+ (NSString *)URLDecodedString:(NSString *)str;
//将数量转换成千 万
+ (NSString *)numTransformationWithNum:(NSString *)num;
+ (NSString*)lastTwoByteOfStringIsZero:(NSString*)_str;
///格式化数据根据小数个数
+(NSString*)formateString:(NSString*)string decimalCount:(NSInteger)decimalCOunt;
///设置别名
+ (NSString*)getChatAliasWithUserID:(NSString*)userID;
///根据邀请码获取userID
+ (NSString*)getUserIDWithCode:(NSString*)code;
///IM
+ (NSString*)getIMCodeWithUserID:(NSString*)userID;
+ (NSString*)getUserIDWithIMCode:(NSString*)code;
///是否为空
+ (BOOL)isEmpty:(NSString *)string;
+(NSString*)formateSpecificDate:(NSString*)datastring;

/**
 正则电话号码
 规则：
 1.123456
 2.12-123
 3.12-123-123
 4.+123456
 5.123456+123456
 */

- (NSArray *)regularTelPhoneNumber;

/**
 网址正则表达式
 
 @return https:// ,http:// ,www  三种情况
 */
- (NSArray *)regularWebURL;

/**
 判断是否是网址
 
 return YES和NO
 */
- (BOOL)isWebURL;

///获取文字实际宽度
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
///改变文字的样式
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize paragraphStyle:(NSMutableParagraphStyle*)paragraphStyle;
///获取文字的实际高度
- (float) heightForString:(UITextView *)textView andWidth:(float)width;


@end
