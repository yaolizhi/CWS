//
//  NSString+Conversion.m
//  MIT-AffordSuperMarket
//
//  Created by apple on 15/11/28.
//  Copyright © 2015年 河南大实惠电子商务有限公司. All rights reserved.
//

#import "NSString+Conversion.h"

//#import "ManagerGlobeUntil.h"

#define TPNPattern @"(\\d{5,18})|(\\d{5,18}-(\\d{1,18}))|(\\d{5,18}-(\\d{1,18}-(\\d{1,18})))|(\\+\\d{5,18})|(\\d{5,18}\\+(\\d{5,18}))"

@implementation NSString (Conversion)
//把空字符串转换成 @“”
+ (NSString*)stringISNull:(NSString*)_str {
    if ( [_str isKindOfClass:[NSNull class]] || _str.length == 0 || _str == nil) {
        return @"";
    }
    return _str;
}

//判断字符串是否可用(可能是整型)
+ (NSString*)stringTransformObject:(id)object {
    NSString *str = @"";
    if ([object isKindOfClass:[NSNumber class]]) {
        str = [object stringValue];
    } else if([object isKindOfClass:[NSNull class]]){
        str = @"";
    } else {
        str = (NSString*)object;
    }
    return [self stringISNull:str];
}

//判断小数点后数字是否以0结尾
+ (NSString*)marketLastTwoByteOfStringIsZero:(NSString*)_str
{
    if ([_str doubleValue] == 0|| [_str isEqualToString:@"0"] || [_str isEqualToString:@"0.0"] || [_str isEqualToString:@"0.00"])
    {
        return @"0";
    }
    
    NSRange range = [_str rangeOfString:@"."];
    
    if (range.length == 0 || range.location == 0)//没有小数点的str
    {
        return _str;
    }
    
    NSInteger lastOfStringLocation = range.location+1;//小数点后面第一位数下标
    NSInteger subLength = _str.length - lastOfStringLocation;//小数点后长度
    
    //小数点后字符串
    NSString * lastOfString = [_str substringWithRange:NSMakeRange(lastOfStringLocation, subLength)];
    
    NSInteger cubLength = 0;//计算小数点最后出现O的位置
    for (NSInteger i = subLength -1; i>=0; i--) {
        NSString *subStr = [lastOfString substringWithRange:NSMakeRange(i, 1)];
        if ([subStr isEqualToString:@"0"])
        {
            cubLength ++;
        }
        else
        {
            break;
        }
    }
    NSString *newString = nil;
    if (cubLength !=0)
    {
        if(subLength== cubLength){
            newString = [_str substringWithRange:NSMakeRange(0, _str.length-cubLength-1)];
        }else{
            newString = [_str substringWithRange:NSMakeRange(0, _str.length-cubLength)];
        }
        
        return newString;
    }
    
    return _str;
    
}

//转换图片路径
+ (NSString*)appendImageUrl:(NSString*)imageUrl {
    if ([imageUrl isKindOfClass:[NSString class]] && [imageUrl containsString:@"http:"]) {
        return imageUrl;
    }
    return [NSString stringWithFormat:@"%@",imageUrl];
}

