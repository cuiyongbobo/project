//
//  AppDelegate.m
//  zplaySDk1.0
//
//  Created by ZPLAY005 on 14-1-24.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "AppDelegate.h"
#import "helloViewController.h"
#import "Zplay.h"
#import "AlixPay.h"
#import "AlixPayResult.h"
#import "DataVerifier.h"
#import <sys/utsname.h>
#import "helloViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

extern NSString *CTSettingCopyMyPhoneNumber();

@interface AppDelegate ()<ZplayRequestDelegate>

- (BOOL)isSingleTask;
- (void)parseURL:(NSURL *)url application:(UIApplication *)application;

@end
@implementation AppDelegate

- (NSString *)findPLMN
{
    CTTelephonyNetworkInfo *networkInfo=[[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier=networkInfo.subscriberCellularProvider;
    NSString *str;
    if (carrier) {
        str=carrier.mobileCountryCode;
    }else
    {
        str=@"";
    }
    return str;
}

//支付宝完成后的回调
- (BOOL)isSingleTask{
	struct utsname name;
	uname(&name);
	float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
	if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
		return YES;
	}
	else {
		return NO;
	}
}
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	
	[self parseURL:url application:application];
	return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [self parseURL:url application:application];
	return YES;
}

- (void)parseURL:(NSURL *)url application:(UIApplication *)application {
	AlixPay *alixpay = [AlixPay shared];
	AlixPayResult *result = [alixpay handleOpenURL:url];
	
    if (result) {
		//是否支付成功
		if (9000 == result.statusCode) {
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:@"支付信息到账稍有延迟，请稍后。信息到帐后将在下次进入游戏时自动刷新"
																delegate:nil
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
			
            [alertView show];
			[alertView release];
           
            [[Zplay shareInstance]reportResultToServerpaypattern:@"3" payresult:@"1" Delegate:self];
            
        }
		//如果支付失败,可以通过result.statusCode查询错误码
		else {
            
			UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																 message:result.statusMessage
																delegate:nil
													   cancelButtonTitle:@"确定"
													   otherButtonTitles:nil];
			[alertView show];
			[alertView release];
            if ([result.statusMessage isEqualToString:@"用户中途取消"]) {
                 [[Zplay shareInstance]reportResultToServerpaypattern:@"3" payresult:@"2" Delegate:self];
            }else
            {
                [[Zplay shareInstance]reportResultToServerpaypattern:@"3" payresult:@"0" Delegate:self];
            }
           
            
		
	}
}

}




- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //用于统计
    [[Zplay shareInstance]acquireGameStarTime];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    helloViewController *demo=[[helloViewController alloc]init];
    self.window.rootViewController=demo;
   NSLog(@"~~~~~~~~~~~~~~~~~~~%@",[self findPLMN]) ;
    [self.window makeKeyAndVisible];
    
    
    /*
	 *单任务handleURL处理
	 */
	if ([self isSingleTask]) {
		NSURL *url = [launchOptions objectForKey:@"UIApplicationLaunchOptionsURLKey"];
		
		if (nil != url) {
			[self parseURL:url application:application];
		}
	}

    return YES;

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    //  用于调查统计
    NSString *acc= [[NSUserDefaults standardUserDefaults]objectForKey:@"actoPushacc"];
    if (acc!=nil) {
        [[Zplay shareInstance]enterGamePostServerruserId:acc userPwd:nil Delegate:self];
    }
    
}

@end
