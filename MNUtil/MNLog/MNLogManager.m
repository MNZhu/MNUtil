//
//  MNLog.m
//  MNUtil
//
//  Created by jacknan on 2019/4/22.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import "MNLogManager.h"
#import <UIKit/UIKit.h>
#define LOG_DIRECTORY [NSString stringWithFormat:@"%@/Documents/AppLog",NSHomeDirectory()]
#define DATE [[MNLogManager shareInstance] getDate]

NSString * _Nullable const LevelDsc[] = {
    [MNLogLevelNone] = @"None",
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
@property (nonatomic, strong) NSString *currentLogFilePath;
@property (nonatomic, strong) NSDictionary *levelDic;
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
                      NSNumber *num = [NSUserDefaults.standardUserDefaults objectForKey:@"AppLogLevel"];
                      _instance.currentLogLevel = num.unsignedIntegerValue;
                      _instance.queue = dispatch_queue_create("MNLogManager", DISPATCH_QUEUE_SERIAL);
                      _instance.levelDic = @{[NSString stringWithFormat:@"%lu",(unsigned long)MNLogLevelNone]:@"None",
                                             [NSString stringWithFormat:@"%lu",(unsigned long)MNLogLevelDebug]:@"Debug",
                                             [NSString stringWithFormat:@"%lu",(unsigned long)MNLogLevelInfo]:@"Info",
                                             [NSString stringWithFormat:@"%lu",(unsigned long)MNLogLevelWarning]:@"Warning",
                                             [NSString stringWithFormat:@"%lu",(unsigned long)MNLogLevelError]:@"Error"
                                                                  };
                  });
    return _instance;
}

+ (NSString *)getLevelTypeString:(MNLogLevel)level
{
    return LevelDsc[level];
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
    if (level == MNLogLevelNone) {
        return;
    }
    NSString *context = [[NSString alloc] initWithFormat:logStr arguments:argList];
    MNLogManager *tool = [MNLogManager shareInstance];
    dispatch_barrier_async(tool.queue, ^{
        NSString *levelStr = [self getLevelTypeString:level];
        NSString *fileNameStr = [NSString stringWithUTF8String:fileName].lastPathComponent;
        NSString *outPutStr = [NSString stringWithFormat:@"\n[%@][%@ %@ LINE:%d] %@",levelStr,DATE,fileNameStr,line,context];
        
        fprintf(stdout,"%s\n",outPutStr.UTF8String);
        if (level >= tool.currentLogLevel)
        {
            [tool writeLog:outPutStr];
        }
    });
}

/**
 获取所有日志文件的绝对路径 并按照日期升序排序

 @return 路径数组 string
 */
+ (NSArray *)getAllAppLogFilePath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:LOG_DIRECTORY];
    NSString *fileName;
    NSMutableArray *filePaths = [NSMutableArray array];
    while (fileName = [dirEnum nextObject]) {
        [filePaths addObject:[LOG_DIRECTORY stringByAppendingPathComponent:fileName]];
    }
    return [filePaths sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
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
        NSFileManager *ma = [NSFileManager defaultManager];
        BOOL isDirectory = YES;
        if (![ma fileExistsAtPath:LOG_DIRECTORY isDirectory:&isDirectory]) {
            [ma createDirectoryAtPath:LOG_DIRECTORY withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        self.fileManager = [NSFileManager defaultManager];
        NSLog(@"logFileDirectory:%@",LOG_DIRECTORY);
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(closeFile) name:UIApplicationWillTerminateNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(closeFile) name:UIApplicationDidEnterBackgroundNotification object:nil];
        self.syncNum = 0;
    }
    return self;
}

- (void)closeFile
{
    typeof(self) weakSelf = self;
    dispatch_barrier_async(self.queue, ^{
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

- (void)createLogFile
{
    [self closeFile];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd_HHmmss"];
    NSString *fileName = [[formatter stringFromDate:NSDate.date] stringByAppendingString:@".log"];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",LOG_DIRECTORY,fileName];
    if ([self.fileManager createFileAtPath:filePath contents:nil attributes:nil]) {
        self.currentLogFilePath = filePath;
        _fileHandle = nil;
    }
}

/**
 检测日志文件
 创建日志文件、删除旧日志文件
 */
- (void)CheckLocalLogFile
{
    NSArray *logFilePaths = [[MNLogManager getAllAppLogFilePath] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //获取当前日志文件
    if (self.currentLogFilePath) {
        if ([[self.fileManager attributesOfItemAtPath:self.currentLogFilePath error:nil] fileSize] >= LOG_FILE_SIZE * 1024 * 1024) {
            [self createLogFile];
        }
    }else{
        _fileHandle = nil;
        if (logFilePaths.count == 0) {
            [self createLogFile];
        }else{
            NSString *filePath = logFilePaths.lastObject;
            if ([[self.fileManager attributesOfItemAtPath:filePath error:nil] fileSize] < LOG_FILE_SIZE * 1024 * 1024) {
                self.currentLogFilePath = filePath;
            }else{
                [self createLogFile];
            }
        }
    }
    
    //删除太旧的日志文件
    NSInteger count = (NSInteger)logFilePaths.count - LOG_FILE_MAX_COUNT;
    for (int i=0; i<count; i++) {
        NSString *filePath = logFilePaths[i];
        [self.fileManager removeItemAtPath:filePath error:nil];
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
        _fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.currentLogFilePath];
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

- (MNLogLevel)currentLogLevel
{
    NSNumber *num = [NSUserDefaults.standardUserDefaults objectForKey:@"AppLogLevel"];
    if (num) {
        return num.integerValue;
    }
    return _currentLogLevel;
}

+ (NSArray *)logLevels
{
    NSMutableArray *arr = NSMutableArray.array;
    for (int i=0; i<5; i++) {
        [arr addObject:LevelDsc[i]];
    }
    return arr;
}

@end
