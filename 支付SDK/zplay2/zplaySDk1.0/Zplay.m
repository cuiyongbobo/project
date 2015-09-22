//
//  Zpaly.m
//  Zpaly
//
//  Created by ZPLAY005 on 13-12-31.
//  Copyright (c) 2013年 ZPLAY005. All rights reserved.
//

#import "Zplay.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "DataSigner.h"
#import <AdSupport/AdSupport.h>
#import "DefineObjcs.h"


@implementation Zplay

#pragma mark- 设置密码问题
-(ZplayRequest *)senderToSeveruserId:(NSString *)userid Zptext:(NSString *)ZT aswerText:(NSString *)AT pwdtext:(NSString *)pwdT Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
   
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"setQA%@%@",userid,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    ZT=[ZT stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AT=[AT stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    pwdT=[NSString stringWithFormat:@"zplay%@3478902156",pwdT];
    pwdT=[[self md5:pwdT] uppercaseString];

    NSDictionary *requestDic=@{@"userid":userid,
                               @"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"setQA",
                               @"userPwd":pwdT,
                               @"userQ":ZT,
                               @"userA":AT
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
    
}

#pragma mark- 单例
+(Zplay*)shareInstance
{
    static Zplay *mainVCtrl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainVCtrl = [[self alloc] init];
    });
    return mainVCtrl;
}


#pragma mark- 获得mac地址
- (NSString *) macaddress
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
		printf("Error: sysctl, take 2");
		return NULL;
	}
	
	ifm = (struct if_msghdr *)buf;
	sdl = (struct sockaddr_dl *)(ifm + 1);
	ptr = (unsigned char *)LLADDR(sdl);
	NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
	free(buf);
	return [outstring uppercaseString];
	
}
#pragma mark- 得到当前时间戳
-(NSString *)acquireTimestamp
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];//转为字符型
    return timeString;
}
#pragma mark- md5字符串加密
-(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
//    CC_MD5(cStr, strlen(cStr), result);//原
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
#pragma mark- 获取当前语言
-(NSString*)acquireLanguages
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}
#pragma mark- 获取当前应用的版本
-(NSString *)acquireAppVersion
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    return versionNum;
}
#pragma mark- 获取当前设备类型
-(NSString *)acquireDeviceType
{
    NSString *deviceModel=[UIDevice currentDevice].model;
    return deviceModel;
}


#pragma mark- 请求完成
- (void)requestDidFinish:(ZplayRequest *)_request
{
    [requests removeObject:_request];
    _request.zplay = nil;
}
#pragma mark- 获取通行证号
-(ZplayRequest *)acquireAccountIdDelegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"getIdz00000000%@",[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{
                               @"userid":@"z00000000",
                               @"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"getId"
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};

    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}
