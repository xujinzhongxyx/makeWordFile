//
//  account.h
//  rightBrainDevelopment
//
//  Created by jinzhong xu on 2017/6/20.
//  Copyright © 2017年 jinzhong xu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject<NSCoding>

/* 实例化 **/
+(Account *)shareInstance;
/* 文件归档 **/
+(void)writeFileCacheVariablesToFile;
/* 文件读取 **/
+(Account*)readFileCacheVariablesFromFile;

@property(nonatomic ,assign) NSInteger  wordIdx;
@property(nonatomic ,strong) NSArray    *aryWords;

@end
