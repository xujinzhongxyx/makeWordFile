//
//  AppDelegate.m
//  makeWordFile
//
//  Created by zlw on 2017/12/20.
//  Copyright © 2017年 xujinzhong. All rights reserved.
//

#import "AppDelegate.h"

#import "viewController.h"

@interface AppDelegate ()

//@property(nonatomic, strong) buttonView *btnView;


@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    viewController *contentViewController = [[viewController alloc] initWithNibName:@"viewController" bundle:nil];
    [self.window setStyleMask:NSWindowStyleMaskClosable|NSWindowStyleMaskBorderless|NSWindowStyleMaskTitled];
    [self.window setContentViewController:contentViewController];
    [self.window setTitle:@"文件生成工具"];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSLog(@"------------");
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
