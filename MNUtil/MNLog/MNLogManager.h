//
//  MNLog.h
//  MNUtil
//
//  Created by jacknan on 2019/4/22.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_FILE_MAX_SIZE        10 //MB  日志本地存储的最大值
#define App_Current_Log_Level    MNLogLevelInfo  //当前日志等级

/**
 本地日志宏调用写入方法
 */
#define MNLOG(MNLogLevel,_fmt_, ...) [MNLogManager logwithLevel:MNLogLevel File:__FILE__ Line:__LINE__ string:_fmt_, ##__VA_ARGS__];

#define MNLOG_ERROR(fmt,...)        MNLOG(MNLogLevelError,fmt,##__VA_ARGS__)
#define MNLOG_WARINING(fmt,...)     MNLOG(MNLogLevelWarning,fmt,##__VA_ARGS__)
#define MNLOG_DEBUG(fmt,...)        MNLOG(MNLogLevelDebug,fmt,##__VA_ARGS__)
#define MNLOG_INFO(fmt,...)         MNLOG(MNLogLevelInfo,fmt,##__VA_ARGS__)


typedef NS_OPTIONS(NSUInteger, MNLogLevel) {
    MNLogLevelDebug    = 1 << 0,
    MNLogLevelInfo     = 1 << 1,
    MNLogLevelWarning  = 1 << 2,
    MNLogLevelError    = 1 << 3
};


NS_ASSUME_NONNULL_BEGIN

@interface MNLogManager : NSObject

+ (instancetype)shareInstance;

+ (void)logwithLevel:(MNLogLevel)level File:(const char *)fileName Line:(int)line string:(NSString *)logStr, ... NS_FORMAT_FUNCTION(4, 5);

+ (void)logwithLevel:(MNLogLevel)level File:(const char *)fileName Line:(int)line string:(NSString *)logStr arguments:(va_list)argList NS_FORMAT_FUNCTION(4,0);
@end

NS_ASSUME_NONNULL_END
