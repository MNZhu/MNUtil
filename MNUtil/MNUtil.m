//
//  Util.m
//  MNUtil
//
//  Created by jacknan on 2016/9/19.
//  Copyright © 2016年 jacknan. All rights reserved.
//
//1.手机系统：iPhone OS
//
//NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
//
//2.手机类型：iPhone 6
//
//NSString* phoneModel = [Function iphoneType];//方法在下面
//
//3.手机系统版本：9.1
//
//NSString * iponeM = [[UIDevice currentDevice] systemName];
//
//4.电池电量
//
//CGFloat batteryLevel=[[UIDevicecurrentDevice]batteryLevel];
//
//文／天明依旧（简书作者）
//原文链接：http://www.jianshu.com/p/02bba9419df8


#import "MNUtil.h"



@implementation NSObject(MNObject)

/**
 判断object是否为空
 @return 返回是-为空 否-不为空
 */
-(BOOL)isNonull
{
    if ([self isEqual:[NSNull null]]||(self == nil)||[self isEqual:NULL]) {
        return NO;
    }
    
    return YES;
}

@end


@implementation MNUtil





/**
 *  弹出lable提示框并自动消失
 *
 *  @param view 要添加到的view
 *  @param text lable的文字描述
 */
+(void)alertLableWithView:(UIView*_Nullable)view LableText:(NSString*_Nullable)text
{
    UIFont *font = [UIFont systemFontOfSize:17];  //文字font
    
    //获取屏幕尺寸
    CGRect rect = [UIScreen mainScreen].bounds;
    
    //获取文字尺寸
    NSDictionary *atrr = @{NSFontAttributeName:font};
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:atrr context:nil].size;
    //屏幕中间弹出的临时提示框 并自动消失
    
    // 1.添加标签
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor blackColor];
    label.frame = CGRectMake(0, 0, size.width + 40 , size.height + 15);
    label.center = CGPointMake(rect.size.width * 0.5, rect.size.height * 0.5 + 100);
    label.alpha = 0.0;
    label.layer.cornerRadius = 10;
    label.clipsToBounds = YES;
    [view addSubview:label];
    
    // 2.动画
    [UIView animateWithDuration:0.5 animations:^{
        
        label.alpha = 0.6;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.alpha = 0.0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
    
}

/**
 *  生成二维码
 *
 *  @param text 二维码文字
 *
 *  @return 二维码图片
 */
+(UIImage*_Nullable)barcodeWithText:(NSString *_Nullable)text
{
    //1.创建一个滤镜对象
    CIFilter *ft = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //2.设置相关属性
    [ft setDefaults];
    
    //3.设置输入数据
    NSString *inputd = @"http://so.com";
    NSData *dat = [inputd dataUsingEncoding:NSUTF8StringEncoding];
    [ft setValue:dat forKeyPath:@"inputMessage"];
    
    //4.输入二维码图片
    CIImage *image = [ft outputImage];
    
    //5.1模糊(不用此方法)
    //    self.imgview.image = [UIImage imageWithCIImage:img];
#pragma mark - 二维码清晰度
    CGFloat size = 400;    //设置二维码清晰度
    
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    //转换为oc对象
    UIImage *img = [UIImage imageWithCGImage:scaledImage];
    
    //释放
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    CGImageRelease(scaledImage);
    
    return img;
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    //转换为oc对象
    UIImage *img = [UIImage imageWithCGImage:scaledImage];
    
    //释放
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    CGImageRelease(scaledImage);
    
    
    
    return img;
}

/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *_Nullable)resizableImage:(NSString *_Nullable)name
{
    UIImage *normal = [UIImage imageNamed:name];
    CGFloat w = normal.size.width * 0.5;
    CGFloat h = normal.size.height * 0.5;
    return [normal resizableImageWithCapInsets:UIEdgeInsetsMake(h, w, h, w)];
}



+(CGSize)GetHeigntWithStr:(NSString*_Nullable)str font:(UIFont*_Nullable)font maxWidth:(CGFloat)width
{
    //输入一段文字text，设置文字的显示宽度和高度-maxsize  文字属性 attrs
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return  [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


+(void)Videotomp4:(NSString*_Nullable)url complete:(void(^_Nullable)(NSString* toPath,UIImage *_Nullable movieImage))completeBlock
{
    NSURL *file = [NSURL fileURLWithPath:url];
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:file options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSLog(@"compatiblePresets:%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        //        NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
        //
        //        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        NSString * resultPath = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/temvideo.mp4"];
        
        NSFileManager *ma = [NSFileManager defaultManager];
        [ma removeItemAtPath:resultPath error:nil];
        
        
        
        NSLog(@"转换压缩输出路径 = %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     NSLog(@"AVAssetExportSessionStatusExporting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     NSURL *videourl = [NSURL fileURLWithPath:url];
                     AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videourl options:nil];
                     AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
                     generator.appliesPreferredTrackTransform = TRUE;
                     CMTime thumbTime = CMTimeMakeWithSeconds(0, 60);
                     generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
                     AVAssetImageGeneratorCompletionHandler generatorHandler =
                     ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
                         if (result == AVAssetImageGeneratorSucceeded) {
                             UIImage *thumbImg = [UIImage imageWithCGImage:im];
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 completeBlock(resultPath,thumbImg);
                             });
                             
                             
                         }
                     };
                     [generator generateCGImagesAsynchronouslyForTimes:
                      [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:generatorHandler];
                     
                     
                     
                     
                 }
                     
                     
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     
                     NSLog(@"AVAssetExportSessionStatusFailed");
                     
                     break;
                 case AVAssetExportSessionStatusCancelled:
                     NSLog(@"AVAssetExportSessionStatusCancelled");
                     break;
             }
             
         }];
        
        
    }
    
}

