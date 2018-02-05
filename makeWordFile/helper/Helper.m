//
//  helper.m
//  myComprehensiveApplication
//
//  Created by jinzhong xu on 2017/6/20.
//  Copyright © 2017年 jinzhong xu. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(id)getDataFromFile:(NSString *)fileName fileType:(NSString *)type
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error ];
    
    return object;
}

//计算高宽
+(CGSize)getSizeSizeWithAttributeStr:(NSString *)fullDescAndTagStr withSize:(CGSize)size font:(CGFloat)fontSize
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:fullDescAndTagStr];
    
    NSRange allRange = [fullDescAndTagStr rangeOfString:fullDescAndTagStr];
    [attrStr addAttribute:NSFontAttributeName
                    value:[NSFont systemFontOfSize:fontSize]
                    range:allRange];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[NSColor blackColor]
                    range:allRange];
    
    NSRange destRange = [fullDescAndTagStr rangeOfString:@"a"];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[NSColor redColor]
                    range:destRange];
    
    CGFloat titleHeight;
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attrStr boundingRectWithSize:size
                                        options:options
                                        context:nil];
    titleHeight = ceilf(rect.size.height)-10;
    
    return CGSizeMake(size.width, titleHeight);
}

//字符串中是否含有中文
+(BOOL)isChineseFromString:(NSString *)string
{
    for (NSInteger i = 0; i<string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [string substringWithRange:range];
        const char *cStr = [subStr UTF8String];
        if (strlen(cStr)==3) {
            return YES;
        }
    }
    return NO;
}

//第一个汉字的索引
+(NSUInteger)getFirstChineseIndex:(NSString *)string
{
    for (NSInteger i = 0; i<string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [string substringWithRange:range];
        const char *cStr = [subStr UTF8String];
        if (strlen(cStr)==3) {
            return i;
        }
    }
    return string.length;
}

//从字符串中获取英文
+(NSString *)getEnglishString:(NSString *)string
{
    NSUInteger index = [Helper getFirstChineseIndex:string];
    return [string substringToIndex:index];
}
//从字符串中获取中文
+(NSString *)getChineseString:(NSString *)string{
    NSUInteger index = [Helper getFirstChineseIndex:string];
    return [string substringFromIndex:index];
}

//获取某个字符之前的字符
+(NSString *)getSubstringToIndex:(NSString *)string withChart:(NSString *)chart
{
    for (NSInteger i = 0; i<string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [string substringWithRange:range];
        if ([subStr isEqualToString:chart]) {
            return [string substringToIndex:i];
        }
        
    }
    return string;
}

//通过16进制计算颜色
+ (NSColor *)colorFromHexRGB:(NSString *)inColorString
{
    NSColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [NSColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}

//获取某个字符之前的字符
+(NSString *)getSubstringFromIndex:(NSString *)string withChart:(NSString *)chart
{
    for (NSInteger i = 0; i<string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString *subStr = [string substringWithRange:range];
        if ([subStr isEqualToString:chart]) {
            return [string substringFromIndex:i];
        }
    }
    return string;
}

//获取文件内容
+(NSArray *)stringContentOfFile:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSArray *aryLines = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
    return aryLines;
}

//获取文件内容
+(NSArray *)SeparatedByStringContentOfFile:(NSString *)fileName separated:(NSString *)separated
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSArray *aryLines = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:separated];
    return aryLines;
}

//获取拆分的内容
+(NSArray *)SeparatedByString:(NSString *)content separated:(NSString *)separated
{
    NSArray *aryContent = [content componentsSeparatedByString:separated];
    return aryContent;
}

//读取本地Json文件
+ (id)getJsonDataJsonname:(NSString *)jsonname
{
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonname ofType:@"json"];
//    NSString *floderPath = PATH_AT_LIBDIR(@"Caches/LSCacheFinder");
//    if(![[NSFileManager defaultManager] fileExistsAtPath:floderPath isDirectory:nil]){
//        [[NSFileManager defaultManager] createDirectoryAtPath:floderPath withIntermediateDirectories:NO attributes:nil error:nil];
//    }
////    NSString *path =  [floderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", jsonname]];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:path]){
        NSString *strData = @"";
        [strData writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!jsonData || error) {
        //DLog(@"JSON解码失败");
        return nil;
    } else {
        return jsonObj;
    }
}

//写本地Json文件
+ (BOOL)setJsonDataJsonname:(NSString *)jsonname str:(NSString *)strData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonname ofType:@"json"];
//    NSString *floderPath = PATH_AT_LIBDIR(@"Caches/LSCacheFinder");
//    if(![[NSFileManager defaultManager] fileExistsAtPath:floderPath isDirectory:nil]){
//        [[NSFileManager defaultManager] createDirectoryAtPath:floderPath withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//    NSString *path =  [floderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.json", jsonname]];
    BOOL isSuce = [strData writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    return isSuce;
}

// 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

//把格式化的JSON格式的字符串转换成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

//带json格式的对象(字典)转化成json字符串
+ (NSString *)jsonStringWithObject:(id)jsonObject{
    // 将字典或者数组转化为JSON串
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    if ([jsonString length] > 0 && error == nil){
        return jsonString;
    }else{
        return nil;
    }
}

@end
