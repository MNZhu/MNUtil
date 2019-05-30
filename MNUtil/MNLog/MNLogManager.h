//
//  MNLog.h
//  MNUtil
//
//  Created by jacknan on 2019/4/22.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOG_FILE_MAX_COUNT        4              //日志文件的最大数量
#define LOG_FILE_SIZE             3               //每个日志文件大小 MB

/**
 本地日志宏调用写入方法
 */
#define MNLOG(MNLogLevel,_fmt_, ...) [MNLogManager logwithLevel:MNLogLevel File:__FILE__ Line:__LINE__ string:_fmt_, ##__VA_ARGS__];

#define MNLOG_ERROR(fmt,...)        MNLOG(MNLogLevelError,fmt,##__VA_ARGS__)
#define MNLOG_WARINING(fmt,...)     MNLOG(MNLogLevelWarning,fmt,##__VA_ARGS__)
#define MNLOG_DEBUG(fmt,...)        MNLOG(MNLogLevelDebug,fmt,##__VA_ARGS__)
#define MNLOG_INFO(fmt,...)         MNLOG(MNLogLevelInfo,fmt,##__VA_ARGS__)


typedef NS_OPTIONS(NSUInteger, MNLogLevel) {
    MNLogLevelNone     = 0,     //不输出log
    MNLogLevelDebug,
    MNLogLevelInfo,
    MNLogLevelWarning,
    MNLogLevelError
};


NS_ASSUME_NONNULL_BEGIN

@interface MNLogManager : NSObject

@property (nonatomic, assign) MNLogLevel currentLogLevel;

+ (instancetype)shareInstance;

+ (void)logwithLevel:(MNLogLevel)level File:(const char *)fileName Line:(int)line string:(NSString *)logStr, ... NS_FORMAT_FUNCTION(4, 5);

+ (void)logwithLevel:(MNLogLevel)level File:(const char *)fileName Line:(int)line string:(NSString *)logStr arguments:(va_list)argList NS_FORMAT_FUNCTION(4,0);

/**
 获取所有日志文件的绝对路径 并按照日期升序排序
 
 @return 路径数组 string
 */
+ (NSArray *)getAllAppLogFilePath;

+ (NSString *)getLevelTypeString:(MNLogLevel)level;

+ (NSArray *)logLevels;

@end

NS_ASSUME_NONNULL_END
