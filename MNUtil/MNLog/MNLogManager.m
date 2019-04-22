//
//  MNLog.m
//  MNUtil
//
//  Created by jacknan on 2019/4/22.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "MNLogManager.h"
#import <UIKit/UIKit.h>

#define LOG_DIRECTORY [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()]
#define DATE [[MNLogManager shareInstance] getDate]

NSString * const LevelDsc[] = {
    [MNLogLevelDebug] = @"Debug",
    [MNLogLevelInfo] = @"Info",
    [MNLogLevelWarning] = @"Warning",
    [MNLogLevelError] = @"Error"
};

@interface MNLogManager ()
@property (nonatomic, assign) int syncNum;
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSFileHandle *fileHandle;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSFileManager *fileManager;
@property (nonatomic, strong) NSString *logFilePath;
@property (nonatomic, strong) NSString *oldLogFilePath;
@end

@implementation MNLogManager
#pragma mark - class method
+ (instancetype)shareInstance
{
    static dispatch_once_t once;
    static MNLogManager *_instance = nil;
    dispatch_once(&once,
                  ^() {
                      _instance = [[MNLogManager alloc] init];
                      _instance.queue = dispatch_queue_create("MNLogManager", DISPATCH_QUEUE_SERIAL);
                  });
    return _instance;
}

+ (NSString *)getLevelTypeString:(MNLogLevel)level
{
    return LevelDsc[level];
}

+ (void)logwithString:(NSString *)logStr Level:(MNLogLevel)level
{
    MNLOG(level, @"%@",logStr)
}

+ (void)logwithLevel:(MNLogLevel)level File:(const char *)fileName Line:(int)line string:(NSString *)logStr, ...
{
    va_list ap;
    va_start(ap, logStr);
    [MNLogManager logwithLevel:level File:fileName Line:line string:logStr arguments:ap];
    va_end(ap);
}

+ (void)logwithLevel:(MNLogLevel)level File:(const char *)fileName Line:(int)line string:(NSString *)logStr arguments:(va_list)argList
{
    NSString *context = [[NSString alloc] initWithFormat:logStr arguments:argList];
    MNLogManager *tool = [MNLogManager shareInstance];
    dispatch_barrier_async(tool.queue, ^{
        NSString *levelStr = [self getLevelTypeString:level];
        NSString *fileNameStr = [NSString stringWithUTF8String:fileName].lastPathComponent;
        NSString *outPutStr = [NSString stringWithFormat:@"\n[%@][%@ %@ LINE:%d] %@",levelStr,DATE,fileNameStr,line,context];
        
        fprintf(stdout,"%s\n",outPutStr.UTF8String);
        if (level >= App_Current_Log_Level)
        {
            [tool writeLog:outPutStr];
        }
    });
}

#pragma mark - instance method

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.logFilePath = [NSString stringWithFormat:@"%@/APP.log",LOG_DIRECTORY];
        self.oldLogFilePath = [NSString stringWithFormat:@"%@/app_old.log",LOG_DIRECTORY];
        self.fileManager = [NSFileManager defaultManager];
        NSLog(@"logFilePath:%@",self.logFilePath);
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(closeFile) name:UIApplicationWillTerminateNotification object:nil];
//        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(closeFile) name:UIApplicationDidEnterBackgroundNotification object:nil];
        self.syncNum = 0;
    }
    return self;
}

- (void)closeFile
{
    typeof(self) weakSelf = self;
    
    dispatch_barrier_async(self.queue, ^{
        NSData *data = [@"\n\n--------------- exit! --------------\n" dataUsingEncoding:NSUTF8StringEncoding];
        [weakSelf.fileHandle seekToEndOfFile];
        [weakSelf.fileHandle writeData:data];
        [weakSelf.fileHandle synchronizeFile];
        [weakSelf.fileHandle closeFile];
        weakSelf.fileHandle = nil;
    });
}

- (void)writeLog:(NSString *)logStr
{
    NSData *data = [logStr dataUsingEncoding:NSUTF8StringEncoding];
    [self CheckLocalLogFile];
    [self.fileHandle seekToEndOfFile];
    [self.fileHandle writeData:data];
    self.syncNum ++;
    if (self.syncNum >= 50)
    {
        [self.fileHandle synchronizeFile];
        self.syncNum = 0;
    }
}

/**
 检测日志文件
 创建日志文件、删除旧日志文件
 */
- (void)CheckLocalLogFile
{
    //检查磁盘剩余空间
//    NSDictionary *fattributes = [self.fileManager attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
//    NSNumber *freeSize = [fattributes objectForKey:NSFileSystemFreeSize];
//    if (freeSize.floatValue < 1000) {
//        NSData *data = [@"\n磁盘剩余空间不足,无法写入日志!" dataUsingEncoding:NSUTF8StringEncoding];
//        [self.fileHandle seekToEndOfFile];
//        [self.fileHandle writeData:data];
//        [self closeFile];
//    }
    
    //创建日志文件
    if (![_fileManager fileExistsAtPath:self.logFilePath])
    {
        if ([_fileManager createFileAtPath:self.logFilePath contents:nil attributes:nil])
        {
            _fileHandle = nil;
            return;
        }
    }
    
    //检查log文件大小
    if ([_fileManager attributesOfItemAtPath:self.logFilePath error:nil].fileSize >= LOG_FILE_MAX_SIZE * 1024 * 1024 * 0.5)
    {
        if ([_fileManager fileExistsAtPath:self.oldLogFilePath])
        {
            [_fileManager removeItemAtPath:self.oldLogFilePath error:nil];
        }
        [_fileManager copyItemAtPath:self.logFilePath toPath:self.oldLogFilePath error:nil];
        [_fileManager removeItemAtPath:self.logFilePath error:nil];
        
        [self CheckLocalLogFile];
    }
}

#pragma mark - lazy
- (NSString *)getDate
{
    NSDate *date = [NSDate date];
    NSString *strDate = [self.dateFormatter stringFromDate:date];
    return strDate;
}

- (NSFileHandle *)fileHandle
{
    if (!_fileHandle)
    {
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.logFilePath];
    }
    return _fileHandle;
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"YYYY-MM-dd HH:mm:sssss";
    }
    return _dateFormatter;
}

@end
