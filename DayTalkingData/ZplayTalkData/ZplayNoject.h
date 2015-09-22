//
//  ZplayNoject.h
//  ZPLAY_advDemo
//
//  Created by Mac on 14-11-28.
//  Copyright (c) 2014年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif



@interface ZplayNoject : NSObject

+(ZplayNoject*)shareInstance;
/**/
-(NSString *)findIdfa;
/**/
-(NSString *)findMacAddress;
/**/
-(NSString *)findPLMNCode;
/**/
-(BOOL)isHaveConnect;
/**/
-(NSString *)findValueFromePlist:(NSString *)plist withKey:(NSString*)key;
/**/
-(BOOL)prejudgeIsHaveClassFrome:(NSString *)className;
/**/
-(NSString *)findVersion;
/**/
-(NSData *)compoundJSONData:(NSDictionary *)dic;

-(NSString *)signUrlStrWith:(NSDictionary *)dic;
@end
