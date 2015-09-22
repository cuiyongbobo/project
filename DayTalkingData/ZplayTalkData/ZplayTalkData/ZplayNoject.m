//
//  ZplayNoject.m
//  ZPLAY_advDemo
//
//  Created by Mac on 14-11-28.
//  Copyright (c) 2014年 MAC. All rights reserved.
//

#import "ZplayNoject.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>
#import <CommonCrypto/CommonDigest.h>



@implementation ZplayNoject


+(ZplayNoject*)shareInstance
{
    static  ZplayNoject*instance = nil;
    if (instance==NULL) {
        instance=[[ZplayNoject alloc]init];
    }
    
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

#pragma mark - 获取plist信息根据Key
-(NSString *)findValueFromePlist:(NSString *)plist withKey:(NSString*)key
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:plist ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *str=nil;
    if (!mDic) {
        str=@"";
    }else{
    str=[mDic objectForKey:key];
    }


    return str;
}
#pragma mark - 通过类名判断类是否存在
-(BOOL)prejudgeIsHaveClassFrome:(NSString *)className
{
    Class cObject=NSClassFromString(className);
    if (cObject) {
        return YES;
    }
    return NO;
}



#pragma mark - 获得mac地址
-(NSString *)findMacAddress
{
    int                    mib[6];
    size_t                len;
    char                *buf;
    unsigned char        *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl    *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        //		printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    return [outstring uppercaseString];
    
}
#pragma mark - 获取PLMNCode
-(NSString *)findPLMNCode
{
    CTTelephonyNetworkInfo *networkInfo=[[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier=networkInfo.subscriberCellularProvider;
    [networkInfo release];
    networkInfo=nil;

    if (carrier) {
        if (carrier.mobileCountryCode) {
            if ([carrier.mobileCountryCode length]!=0) {
                return carrier.mobileCountryCode;
            }
        }
    }
        return @"";
}


#pragma mark - 获取Idfa
-(NSString *)findIdfa
{
    NSString *idfa;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    return idfa;
}



#pragma mark - 合成json数据
-(NSData *)compoundJSONData:(NSDictionary *)dic
{
    if (!dic) {
        return nil;
    }
    NSError *error=Nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error !=Nil) {
        return nil;
    }
    [error release]; error=nil;
    return data;
}



#pragma mark - 获取应用版本号
-(NSString *)findVersion
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    if (infoDict) {
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
        return versionNum;
    }
    return nil;
}



#pragma mark - 是否联网
-(BOOL)isHaveConnect
{
    // 创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;//sockaddr_in是与sockaddr等价的数据结构
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;//sin_family是地址家族，一般都是“AF_xxx”的形式。通常大多用的是都是AF_INET,代表TCP/IP协议族
    
    /**
     *  SCNetworkReachabilityRef: 用来保存创建测试连接返回的引用
     *
     *  SCNetworkReachabilityCreateWithAddress: 根据传入的地址测试连接.
     *  第一个参数可以为NULL或kCFAllocatorDefault
     *  第二个参数为需要测试连接的IP地址,当为0.0.0.0时则可以查询本机的网络连接状态.
     *  同时返回一个引用必须在用完后释放.
     *  PS: SCNetworkReachabilityCreateWithName: 这个是根据传入的网址测试连接,
     *  第二个参数比如为"www.apple.com",其他和上一个一样.
     *
     *  SCNetworkReachabilityGetFlags: 这个函数用来获得测试连接的状态,
     *  第一个参数为之前建立的测试连接的引用,
     *  第二个参数用来保存获得的状态,
     *  如果能获得状态则返回TRUE，否则返回FALSE
     *
     */
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress); //创建测试连接的引用：
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flagsn");
        return NO;
    }
    
    /**
     *  kSCNetworkReachabilityFlagsReachable: 能够连接网络
     *  kSCNetworkReachabilityFlagsConnectionRequired: 能够连接网络,但是首先得建立连接过程
     *  kSCNetworkReachabilityFlagsIsWWAN: 判断是否通过蜂窝网覆盖的连接,
     *  比如EDGE,GPRS或者目前的3G.主要是区别通过WiFi的连接.
     *
     */
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}





-(NSString *)signUrlStrWith:(NSDictionary *)dic
{
    NSArray *sortArray=[dic allKeys];
    
    NSArray *array = [sortArray sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString *outputAfter = [[NSMutableString alloc] init];
    for(NSString *str in array){
        [outputAfter appendFormat:@"&%@=%@",str,[dic objectForKey:str]];
    }
    [outputAfter appendFormat:@"&key=zy888"];
    NSString *qStr=[outputAfter substringFromIndex:1];
    NSLog(@"排序后:%@",qStr);
    NSString *outStr=[[self md5:qStr] uppercaseString];
    NSLog(@"md5后字符串:%@",outStr);
    [outputAfter release];
    outputAfter=nil;
    
    
    return outStr;
}


//md5 32位 加密 （小写）
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}







@end
