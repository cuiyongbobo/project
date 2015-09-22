//
//  sdk.m
//  zplayXGZSDK
//
//  Created by ZPLAY005 on 14-1-14.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "sdk.h"
#import "loginViewController.h"
#import "payViewController.h"
#import "autonomousPayViewController.h"
#import "userCenterViewController.h"
#import "RegisterViewController.h"
#import "DefineObjcs.h"

#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)
@implementation sdk

#pragma mark- 单例
+(sdk*)shareInstance
{
    static sdk *mainVCtrl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainVCtrl = [[self alloc] init];
    });
    return mainVCtrl;
}

-(void)login:(UIViewController *)vctrl
{
    loginViewController *login=[[loginViewController alloc]init];
//        RegisterViewController *login=[[RegisterViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:login];
     nav.navigationBarHidden=YES;
    [vctrl presentViewController:nav animated:YES completion:nil];
    [login release];
    [nav release];

}
//用户中心
-(void)userCente:(UIViewController *)viewCtrl 
{
   
    userCenterViewController *PAY=[[userCenterViewController alloc]init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:PAY];
    nav.navigationBarHidden=YES;
    [viewCtrl presentViewController:nav animated:YES completion:nil];
    [PAY release];
    [nav release];
}
//支付
-(void)payViewGameText:(NSString *)gT commodityText:(NSString *)cT priceText:(NSString *)pT cpDefineInfo:(NSString *)cpIfo ViewController:(UIViewController *)viewCtrl
{
    payViewController *pay= [[payViewController alloc]init];
    pay.userStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    pay.commodtyStr=cT;
    pay.priceText=pT;
    pay.gameStr=gT;
    pay.cpDInfo=cpIfo;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:pay];
    nav.navigationBarHidden=YES;
    [viewCtrl presentViewController:nav animated:YES completion:nil];
    [nav release];
    [pay release];
}
-(void)payView2GameText:(NSString *)gT cpDefineInfo:(NSString *)cpIfo ViewController:(UIViewController *)viewCtrl
{
    autonomousPayViewController *pay= [[autonomousPayViewController alloc]init];
    pay.useridStr=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
    pay.gamestr=gT;
    pay.cpDefineInfo=cpIfo;
 
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:pay];
    nav.navigationBarHidden=YES;
    [viewCtrl presentViewController:nav animated:YES completion:nil];
//     [pay release];
    [nav release];
   
}

-(NSString *)gCurrentuserId
  {
      NSString *str;
      if ([[NSUserDefaults standardUserDefaults]boolForKey:ISLOGON]) {
          str=[[NSUserDefaults standardUserDefaults]objectForKey:USER_LOGINACC];
      }else
      {
          str=Nil;
      }
      return str;
  }
@end
