//
//  JSONUtils.m
//  cloudoor
//
//  Created by dhf on 15/4/25.
//  Copyright (c) 2015年 Cloudoor Technology Co.,Ltd. All rights reserved.
//

#import "JSONUtils.h"
#import <OCMapper.h>

#import "OCMapperConfig.h"

@implementation JSONUtils

+ (NSString *)toJSONString:(id)obj {
    id jsonObj = [[self objMapper] dictionaryFromObject:obj];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:0 error:&error];
    if (error) {
        DDLogError(@"serialized to json string fail: %@", error);
        return nil;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+ (id)fromJSONString:(NSString *)jsonStr class:(Class)clazz {
    if (jsonStr.length == 0) {
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        DDLogError(@"deserialized from json string fail: %@", error);
        return nil;
    }
    if ([jsonObj isKindOfClass:clazz]) {
        return jsonObj;
    }
    id obj = [[self objMapper] objectFromSource:jsonObj toInstanceOfClass:clazz];
    return obj;
}

+ (NSDictionary *)toDictionary:(id)obj {
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    }
    return [obj dictionary];
}

+ (id)fromDictionary:(NSDictionary *)dict class:(Class)clazz {
    if (!dict) {
        return nil;
    }
    if ([dict isKindOfClass:clazz]) {
        return dict;
    }
    return [[self objMapper] objectFromSource:dict
                                  toInstanceOfClass:clazz];
}

+ (NSArray *)fromArray:(NSArray *)array class:(Class)clazz {
    if (!array) {
        return nil;
    }
    return [[self objMapper] objectFromSource:array toInstanceOfClass:clazz];
}

+ (ObjectMapper *)objMapper {
    static NSCache *objMappers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objMappers = [[NSCache alloc] init];
        objMappers.countLimit = 20;
    });
    
    NSThread *currentThread = [NSThread currentThread];
    NSString *threadKey = [NSString stringWithFormat:@"thread-%zd", currentThread.hash];
    ObjectMapper *mapper = [objMappers objectForKey:threadKey];
    if (!mapper) {
        mapper = [[ObjectMapper alloc] init];
        if (!mapper) {
            return nil;
        }
        [OCMapperConfig configObjMapper:mapper];
        
        [objMappers setObject:mapper forKey:threadKey];
    }
    return mapper;
}
@end
