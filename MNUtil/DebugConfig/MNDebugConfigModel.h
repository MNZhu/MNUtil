//
//  MNConfigModel.h
//  MNUtil
//
//  Created by jacknan on 2019/4/23.
//  Copyright © 2019 jacknan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ConfigType) {
    ConfigTypeNone,
    ConfigTypeTextField,
    ConfigTypeLabel,
    ConfigTypeSwitch,
    ConfigTypeArrow
};

NS_ASSUME_NONNULL_BEGIN

@interface MNDebugConfigModel : NSObject
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) id value;
@property (nonatomic, assign) ConfigType type;

@end

NS_ASSUME_NONNULL_END
