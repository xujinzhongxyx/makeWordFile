//
//  account.m
//  rightBrainDevelopment
//
//  Created by jinzhong xu on 2017/6/20.
//  Copyright © 2017年 jinzhong xu. All rights reserved.
//

#import "Account.h"
#import <objc/message.h>

static Account *_instanceAccount  = nil;

@implementation Account

+(Account *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceAccount = [Account readFileCacheVariablesFromFile];
        if (!_instanceAccount) {
            _instanceAccount = [[Account alloc] init];
        }
    });
    
    return _instanceAccount;
}

/* 文件归档 **/
+ (void) writeFileCacheVariablesToFile
{
    NSString *fileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"account.com"];
    [NSKeyedArchiver archiveRootObject:_instanceAccount toFile:fileName];
}

/* 文件读取 **/
+(Account*)readFileCacheVariablesFromFile
{
    static Account *myAccount = nil;
    NSString *fileName = [NSTemporaryDirectory() stringByAppendingPathComponent:@"account.com"];
    myAccount = (Account *)[NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    
    return myAccount;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    Class selfClass = self.class;
    while (selfClass &&selfClass != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [self valueForKeyPath:key];
            [aCoder encodeObject:value forKey:key];
        }
        free(ivars);
        selfClass = [selfClass superclass];
    }
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    // 不光归档自身的属性，还要循环把所有父类的属性也找出来
    Class selfClass = self.class;
    while (selfClass &&selfClass != [NSObject class]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList(selfClass, &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
        }
        free(ivars);
        selfClass = [selfClass superclass];
    }
    
    return self;
}

@end
