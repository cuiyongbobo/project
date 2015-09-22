//
//  DefineObjcs.h
//  sqliteDemo
//
//  Created by ZPLAY005 on 14-4-3.
//  Copyright (c) 2014年 vbdsgfht. All rights reserved.
//

#ifndef sqliteDemo_DefineObjcs_h
#define sqliteDemo_DefineObjcs_h


#import "SVProgressHUD.h"

#define SQLITE_NAME         @"GW.sqlite"
#define SQLITE_TABLE_NAME   @"UserSYSTable"
#define SQLITE_USERNAME     @"UserName"
#define SQLITE_USERID       @"UserID"
#define SQLITE_PASSWORD     @"PassWord"
#define SQLITE_ZID          @"zID"

#define USER_ISREMBER       @"isremmber"
#define ISAUTOLOGIN         @"automateLogin"
#define USER_AUTOLOGINACC   @"actoPushacc"
#define USER_AUTOLOGINPWD   @"actoPushpwd"
#define USER_LOGINACC       @"userAcc"
#define USER_LOGINPWD       @"userPwd"
#define USER_LOGINNAME      @"userIdName10"
#define ISLOGON             @"login"

#define ISSHOWUPPY          @"XMSHow"
#define kResult             @"支付结果：%@"
#define QuerySUrl           @"http://op.zplay.cn/onlinepay/unionpay/QueryService.php"
#define SubmitSUrl          @"http://op.zplay.cn/onlinepay/unionpay/SubmitService.php"

#define HTTPUserUrl @"http://op.zplay.cn/in/zgu20.php"
#define HTTPPayUrl @"http://op.zplay.cn/in/zgp20.php"
#define CallHTTPUrl @"http://op.zplay.cn/onlinepay/ws_paywap/callback.php"
#define UPPHTTPUrl @"http://op.zplay.cn/onlinepay/unionpay/SubmitService.php"
#define HTTPCodeUrl @"http://op.zplay.cn/in/zgb.php"

#define ZPLAY_BUNDLE  [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ZplayBundle" ofType:@"bundle"]]
#define iPhone [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone
#define iPad [[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad

#endif