////获取视频第一帧的图片
//- (void)movieToImageHandler:(void (^)(UIImage *movieImage))handler {
//    NSURL *url = [NSURL fileURLWithPath:self.videoPath];
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
//    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    generator.appliesPreferredTrackTransform = TRUE;
//    CMTime thumbTime = CMTimeMakeWithSeconds(0, 60);
//    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
//    AVAssetImageGeneratorCompletionHandler generatorHandler =
//    ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
//        if (result == AVAssetImageGeneratorSucceeded) {
//            UIImage *thumbImg = [UIImage imageWithCGImage:im];
//            if (handler) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    handler(thumbImg);
//                });
//            }
//        }
//    };
//    [generator generateCGImagesAsynchronouslyForTimes:
//     [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:generatorHandler];
//}



/* 获取对象的所有属性和属性内容 */
- (NSDictionary *)getAllPropertiesAndVaules
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}
/* 获取对象的所有属性 */
- (NSArray *)getAllProperties
{
    u_int count;
    
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}
/* 获取对象的所有方法 */
-(void)getAllMethods
{
    unsigned int mothCout_f =0;
    Method* mothList_f = class_copyMethodList([self class],&mothCout_f);
    for(int i=0;i<mothCout_f;i++)
    {
        Method temp_f = mothList_f[i];
//        IMP imp_f = method_getImplementation(temp_f);
//        SEL name_f = method_getName(temp_f);
        const char* name_s =sel_getName(method_getName(temp_f));
        int arguments = method_getNumberOfArguments(temp_f);
        const char* encoding =method_getTypeEncoding(temp_f);
        NSLog(@"方法名：%@,参数个数：%d,编码方式：%@",[NSString stringWithUTF8String:name_s],
              arguments,
              [NSString stringWithUTF8String:encoding]);
    }
    free(mothList_f);
}


/**
 *  颜色转图片
 *
 */
+(UIImage*_Nullable) createImageWithColor:(UIColor*_Nullable) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



+(NSString* _Nullable)getOSversion
{
    return [[UIDevice currentDevice] systemVersion];
}

+(NSString* _Nullable)getSystemName
{
    return [[UIDevice currentDevice] systemName];
}

+(CGFloat)getBatteryLevel
{
    return [[UIDevice currentDevice] batteryLevel];
}


+ (NSString *_Nullable)getiphoneType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"]) return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"]) return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"]) return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"]) return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"]) return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"]) return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"]) return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"]) return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"]) return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"]) return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"]) return @"iPad Mini 2G";

    if ([platform isEqualToString:@"iPad4,6"]) return @"iPad Mini 2G";

    if ([platform isEqualToString:@"i386"]) return @"iPhone Simulator";

    if ([platform isEqualToString:@"x86_64"]) return @"iPhone Simulator";
    
    return platform;
    
}



/// 获得设备号
+ (NSString * _Nullable)getIdentifierForVendor
{
    NSUUID *uid = [[UIDevice currentDevice] identifierForVendor];
    return [uid UUIDString];
}

/// 获取caches目录下文件夹路径
+ (NSString *)getCachesPath:(NSString *)directoryName
{
    NSString *cachesDirectory = NSHomeDirectory();
    
    return [cachesDirectory stringByAppendingPathComponent:directoryName];
}

/// 获得文字的尺寸
+ (CGSize )getContentSize:(NSString *_Nullable)content withCGSize:(CGSize)size withFont:(NSFont*_Nullable)font
{
    CGRect contentBounds = [content boundingRectWithSize:size
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:[NSDictionary dictionaryWithObject:font
                                                                                     forKey:NSFontAttributeName]
                                                 context:nil];
    return contentBounds.size;
}

///// 获得缓存文件夹路径
//+ (NSString * _Nullable)getCachesDirPath:(NSString *_Nullable)cachesDir
//{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSString *libraryDirectory = NSHomeDirectory();
//    NSString *imageDir = [NSString stringWithFormat:@"%@/Caches/%@/", libraryDirectory, cachesDir];
//    BOOL isDir = NO;
//    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
//    if (!(isDir == YES && existed == YES))
//    {
//        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
//    }
//    
//    return imageDir;
//}


