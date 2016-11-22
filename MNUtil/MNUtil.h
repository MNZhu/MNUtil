//
//  Util.h
//  MNUtil
//
//  Created by jacknan on 2016/9/19.
//  Copyright © 2016年 jacknan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <sys/utsname.h>
//#import <MJExtension.h>
#import <CommonCrypto/CommonDigest.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#ifdef DEBUG

#define MN_Log(...) NSLog(__VA_ARGS__)
#else
#define MN_Log(...)
#endif


#define MNCOLOR_P3(r,g,b,a) [UIColor colorWithDisplayP3Red:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define MNCOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]



/**
 判断对象是否为空
 */
@interface NSObject(MNObject)
//-(BOOL)isnull;

@property(nonatomic,assign,readonly)BOOL isNonull;
@end


@interface UIImage (MNImage)
+( instancetype _Nonnull)imageWithColor_mn:( UIColor * _Nullable)color;

@end


/**
 MN工具
 */
@interface MNUtil : NSObject



/**
 十进制转十六进制
 */
- (NSString* _Nullable )ToHex:(uint16_t)tmpid;


/**
 *  返回一张可以随意拉伸不变形的图片
 *
 *  @param name 图片名字
 */
+ (UIImage *_Nullable)resizableImage:(NSString *_Nullable)name;


/**
 *  弹出lable提示框并自动消失
 *
 *  @param view 要添加到的view
 *  @param text lable的文字描述
 */
+(void)alertLableWithView:(UIView*_Nullable)view LableText:(NSString*_Nullable)text;


/**
 *  生成二维码
 *
 *  @param text 二维码文字
 *
 *  @return 二维码图片
 */
+(UIImage*_Nullable)barcodeWithText:(NSString *_Nullable)text;

/**
 *  获取文字高度
 *
 *  @param str   文字
 *  @param font  文字字体
 *  @param width 文字显示的最大宽度
 */
+(CGSize)GetHeigntWithStr:(NSString*_Nullable)str font:(UIFont*_Nullable)font maxWidth:(CGFloat)width;

/**
 *  视频转换给mp4格式
 *
 *  @param url           <#url description#>
 *  @param completeBlock <#completeBlock description#>
 *
 *  @return <#return value description#>
 */
//+(void)Videotomp4:(NSString*)url complete:(void(^)(NSString* toPath))completeBlock;


/**
 *  转换视频为mp4格式
 *
 *  @param url           需要转换的url
 *  @param completeBlock 完成调用 topath为输出url  movieImage为第一帧图片
 */
+(void)Videotomp4:(NSString*_Nullable)url complete:(void(^_Nullable)(NSString*_Nullable toPath,UIImage *_Nullable movieImage))completeBlock;

/**
 *  颜色转图片
 *
 */
+(UIImage*_Nullable) createImageWithColor:(UIColor*_Nullable) color;

///获取手机型号
+ (NSString *_Nullable)getiphoneType;

///获取电池电量
+(CGFloat)getBatteryLevel;

///获取系统版本名称
+(NSString* _Nullable)getSystemName;

/**
 获取系统版本
 */
+(NSString* _Nullable)getOSversion;

/**
 获取设备唯一标示

 @return string（uuid）
 */
+ (NSString * _Nullable)getIdentifierForVendor;


/// 获得缓存文件夹路径
+ (NSString * _Nullable)getCachesPath:(NSString *_Nullable)directoryName;

/// 获得文字的尺寸
+ (CGSize)getContentSize:(NSString * _Nullable)content withCGSize:(CGSize)size withFont:(NSFont* _Nullable)font;




/**
 GET请求数据

 @param url          完整url
 @param para         请求参数
 @param successblock 请求成功返回参数
 @param failblock   请求失败返回参数
 */

+(void)GETwithUrl:(NSString* _Nonnull)url param:(NSDictionary* _Nullable)para successBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock FailBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock Progress:(void(^ _Nullable)(NSProgress * _Nonnull downloadProgress)) progressblock;


/**
 POST请求数据
 
 @param url          完整url
 @param para         请求参数
 @param successblock 请求成功返回参数
 @param failblock   请求失败返回参数
 */
+(void)POSTwithUrl:(NSString* _Nonnull)url param:(NSDictionary* _Nullable)para successBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock failBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock Progress:(void(^ _Nullable)(NSProgress * _Nonnull downloadProgress))progressblock;


/**
 POST上传 带data数据

 @param url           完整url
 @param para          请求参数
 @param BodywithBlock data数据block
 @param successblock  请求成功
 @param failblock     请求失败
 @param progressblock 下载进度
 */
+(void)POSTwithUrl:(NSString* _Nonnull)url param:(NSDictionary* _Nullable)para constructingBodyWithBlock:(void(^ _Nullable)(id<AFMultipartFormData>  _Nonnull formData))BodywithBlock successBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock failBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock Progress:(void(^ _Nullable)(NSProgress * _Nonnull downloadProgress))progressblock;


/**
 DELETE请求

 @param url          完整url
 @param para         请求参数
 @param successblock 完成回调
 @param failblock    失败回调
 */
+(void)DELETEwithUrl:(NSString* _Nonnull)url param:(NSDictionary* _Nullable)para uccessBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock failBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock;


/**
 PUT请求

 @param url          完整url
 @param para         请求参数
 @param successblock 完成回调
 @param failblock    失败回调
 */
+(void)PUTwithUrl:(NSString * _Nonnull)url param:(NSDictionary* _Nullable)para uccessBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nonnull task,id _Nullable ResponseData))successblock failBlock:(void(^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failblock;
@end


@interface UIImage (RoundRectImage)
- (UIImage *_Nullable)roundRectWithRadius:(NSInteger)r;
@end

@interface UIView (Additions)
-(UIViewController *_Nullable)viewController;
@end

@interface NSDictionary (WG)
-(NSString*_Nullable)json;
@end

@interface UIButton (Text)
@property (strong,nonatomic) NSString * _Nullable text;
@end




@interface NSString (Extensin)
- (NSString *_Nullable) md5Withstring:(NSString*_Nullable)sstr;
- (NSString *_Nullable) trim;
- (BOOL) isEmpty;
- (NSDictionary *_Nullable) parseJson;
-(NSString*_Nullable)date;
-(NSString*_Nullable)date1;
-(NSString*_Nullable)dateAndTime;
- (BOOL)isMobileNumber;
@end

