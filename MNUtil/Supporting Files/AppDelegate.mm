//
//  AppDelegate.m
//  MNUtil
//
//  Created by jacknan on 2016/9/19.
//  Copyright © 2016年 jacknan. All rights reserved.
//
#import "BaseTabBarViewController.h"
#import "AppDelegate.h"
#import <CrashReporter/CrashReporter.h>
#import <CrashReporter/PLCrashReportTextFormatter.h>
#import <Aspects/Aspects.h>
#import <MJExtension/MJExtension.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


/**
 检查app版本
 */
-(void)versionSet
{
    //判断是否首次使用app
    NSString *key = (NSString *)kCFBundleVersionKey;
    // 1.从Info.plist中取出版本号
    NSString *version = [NSBundle mainBundle].infoDictionary[key];
    MNLog(@"*************当前app版本为:%@ ****************",version);
    
    NSString *saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    MNLog(@"*************之前app版本为:%@ ****************",version);
    
    if ([version isEqualToString:saveVersion])
    {
        
        //        // 不是第一次使用这个版本
        //        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else
    {
        
        // 版本号不一样：第一次使用新版本
        // 将新版本号写入沙盒
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        
    }
}

- (void)handleCrashReport
{
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSData *crashData;
    NSError *error;
    
    // Try loading the crash report
    crashData = [crashReporter loadPendingCrashReportDataAndReturnError:&error];
    if (crashData == nil)
    {
        NSLog(@"Could not load crash report: %@", error);
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    // We could send the report from here, but we'll just print out some debugging info instead
    PLCrashReport *report = [[PLCrashReport alloc] initWithData:crashData error:&error];
    if (report == nil)
    {
        NSLog(@"Could not parse crash report");
        [crashReporter purgePendingCrashReport];
        return;
    }
    
    //TODO:send the report
    NSLog(@"Crashed on %@", report.systemInfo.timestamp);
//    NSLog(@"Crashed with signal %@ (code %@, address=0x%" PRIx64 ")", report.signalInfo.name, report.signalInfo.code, report.signalInfo.address);
    NSString *humanReadText = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:PLCrashReportTextFormatiOS];
//    NSLog(@"Crashed Format Text %@", humanReadText);
    
    [crashReporter purgePendingCrashReport];
}

void post_callback(siginfo_t *info, ucontext_t *uap, void *context)
{
    printf("%s",context);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
//    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    BaseTabBarViewController *vc = [[BaseTabBarViewController alloc]init];
//    [_window setRootViewController:vc];
//    [_window makeKeyAndVisible];
//
//    //版本检测
//    [self versionSet];

//    PLCrashReporterConfig *config = [[PLCrashReporterConfig alloc] initWithSignalHandlerType: PLCrashReporterSignalHandlerTypeMach
//                                                                       symbolicationStrategy: PLCrashReporterSymbolicationStrategyNone];
//    PLCrashReporter *crashReporter = [[PLCrashReporter alloc] initWithConfiguration:config];
//    PLCrashReporterCallbacks callback = {
//        .version = 0,
//        .context = (void *) 0xABABABAB,
//        .handleSignal = post_callback
//    };
//    [crashReporter setCrashCallbacks:&callback];
//    NSError *error;
//    // Check if we previously crashed
//    if ([crashReporter hasPendingCrashReport])
//    {
//        [self handleCrashReport];
//    }
//    // Enable the Crash Reporter
//    if (![crashReporter enableCrashReporterAndReturnError: &error])
//    {
//        NSLog(@"Warning: Could not enable crash reporter: %@", error);
//    }
//
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