/**
 GET请求数据

 @param url          完整url
 @param para         请求参数
 @param successblock 请求成功返回参数
 @param failblock   请求失败返回参数
 */
+(void)GETwithUrl:(NSString* _Nonnull)url Param:(NSDictionary* _Nullable)para successBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock FailBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock Progress:(void(^ _Nullable)(NSProgress * _Nonnull downloadProgress)) progressblock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //下载json
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager GET:url parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        progressblock(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id data = [responseObject mj_JSONObject];
        successblock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failblock(task,error);
        NSLog(@"get请求出错了error:%@",error);
    }];
    
}


+(void)POSTwithUrl:(NSString* _Nonnull)url param:(NSDictionary* _Nullable)para successBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock failBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock Progress:(void(^ _Nullable)(NSProgress * _Nonnull downloadProgress))progressblock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //下载json
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        progressblock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id data = [responseObject mj_JSONObject];
        successblock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failblock(task,error);
        NSLog(@"post请求出错了error:%@",error);
    }];
}

+(void)POSTwithUrl:(NSString* _Nonnull)url param:(NSDictionary* _Nullable)para constructingBodyWithBlock:(void(^ _Nullable)(id<AFMultipartFormData>  _Nonnull formData))BodywithBlock successBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock failBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock Progress:(void(^ _Nullable)(NSProgress * _Nonnull downloadProgress))progressblock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //下载json
    manager.requestSerializer.timeoutInterval = 10.0f;
    
    [manager POST:url parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        BodywithBlock(formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressblock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id data = [responseObject mj_JSONObject];
        successblock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failblock(task,error);
    }];
    
}

+(void)DELETEwithUrl:(NSString* _Nonnull)url param:(NSDictionary* _Nullable)para uccessBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock failBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //下载json
    manager.requestSerializer.timeoutInterval = 5.0f;
    [manager DELETE:url parameters:para success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successblock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failblock(task,error);
    }];
}

+(void)PUTwithUrl:(NSString * _Nonnull)url param:(NSDictionary* _Nullable)para uccessBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock failBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer]; // 上传普通格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; //下载json
    manager.requestSerializer.timeoutInterval = 10.0f;
    [manager PUT:url parameters:para success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successblock(task,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failblock(task,error);
    }];
}

@end
@implementation NSString (Extensin)

- (NSString *_Nullable) md5Withstring:(NSString*_Nullable)sstr
{
    NSString * str = nil;
    if (sstr) {
        str = [self stringByAppendingString:sstr];
    }
    
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result ); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *_Nullable) trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL) isEmpty
{
    return self.length == 0;
}

- (NSDictionary *_Nullable) parseJson
{
    NSData *da= [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:da options:NSJSONReadingMutableLeaves error:&error];
    return data;
}

-(NSString*_Nullable)date
{
    NSDate *dt=[NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy年MM月dd日"];
    return [format stringFromDate:dt];
}

-(NSString*_Nullable)date1
{
    NSDate *dt=[NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    return [format stringFromDate:dt];
}

-(NSString*_Nullable)dateAndTime
{
    NSDate *dt=[NSDate dateWithTimeIntervalSince1970:[self integerValue]];
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd hh:mm"];
    return [format stringFromDate:dt];
}

-(BOOL)isMobileNumber{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188,1705
     * 联通：130,131,132,152,155,156,185,186,1709
     * 电信：133,1349,153,180,189,1700
     */
    NSString * MOBILE = @"^1\\d{10}$";
    
    // 移动
    //    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d|705)\\d{7}$";
    
    // 联通
    //    NSString * CU = @"^1((3[0-2]|5[256]|8[56])\\d|709)\\d{7}$";
    
    // 电信
    //    NSString * CT = @"^1((33|53|8[09])\\d|349|700)\\d{7}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}
@end

@implementation UIImage (RoundRectImage)
void addRoundRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                        float ovalHeight){
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0){
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

- (UIImage *_Nullable)roundRectWithRadius:(NSInteger)r{
    int w = self.size.width;
    int h = self.size.height;
    
    UIImage *img = self;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundRectToPath(context, rect, r, r);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    
    return img;
}
@end

@implementation UIView (Additions)
-(UIViewController *_Nullable)viewController
{
    UIViewController *vc=nil;
    for(id response=self;response;response=[response nextResponder])
    {
        if([response isKindOfClass:[UIViewController class]])
        {
            vc=response;
            break;
        }
    }
    return vc;
}

@end

@implementation NSDictionary (WG)

-(NSString*_Nullable)json
{
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end

@implementation UIButton (Text)
-(NSString*_Nullable)text
{
    NSString *str=[self titleForState:UIControlStateNormal];
    if(str==nil)
    {
        str=@"";
    }
    return str;
}

-(void)setText:(NSString *_Nullable)text
{
    [self setTitle:text forState:UIControlStateNormal];
}


@end