#pragma mark- 一键注册
-(ZplayRequest *)onekeyRegisterDelegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
         idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
       
    }else
    {
        idfa=@"";
    }
   
   
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"onekeyRegisterz00000000%@",[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{@"userid":@"z00000000",
                               @"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"onekeyRegister"
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;

}
#pragma mark- 修改用户名
-(ZplayRequest *)changeNameFromServerUserId:(NSString *)userId UserName:(NSString *)userName Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"changeName%@%@",userId,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{@"userid":userId,
                               @"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"changeName",
                               @"username":userName
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}

#pragma mark- 注册
-(ZplayRequest *)registerToServerUserId:(NSString *)userId pwd:(NSString *)pwd userQ:(NSString *)userQ userA:(NSString *)userA Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"registerz00000000%@",[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    pwd=[NSString stringWithFormat:@"zplay%@3478902156",pwd];
    pwd=[[self md5:pwd] uppercaseString];
    
    userQ=[userQ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    userA=[userA stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *requestDic=Nil;
    if (userA==Nil) {
        requestDic=@{@"gameid": gameId,
                                   @"channelid":channelId,
                                   @"deviceid":deviceId,
                                   @"idfa":idfa,
                                   @"devicetype":devicetype,
                                   @"ver":appVersion,
                                   @"lan":deviceL,
                                   @"ts":timestamp,
                                   @"action":@"register",
                                   @"username":userId,
                                   @"userPwd":pwd,
                                    @"userid":@"z00000000"
                                   };
    }else{
        requestDic=@{@"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"register",
                               @"username":userId,
                               @"userQ":userQ,
                               @"userA":userA,
                               @"userPwd":pwd,
                                @"userid":@"z00000000"
                               };
    }
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    NSLog(@"%@",requestDic);
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;

}
#pragma mark- 用户登录
-(ZplayRequest *)loginToseeverUserId:(NSString *)userId userPwd:(NSString *)pwd Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *userName=@"";
    NSLog(@"%@",pwd);
    NSString *regex = @"(z|Z)\\d{8}";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred2 evaluateWithObject:userId])
    {
        userName=userId;
        userId=@"z00000000";
    }
      
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    
    NSString *signstr=[NSString stringWithFormat:@"login%@%@",userId,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    pwd=[NSString stringWithFormat:@"zplay%@3478902156",pwd];
    pwd=[[self md5:pwd] uppercaseString];
    NSDictionary *requestDic=@{@"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"login",
                               @"userid":userId,
                               @"userPwd":pwd,
                               @"username":userName
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}
#pragma mark- 找回密码
-(ZplayRequest *)getPwdFromServerUserId:(NSString *)userId userQ:(NSString *)userQ userA:(NSString *)userA Delegate:(id<ZplayRequestDelegate>)delegate
{
    
    NSString *userName=@"";
    NSString *regex = @"(z|Z)\\d{8}";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred2 evaluateWithObject:userId])
    {
        userName=userId;
        userId=@"z00000000";
    }
    
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"getPwd%@%@",userId,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    userQ=[userQ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    userA=[userA stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *requestDic=@{@"userid":userId,
                               @"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"getPwd",
                               @"userQ":userQ,
                               @"userA":userA,
                               @"username":userName
                            };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}
#pragma mark- 重置密码
-(ZplayRequest *)resetPwdFromServerUserId:(NSString *)userId userPwd:(NSString *)pwd Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *userName=@"";
    NSLog(@"%@",pwd);
    NSString *regex = @"(z|Z)\\d{8}";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred2 evaluateWithObject:userId])
    {
        userName=userId;
        userId=@"z00000000";
    }

    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"changePwd%@%@",userId,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    pwd=[NSString stringWithFormat:@"zplay%@3478902156",pwd];
    pwd=[[self md5:pwd] uppercaseString];
    NSDictionary *requestDic=@{@"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"changePwd",
                               @"userid":userId,
                               @"userPwd":pwd,
                               @"username":userName
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;

}
#pragma mark-游戏开始必须调用
-(void)acquireGameStarTime
{
    NSString *timestamp=[self acquireTimestamp];
    NSLog(@"-----------------------开始时间%@",timestamp);
    [[NSUserDefaults standardUserDefaults]setObject:timestamp forKey:@"durationStar"];
}
#pragma mark- 游戏结束必须调用
-(void)acquireGameEndtime
{
    NSString *timestamp=[self acquireTimestamp];
    NSLog(@"------------------------结束时间%@",timestamp);
    [[NSUserDefaults standardUserDefaults]setObject:timestamp forKey:@"durationEnd"];
}
#pragma mark- 进入游戏
-(ZplayRequest *)enterGamePostServerruserId:(NSString *)userId userPwd:(NSString *)pwd Delegate:(id<ZplayRequestDelegate>)delegate
{
    
    
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
   
    NSString *durationS=[[NSUserDefaults standardUserDefaults]objectForKey:@"durationStr"];
    if (durationS==nil) {
        durationS=@"0";
    }
    NSString *durationE=[[NSUserDefaults standardUserDefaults]objectForKey:@"durationEnd"];
    if (durationE==nil) {
        
        durationE=@"0";
        if (![durationS isEqualToString:@"0"]) {
            durationE=[NSString stringWithFormat:@"%d",[durationS intValue]+30];
        }
        
   
    }else
    {
        
        if ([durationS intValue]>[durationE intValue]) {
            durationE=[NSString stringWithFormat:@"%d",[durationS intValue]+30];
        }
    }
    
    NSString *timestamp=[self acquireTimestamp];

    [[NSUserDefaults standardUserDefaults]setObject:timestamp forKey:@"durationStr"];
    
    NSString *deviceId=[self macaddress];
   
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }

    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
   
    NSString *signstr=[NSString stringWithFormat:@"enter%@%@",userId,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{@"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"enter",
                               @"userid":userId,
                               @"starttime":timestamp,
                               @"durationStart":durationS,
                               @"durationEnd":durationE
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    NSLog(@"%@",requestDic);
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}
#pragma mark- 获取支付信息
-(ZplayRequest *)getPaylistFromServeruserId:(NSString *)userId lastId:(NSString *)lastid Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"getPaylist%@%@",userId,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{@"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"getPaylist",
                               @"userid":userId,
                               @"lastid":lastid
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}
#pragma mark- 上传留言信息
-(ZplayRequest *)postServerMsguserId:(NSString *)userId userMsg:(NSString *)usermsg Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"reportMsg%@%@",userId,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    usermsg=[usermsg stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *requestDic=@{@"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"reportMsg",
                               @"userid":userId,
                               @"userMsg":usermsg
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;

}
#pragma mark-获得订单号
-(ZplayRequest *)getOrderidFromServerUserId:(NSString *)userId payMoney:(NSString *)paymoney paypattern:(NSString *)paypattern cpdefineinfo:(NSString *)cpinfo Delegate:(id<ZplayRequestDelegate>)delegate
{
    
    NSDictionary *oderDic=@{@"userId": userId,
                            @"payMoney":paymoney};
    [[NSUserDefaults standardUserDefaults]setObject:oderDic forKey:@"oderDic"];
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"getOrderid%@%@",userId,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSString *op=[self operatorMessage];
    cpinfo=[cpinfo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *requestDic=@{@"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"op":op,
                               @"action":@"getOrderid",
                              @"userid":userId,
                               @"paymoney":paymoney,
                               @"paypattern":paypattern,
                               @"cpDefineInfo":cpinfo
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
       ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPPayUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    
    return zplayrequest;
}
#pragma mark- 获取验证码
-(NSString *)aquiceCodeStringUserId:(NSString *)user keyStr:(NSString *)keyS
{
    NSString *codeStr=[NSString stringWithFormat:@"%@%@%@",user,keyS,[self acquireTimestamp]];
    NSLog(@"%@",[self md5:codeStr]);
    return [self md5:codeStr];
}
#pragma mark- 获取绑定信息
-(ZplayRequest *)getBindsFromSeverUserId:(NSString *)userID Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"getBinds%@%@",userID,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{
                               @"userid":userID,
                               @"action":@"getBinds",
                               @"ts":timestamp
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPCodeUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}
#pragma mark- 设置绑定类型
-(ZplayRequest *)setBindToFromSeverUserId:(NSString *)userID TypeStr:(NSString *)typeStr KeyStr:(NSString *)keyStr ValueStr:(NSString *)valueStr Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"setBind%@%@",userID,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{
                               @"userid":userID,
                               @"action":@"setBind",
                               @"type":typeStr,
                               @"key":keyStr,
                               @"value":valueStr,
                               @"ts":timestamp
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPCodeUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}
#pragma mark- 解除绑定信息
-(ZplayRequest *)abrogateBindFromSeverUserId:(NSString *)userID TypeStr:(NSString *)typeStr KeyStr:(NSString *)keyStr Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"cancelBind%@%@",userID,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{
                               @"userid":userID,
                               @"action":@"cancelBind",
                               @"type":typeStr,
                               @"key":keyStr,
                               @"ts":timestamp
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPCodeUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}
#pragma mark- 上传验证码到服务器
-(ZplayRequest *)reportCodeToSeverUserId:(NSString *)userID TypeStr:(NSString *)typeStr KeyStr:(NSString *)keyStr ValueStr:(NSString *)valueStr ifVefiy:(NSString *)isVerf Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *userName=@"";
    
    NSString *regex = @"(z|Z)\\d{8}";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if(![pred2 evaluateWithObject:userID])
    {
        userName=userID;
        userID=@"z00000000";
    }
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"reportCode%@%@",userID,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{
                               @"userid":userID,
                               @"action":@"reportCode",
                               @"type":typeStr,
                               @"key":keyStr,
                               @"value":valueStr,
                               @"ts":timestamp,
                               @"ifVerify":isVerf,
                               @"username":userName
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    NSLog(@"-------------------------%@",dic);
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPCodeUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}

#pragma mark- 取消网络请求
-(void)discon
{
    ZplayRequest *zpR=[[ZplayRequest alloc]init];
    [zpR disconnect];
    [zpR release];
}
#pragma mark- 获取格式相对应的时间
-(NSString *)acquireTimeStr
{
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSString * na = [df stringFromDate:currentDate];
    
   
    return na;
}
#pragma mark- 获取流水账单号
-(ZplayRequest *)acquireBillrderid:(NSString *)orderId productName:(NSString *)pName productDescription:(NSString *)pDescription Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *timeS=[self acquireTimeStr];
    NSDictionary *dic=@{
                        @"merchantOrderTime":timeS,
                        @"orderid":orderId,
                        @"merchantOrderAmt":pName,
                        @"merchantOrderDesc":pDescription
                        };
    
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:UPPHTTPUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}
#pragma mark-获取运营商信息
-(NSString *)operatorMessage
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *op=nil;
    if ([carrier.carrierName isEqualToString:@"中国移动"]) {
        op=@"CMCC";
    }else
    if ([carrier.carrierName isEqualToString:@"中国联通"]) {
        op=@"CU";
        }else
    if ([carrier.carrierName isEqualToString:@"中国电信"]) {
                op=@"CT";
    }else
    {
        op=@"NULL";
    }
    [info release];
    return op;
}
#pragma mark-上报支付结果
-(ZplayRequest *)reportResultToServerpaypattern:(NSString *)paypattern payresult:(NSString *)payR Delegate:(id<ZplayRequestDelegate>)delegate
{
    
    NSDictionary *strdic=[[NSUserDefaults standardUserDefaults]objectForKey:@"oderDic"];
    NSString *orderid=[[NSUserDefaults standardUserDefaults]objectForKey:@"orderStr"];
    NSString *userId=[strdic objectForKey:@"userId"];
    NSString *paymoney=[strdic objectForKey:@"payMoney"];

    
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"reportResult%@%@",userId,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{
                               @"ts":timestamp,
                               @"action":@"reportResult",
                               @"userid":userId,
                               @"orderid":orderid,
                               @"paymoney":paymoney,
                               @"paypattern":paypattern,
                               @"payresult":payR,
                               @"paytime":timestamp
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
     ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPPayUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;

}
#pragma mark- 获取用户是否设置过密保
-(ZplayRequest *)acquirecheckQAuserId:(NSString *)userid Delegate:(id<ZplayRequestDelegate>)delegate
{
    NSString *plistPath=[[NSBundle mainBundle]pathForResource:@"zplaySDk" ofType:@"plist"];
    NSDictionary *mDic=[[[NSDictionary alloc]initWithContentsOfFile:plistPath] autorelease];
    NSString *channelId=[mDic objectForKey:@"channelid"];
    NSString *gameId=[mDic objectForKey:@"gameId"];
    NSString *deviceId=[self macaddress];
    NSString *idfa;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>6) {
        idfa=[[[ASIdentifierManager sharedManager]advertisingIdentifier]UUIDString];
        
    }else
    {
        idfa=@"";
    }
    NSString *devicetype=[self acquireDeviceType];
    NSString *deviceL=[self acquireLanguages];
    NSString *appVersion=[self acquireAppVersion];
    NSString *timestamp=[self acquireTimestamp];
    NSString *signstr=[NSString stringWithFormat:@"checkQA%@%@",userid,[self acquireTimestamp]];
    NSString *signMd5=[self md5:signstr];
    NSDictionary *requestDic=@{
                               @"userid":userid,
                               @"gameid": gameId,
                               @"channelid":channelId,
                               @"deviceid":deviceId,
                               @"idfa":idfa,
                               @"devicetype":devicetype,
                               @"ver":appVersion,
                               @"lan":deviceL,
                               @"ts":timestamp,
                               @"action":@"checkQA"
                               };
    NSDictionary *dic=@{@"data": requestDic,
                        @"sign":signMd5};
    
    ZplayRequest *zplayrequest=[ZplayRequest requestWithUrl:HTTPUserUrl httpMethod:@"POST" params:dic delegate:delegate];
    zplayrequest.zplay=self;
    [requests addObject:zplayrequest];
    [zplayrequest connect];
    return zplayrequest;
}

#pragma mark- 内存释放
- (void)dealloc
{
   [super dealloc];
    
    for (ZplayRequest* _request in requests)
    {
        _request.zplay = nil;
    }
    [request disconnect];
    [request release], request = nil;
    
}
#pragma mark- 调用支付宝
-(void)callZFBorderid:(NSString *)orderId productName:(NSString *)pName productDescription:(NSString *)pDescription productAmount:(NSString *)pAmount
{
    NSString *partner = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Partner"];
    NSString *seller = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"Seller"];
    if ([partner length] == 0 || [seller length] == 0)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
														message:@"缺少partner或者seller。"
													   delegate:self
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return;
	}
    AlixPayOrder *order = [[AlixPayOrder alloc] init];
	order.partner = partner;
	order.seller = seller;
	order.tradeNO = orderId ;//订单ID（由商家自行制定）
	order.productName = pName; //商品标题
	order.productDescription = pDescription; //商品描述
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
//    NSString* versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    NSString*appName =[infoDict objectForKey:@"CFBundleDisplayName"];
   
   
	order.amount =pAmount; //商品价格
	order.notifyURL =  @"http://op.zplay.cn/onlinepay/ws_paywap/callback.php"; //回调URL
	
	//应用注册scheme,在zplay1.0-Info.plist定义URL types,用于快捷支付成功后重新唤起商户应用
	NSString *appScheme = appName;
	
	//将商品信息拼接成字符串
	NSString *orderSpec = [order description];
	NSLog(@"orderSpec = %@",orderSpec);
	
	//获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
	id<DataSigner> signer = CreateRSADataSigner([[NSBundle mainBundle] objectForInfoDictionaryKey:@"RSA private key"]);
	NSString *signedString = [signer signString:orderSpec];
	
	//将签名成功字符串格式化为订单字符串,请严格按照该格式
	NSString *orderString = nil;
	if (signedString != nil) {
		orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        //获取快捷支付单例并调用快捷支付接口
        AlixPay * alixpay = [AlixPay shared];
        int ret = [alixpay pay:orderString applicationScheme:appScheme];
        
        if (ret == kSPErrorAlipayClientNotInstalled) {
            
        
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                 message:@"您还没有安装支付宝钱包，请先安装"
                                                                delegate:self
                                                       cancelButtonTitle:@"确定"
                                                       otherButtonTitles:nil];
            [alertView setTag:123];
            [alertView show];
            [alertView release];
        }
        else if (ret == kSPErrorSignError) {
            NSLog(@"签名错误！");
        }
        
	}
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
   

	if (alertView.tag == 123) {
       
            NSString * URLString = @"https://itunes.apple.com/cn/app/zhi-fu-bao-qian-bao-yu-e-bao/id333206289?mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
}

@end
