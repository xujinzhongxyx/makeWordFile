//
//  MacroFunction.h
//  LaShouGroup_6.0
//
//  Created by 刘 智平 on 13-10-25.
//  Copyright (c) 2013年 刘 智平. All rights reserved.
//

#ifndef LaShouGroup_6_0_MacroFunction_h
#define LaShouGroup_6_0_MacroFunction_h
//程序调试
#define DEBUG_RECEIVE_DATA(data)    NSLog(@"%s %@", __func__,[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding])

#define warnMsg(var) [NSString stringWithFormat:@"[%@]-不能为空", var];

//#undef DEBUG
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define MemoryCheckInitLog() [[LSMemoryCheckDriver shareInstance]logInitedObject:self];
#   define MemoryCheckDeallocLog() [[LSMemoryCheckDriver shareInstance]logDeallocedObject:self]
#   define MemoryPrintAllLogAsync() [[LSMemoryCheckDriver shareInstance]showAllObjectAsync]
#   define MemoryPrintLogWithType(type) [[LSMemoryCheckDriver shareInstance]showObjectWithType:type]
#else
#   define NSLog(...)
#   define DLog(...)
#   define LSLog(...)
#   define MemoryCheckInitLog()
#   define MemoryCheckDeallocLog()
#   define MemoryPrintAllLogAsync()
#   define MemoryPrintLogWithType(type)
#endif

//常用函数
#define LSLOG(fmt, ...)             NSLog((@"[Function:%s],[Line:%d]::: " fmt) ,__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define LSLOGDATA(data)             LSLOG(@"%@",[[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease])
#define RGBA(r,g,b,a)               [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGB(r,g,b)                  [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1.0f]
#define DEFAULT_BACKGROUNT         RGBA(236.0f, 236.0f, 236.0f, 1.0f)

#define FONT(f)                     [NSFont systemFontOfSize:f]
#define BOLDFONT(f)                 [NSFont boldSystemFontOfSize:f]
#define RELEASE_MEMORY(__POINTER)   { if((__POINTER) != nil) { [__POINTER release]; __POINTER = nil; } }
#define IMAGEAPPDIR(name)           [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:nil]?[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@@2x",name] ofType:nil]:[[NSBundle mainBundle] pathForResource:name ofType:nil]
#define IMAGE_AT_APPDIR(name)       [LSHelper imageAtApplicationDirectoryWithName:name]
#define PATH_AT_APPDIR(name)        [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name]
#define PATH_AT_DOCDIR(name)        [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
#define PATH_AT_TMPDIR(name)        [NSTemporaryDirectory() stringByAppendingPathComponent:name]
#define PATH_AT_CACHEDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
#define PATH_AT_LIBDIR(name)		[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:name]
#define is4Inch                     ([UIScreen instancesRespondToSelector:@selector(currentMode)] && [[UIScreen mainScreen] currentMode].size.height == 1136)
#define isiPhone4S                  ([UIScreen instancesRespondToSelector:@selector(currentMode)] && [[UIScreen mainScreen] currentMode].size.height == 960)
#define DismissModalViewControllerAnimated(controller,animated) [LSHelper dismissModalViewController:controller Animated:animated];
#define PresentModalViewControllerAnimated(controller1,controller2,animated)     [LSHelper presentModalViewRootController:controller1 toViewController:controller2 Animated:animated];
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define CanAliPay [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://alipayclient/"]]
#define CanAliSafePay [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"safepay://alipayclient/"]]
#define WappayRedirectUrl           @"http://www.lashou.com"


//设备类型判断
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPAD ([[[UIDevice currentDevice] model] isEqualToString:@"iPad"])
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
#define IS_SIMULATOR ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"])

/*
 *@bref  系统版本判断
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define iOS7System (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) ? YES:NO)
#define CURRENTSYSTEM  [[[UIDevice currentDevice] systemVersion] floatValue]

/*
 *@bref  系统版本判断
 */
#define isSimulator (NSNotFound != [[[UIDevice currentDevice] model] rangeOfString:@"Simulator"].location)

#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/*
 *@bref 判断字符串是否为nil，若为nil用@""代替
 */
#define SENTENCED_EMPTY(string)    (string = ((string == nil) ? @"":string))

/*
 *@bref 判断网络状态
 */
#define kGetNetStatus       ([[LSReachablity shareInstance] getNetWorkStatus])
#define kSoftwareVersion    ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]) //获取app的版本号
#define kDatabasePath       ([LSHelper getPathWithinDocumentDir:@"/LSDB.sqlite"])

//文件名称
#define kFineName  @"word"

#endif
