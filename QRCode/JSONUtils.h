//
//  JSONUtils.h
//  cloudoor
//
//  Created by dhf on 15/4/25.
//  Copyright (c) 2015年 Cloudoor Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONUtils : NSObject

+ (NSString *)toJSONString:(id)obj;

+ (NSDictionary *)toDictionary:(id)obj;

+ (id)fromJSONString:(NSString *)jsonStr class:(Class)clazz;

+ (id)fromDictionary:(NSDictionary *)dict class:(Class)clazz;

+ (NSArray *)fromArray:(NSArray *)array class:(Class)clazz;

@end