//把秒转换成时分秒
+(NSString*)getHHMMSSFromS:(NSString *)totalTime {
    NSInteger seconds = [totalTime integerValue];
    
    //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%02ld",seconds/3600];
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",(seconds%3600)/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = @"";
    if ([str_hour isEqualToString:@"00"]) {
        format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    } else {
        format_time = [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }
    return format_time;
}

//把数量超过万的转换成 w
+ (NSString *)numTransformationWithNum:(NSString *)num{
    NSString *nullStr = @"0";
    double   numDb = 0;
    double   nNumDouble = num.doubleValue;
    
   if (nNumDouble>10000){
        numDb=nNumDouble/10000;
        nullStr=[NSString stringWithFormat:@"%.1fw",numDb];
        return nullStr;
    }else {
        return num;
    }
}

+ (NSString*)numConversionWithStr:(NSString*)unitNum {
    
    NSString *nullStr = @"0";
    double   numDb = 0;
    double   nNumDouble = unitNum.doubleValue;
    
    if (nNumDouble == 0)
    {
        return nullStr;
    }
    
    if (nNumDouble >= 10000000000.0 || nNumDouble <= -10000000000.0) {
        numDb = nNumDouble/100000000.0;
        nullStr = [NSString stringWithFormat:@"%.0f亿",numDb];
    }else if (nNumDouble >= 1000000000.0 || nNumDouble <= -1000000000.0) {
        numDb = nNumDouble/100000000.0;
        nullStr = [NSString stringWithFormat:@"%.1f亿",numDb];
    }else if (nNumDouble >= 100000000 || nNumDouble <= -100000000) {
        numDb = nNumDouble/100000000;
        nullStr = [NSString stringWithFormat:@"%.2f亿",numDb];
    }else if(nNumDouble >= 1000000 || nNumDouble <= -1000000){
        numDb = nNumDouble/10000;
        nullStr = [NSString stringWithFormat:@"%.0f万",numDb];
    }else if(nNumDouble >= 100000 || nNumDouble <= -100000){
        numDb = nNumDouble/10000;
        nullStr = [NSString stringWithFormat:@"%.1f万",numDb];
    }
    //    else if(nNumDouble >= 10000){
    //        numDb = nNumDouble/10000;
    //        nullStr = [NSString stringWithFormat:@"%.2f万",numDb];
    //    }
    else {
        nullStr = unitNum;
    }
    
    return nullStr;
}
//转换地址格式
+(NSString*)convertAddress:(NSString*)address {
    NSArray *addressArr = [address componentsSeparatedByString:@","];
    return [addressArr componentsJoinedByString:@" "];

}

+(NSString *)URLDecodedString:(NSString *)str
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

//判断小数点后数字是否以0结尾
+ (NSString*)lastTwoByteOfStringIsZero:(NSString*)_str {
    
    if ([_str doubleValue] == 0|| [_str isEqualToString:@"0"] || [_str isEqualToString:@"0.0"] || [_str isEqualToString:@"0.00"]){
        
    }
    
    NSRange range = [_str rangeOfString:@"."];
    
    if (range.length == 0 || range.location == 0)//没有小数点的str
    {
        return _str;
    }
    
    NSInteger lastOfStringLocation = range.location+1;
    NSInteger subLength = _str.length - lastOfStringLocation;
    
    //小数点后字符串
    NSString * lastOfString = [_str substringWithRange:NSMakeRange(lastOfStringLocation, subLength)];
    
    int cubLength = 0;
    for (NSInteger i = subLength -1; i>=0; i--) {
        NSString *subStr = [lastOfString substringWithRange:NSMakeRange(i, 1)];
        if ([subStr isEqualToString:@"0"])
        {
            cubLength ++;
        }
        else
        {
            break;
        }
    }
    NSString *newString = nil;
    if (cubLength !=0)
    {
        if(subLength== cubLength){
            newString = [_str substringWithRange:NSMakeRange(0, _str.length-cubLength-1)];
        }else{
            newString = [_str substringWithRange:NSMakeRange(0, _str.length-cubLength)];
        }
        
        return newString;
    }
    
    return _str;
    
}
//计算小数点有几位
+ (NSString*)decimalPrecisionWithString:(NSString*)_str {
    NSRange range = [_str rangeOfString:@"."];
    if (range.length == 0 || range.location == 0) {//没有小数点的str
        return @"0";
    }
    NSInteger lastOfStringLocation = range.location+1;
    NSInteger subLength = _str.length - lastOfStringLocation;
    return [NSString stringWithFormat:@"%ld",(long)subLength];
}
//获取当前日期
+ (NSString*)getCurrentDate {
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
//格式化时间
+(NSString*)formateDate:(NSString*)datastring {
    @try {
        if ([datastring isKindOfClass:[NSNull class]]) {
            return @"";
        }
        // ------实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
        
        NSDate * nowDate = [NSDate date];
        
        // ------将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:datastring];
        
        // ------取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
//        NSLog(@"time----%f",time);
        // ------再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = [[NSString alloc] init];
        
//        if (time<=60*10) {  //10分钟以内的
//
////            dateStr = @"刚刚";
//            dateStr=@"";
//        }
//        }else if(time<=60*60){  //一个小时以内的
//
//            int mins = time/60;
//            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
//
//        }
        if(time<=60*60*48){  //在两天内的
            
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //在同一天
                dateStr = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                //昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:@"MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
}

//格式化时间
+(NSString*)formateSpecificDate:(NSString*)datastring {
    @try {
        if ([datastring isKindOfClass:[NSNull class]]) {
            return @"";
        }
        // ------实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
        
        NSDate * nowDate = [NSDate date];
        
        // ------将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:datastring];
        
        // ------取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval intevalTime = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //        NSLog(@"time----%f",time);
        // ------再然后，把间隔的秒数折算成天数和小时数：
        
        
        //秒、分、小时、天、月、年
        NSInteger minutes = intevalTime / 60;
        NSInteger hours = intevalTime / 60 / 60;
        NSInteger day = intevalTime / 60 / 60 / 24;
        NSInteger month = intevalTime / 60 / 60 / 24 / 30;
        NSInteger yers = intevalTime / 60 / 60 / 24 / 365;
        
        if (minutes <= 10) {
            return  @"刚刚";
        }else if (minutes < 60){
            return [NSString stringWithFormat: @"%ld分钟前",(long)minutes];
        }else if (hours < 24){
            return [NSString stringWithFormat: @"%ld小时前",(long)hours];
        }else if (day < 30){
            return [NSString stringWithFormat: @"%ld天前",(long)day];
        }else if (month < 12){
            NSDateFormatter * df =[[NSDateFormatter alloc]init];
            df.dateFormat = @"M月d日";
            NSString * time = [df stringFromDate:needFormatDate];
            return time;
        }else if (yers >= 1){
            NSDateFormatter * df =[[NSDateFormatter alloc]init];
            df.dateFormat = @"yyyy年M月d日";
            NSString * time = [df stringFromDate:needFormatDate];
            return time;
        }
        return @"";
        
    }
    @catch (NSException *exception) {
        return @"";
    }
    
}

+ (NSString *)timeWithTimeIntervalString:(NSString *)timeString{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

//+ (NSString *)timeWithSecondTimeIntervalString:(NSString *)timeString{
//    // 格式化时间
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
////    NSString *dateString = [formatter setDateFormat:@"YYYYMMddHHmmssSS"];
//    
//    // 毫秒值转化为秒
////    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]];
////    NSString* dateString = [formatter stringFromDate:date];
//    return dateString;
//
//}
//获取n天前的日期
+ (NSString*)getBeforeOfNDay:(NSDate *)date withDay:(int)day{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd";
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setDay:-day];
    NSDate *dateAfterday = [calendar dateByAddingComponents:componentsToAdd toDate:date options:0];
    NSString *strDate = [formatter stringFromDate:dateAfterday];
    return strDate;
    
}
//获取日期时间通过时间戳
+ (NSString*)getDateWithTimestamp:(NSString*)timestamp {
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

//格式化数据根据小数个数
+(NSString*)formateString:(NSString*)string decimalCount:(NSInteger)decimalCOunt {
    NSString* format = [NSString stringWithFormat:@"%%.%ldf",(long)decimalCOunt];
    return  [NSString stringWithFormat:format,string];
}
+ (NSString*)getChatAliasWithUserID:(NSString*)userID {
    NSInteger newUerID = 10000000 + userID.integerValue;
    return [NSString stringWithFormat:@"RC%ld",(long)newUerID];
}
+ (NSString*)getUserIDWithCode:(NSString*)code {
    int index = 2;
    NSString *numStr = [code substringFromIndex:index];
    NSInteger userID = numStr.integerValue % 10000000;
    return [NSString stringWithFormat:@"%ld",(long)userID];
}

+ (NSString*)getIMCodeWithUserID:(NSString*)userID {
    NSInteger newUerID = 10000000 + userID.integerValue;
//    if ([baseServerUrl isEqualToString:@"https://rc.hongtugw.com/"]) {
//        return [NSString stringWithFormat:@"ht_RC%ld",(long)newUerID];
//    }
    return [NSString stringWithFormat:@"RC%ld",(long)newUerID];
}
+ (NSString*)getUserIDWithIMCode:(NSString*)code {
    int index = 2;
//    if ([baseServerUrl isEqualToString:@"https://rc.hongtugw.com/"]) {
//        index = 5;
//    }
    NSString *numStr = [code substringFromIndex:index];
    NSInteger userID = numStr.integerValue % 10000000;
    return [NSString stringWithFormat:@"%ld",(long)userID];
}

+ (BOOL)isEmpty:(NSString *)string
{
    return string == nil || string.length == 0;
}

- (NSArray *)regularTelPhoneNumber {
    NSError *error;
    
    NSString *pattern;
    if ([self containsString:@"+"]) {
        pattern = @"\\d{1,18}[+]?\\d{5,18}";
    }else{
        pattern = @"\\d{2,18}[-]?\\d{3,18}[-]\\d{3,18}";
    }
    if (![self containsString:@"+"] && ![self containsString:@"-"]) {
        pattern = TPNPattern;
    }
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSMutableArray *regularTPArray = [[NSMutableArray alloc]init];
    if (!error && regexps) {
        [regexps enumerateMatchesInString:self
                                  options:0
                                    range:NSMakeRange(0, self.length)
                               usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                   NSString *resultString = [self substringWithRange:result.range];
                                   
                                   [regularTPArray addObject:resultString];
                               }];
        return (NSArray *)regularTPArray;
    }
    return @[];
}

- (NSArray *)regularWebURL {
    
    NSMutableArray *webURLArray = [[NSMutableArray alloc]init];
    NSArray *httpArray = [self regularWebHTTPURL];
    NSArray *httpsArray = [self regularWebHTTPSURL];
    NSArray *wwwArray = [self regularWebWWWURL];
    
    if (httpArray.count >0) {
        [webURLArray addObjectsFromArray:httpArray];
    }
    if (httpsArray.count >0 ) {
        [webURLArray addObjectsFromArray:httpsArray];
    }
    NSMutableArray *wwwMArray = [NSMutableArray arrayWithArray:wwwArray];
    if (wwwArray.count>0) {
        for (NSString *webURL in webURLArray) {
            for (NSString *wwwURL in wwwArray) {
                if ([webURL containsString:wwwURL]) {
                    [wwwMArray removeObject:wwwURL];
                }
            }
        }
        [webURLArray addObjectsFromArray:wwwMArray];
    }
    return (NSArray *)webURLArray;
}

- (NSArray *)regularWebHTTPURL {
    
    NSString *pattern = @"(http):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+[\\w\\-\\.,a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?";
    return [self regularWithPattern:pattern];
}

- (NSArray *)regularWebHTTPSURL {
    NSString *pattern = @"(https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+[\\w\\-\\.,a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?";
    return [self regularWithPattern:pattern];
}

- (NSArray *)regularWebWWWURL {
    NSString *pattern = @"www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?";
    return [self regularWithPattern:pattern];
}

- (NSArray *)regularWithPattern:(NSString *)pattern {
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    NSMutableArray *regularTPArray = [[NSMutableArray alloc]init];
    if (!error && regexps) {
        [regexps enumerateMatchesInString:self
                                  options:0
                                    range:NSMakeRange(0, self.length)
                               usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                                   NSString *resultString = [self substringWithRange:result.range];
                                   [regularTPArray addObject:resultString];
                               }];
        return (NSArray *)regularTPArray;
    }
    return @[];
}

- (BOOL)isWebURL {
    if ([self containsString:@"http://"] ||
        [self containsString:@"https://"] ||
        [self containsString:@"www."]) {
        return YES;
    }
    return NO;
}

-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize
                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                           attributes:attrs
                              context:nil].size;
    
}
-(CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize paragraphStyle:(NSMutableParagraphStyle*)paragraphStyle {
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    return [self boundingRectWithSize:maxSize
                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                           attributes:dic
                              context:nil].size;
}
/*
 @method 获取指定宽度width的字符串在UITextView上的高度
 @param textView 待计算的UITextView
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}

@end
