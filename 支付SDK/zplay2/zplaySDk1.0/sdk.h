//
//  sdk.h
//  zplayXGZSDK
//
//  Created by ZPLAY005 on 14-1-14.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface sdk : NSObject

+(sdk*)shareInstance;
-(void)login:(UIViewController *)vctrl;

-(void)userCente:(UIViewController *)viewCtrl;

-(void)payViewGameText:(NSString *)gT commodityText:(NSString *)cT priceText:(NSString *)pT cpDefineInfo:(NSString *)cpIfo ViewController:(UIViewController *)viewCtrl;

-(void)payView2GameText:(NSString *)gT cpDefineInfo:(NSString *)cpIfo ViewController:(UIViewController *)viewCtrl;

@end
