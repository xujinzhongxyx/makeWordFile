//
//  helper.h
//  myComprehensiveApplication
//
//  Created by jinzhong xu on 2017/6/20.
//  Copyright © 2017年 jinzhong xu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface Helper : NSObject

//获取文件数据
+(id) getDataFromFile:(NSString *)fileName fileType:(NSString *)type;
//计算高宽
+(CGSize)getSizeSizeWithAttributeStr:(NSString *)fullDescAndTagStr withSize:(CGSize)size font:(CGFloat)fontSize;
//字符串中是否含有中文
+(BOOL)isChineseFromString:(NSString *)string;
//第一个汉字的索引
+(NSUInteger)getFirstChineseIndex:(NSString *)string;
//从字符串中获取英文
+(NSString *)getEnglishString:(NSString *)string;
//从字符串中获取中文
+(NSString *)getChineseString:(NSString *)string;
//获取某个字符之前的数字
+(NSString *)getSubstringToIndex:(NSString *)string withChart:(NSString *)chart;
//获取某个字符之前的字符
+(NSString *)getSubstringFromIndex:(NSString *)string withChart:(NSString *)chart;
//获取文件内容
+(NSArray *)stringContentOfFile:(NSString *)fileName;
//获取文件内容
+(NSArray *)SeparatedByStringContentOfFile:(NSString *)fileName  separated:(NSString *)separated;
//获取拆分的内容
+(NSArray *)SeparatedByString:(NSString *)content separated:(NSString *)separated;
//读取本地Json文件
+ (id)getJsonDataJsonname:(NSString *)jsonname;
//写本地Json文件
+ (BOOL)setJsonDataJsonname:(NSString *)jsonname str:(NSString *)strData;
//通过16进制计算颜色
+ (NSColor *)colorFromHexRGB:(NSString *)inColorString;
// 字典转json字符串方法
+(NSString *)convertToJsonData:(NSDictionary *)dict;

//把格式化的JSON格式的字符串转换成字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//带json格式的对象(字典)转化成json字符串
+ (NSString *)jsonStringWithObject:(id)jsonObject;

@end
