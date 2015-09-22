//
//  Zpaly.h
//  Zpaly
//
//  Created by ZPLAY005 on 13-12-31.
//  Copyright (c) 2013年 ZPLAY005. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZplayRequest.h"
@interface Zplay : NSObject<ZplayRequestDelegate,UIAlertViewDelegate>
{
    ZplayRequest *request;
    NSMutableSet *requests;
}
//单例
+(Zplay*)shareInstance;
//获取通行证id-
-(ZplayRequest *)acquireAccountIdDelegate:(id<ZplayRequestDelegate>)delegate;
//注册-
-(ZplayRequest *)registerToServerUserId:(NSString *)userId pwd:(NSString *)pwd userQ:(NSString *)userQ userA:(NSString *)userA Delegate:(id<ZplayRequestDelegate>)delegate;
//登录-
-(ZplayRequest *)loginToseeverUserId:(NSString *)userId userPwd:(NSString *)pwd Delegate:(id<ZplayRequestDelegate>)delegate;
//获取密码-
-(ZplayRequest *)getPwdFromServerUserId:(NSString *)userId userQ:(NSString *)userQ userA:(NSString *)userA Delegate:(id<ZplayRequestDelegate>)delegate;
//重置密码-
-(ZplayRequest *)resetPwdFromServerUserId:(NSString *)userId userPwd:(NSString *)pwd Delegate:(id<ZplayRequestDelegate>)delegate;
////修改密码-
//-(ZplayRequest *)changePwdFromServeruserId:(NSString *)userId userPwd:(NSString *)pwd Delegate:(id<ZplayRequestDelegate>)delegate;
//进入游戏
-(ZplayRequest *)enterGamePostServerruserId:(NSString *)userId userPwd:(NSString *)pwd Delegate:(id<ZplayRequestDelegate>)delegate;
//获取支付信息
-(ZplayRequest *)getPaylistFromServeruserId:(NSString *)userId lastId:(NSString *)lastid Delegate:(id<ZplayRequestDelegate>)delegate;
//发送留言信息-
-(ZplayRequest *)postServerMsguserId:(NSString *)userId userMsg:(NSString *)usermsg Delegate:(id<ZplayRequestDelegate>)delegate;
//获取订单号
-(ZplayRequest *)getOrderidFromServerUserId:(NSString *)userId payMoney:(NSString *)paymoney paypattern:(NSString *)paypattern cpdefineinfo:(NSString *)cpinfo Delegate:(id<ZplayRequestDelegate>)delegate;
//上报支付结果
-(ZplayRequest *)reportResultToServerpaypattern:(NSString *)paypattern payresult:(NSString *)payR Delegate:(id<ZplayRequestDelegate>)delegate;
//设置密码问题
-(ZplayRequest *)senderToSeveruserId:(NSString *)userid Zptext:(NSString *)ZT aswerText:(NSString *)AT pwdtext:(NSString *)pwdT Delegate:(id<ZplayRequestDelegate>)delegate;
//获取流水账号信息
-(ZplayRequest *)acquireBillrderid:(NSString *)orderId productName:(NSString *)pName productDescription:(NSString *)pDescription Delegate:(id<ZplayRequestDelegate>)delegate;
//保存游戏结束时间,必须按文档添加方式添加
-(void)acquireGameEndtime;
//保存游戏开始时间，必须按文档添加方式添加
-(void)acquireGameStarTime;
//调用支付宝
-(void)callZFBorderid:(NSString *)orderId productName:(NSString *)pName productDescription:(NSString *)pDescription productAmount:(NSString *)pAmount;
//获取是否设置过密码
-(ZplayRequest *)acquirecheckQAuserId:(NSString *)userid Delegate:(id<ZplayRequestDelegate>)delegate;
//一键注册
-(ZplayRequest *)onekeyRegisterDelegate:(id<ZplayRequestDelegate>)delegate;
//修改用户名
-(ZplayRequest *)changeNameFromServerUserId:(NSString *)userId UserName:(NSString *)userName Delegate:(id<ZplayRequestDelegate>)delegate;
//获取绑定信息
-(ZplayRequest *)getBindsFromSeverUserId:(NSString *)userID Delegate:(id<ZplayRequestDelegate>)delegate;
//设置绑定类型
-(ZplayRequest *)setBindToFromSeverUserId:(NSString *)userID TypeStr:(NSString *)typeStr KeyStr:(NSString *)keyStr ValueStr:(NSString *)valueStr Delegate:(id<ZplayRequestDelegate>)delegate;
//解除绑定信息
-(ZplayRequest *)abrogateBindFromSeverUserId:(NSString *)userID TypeStr:(NSString *)typeStr KeyStr:(NSString *)keyStr Delegate:(id<ZplayRequestDelegate>)delegate;
//上传验证码到服务器
-(ZplayRequest *)reportCodeToSeverUserId:(NSString *)userID TypeStr:(NSString *)typeStr KeyStr:(NSString *)keyStr ValueStr:(NSString *)valueStr ifVefiy:(NSString *)isVerf Delegate:(id<ZplayRequestDelegate>)delegate;
//获取验证码
-(NSString *)aquiceCodeStringUserId:(NSString *)user keyStr:(NSString *)keyS;
-(void)discon;
- (NSString *) macaddress;
-(NSString *)md5:(NSString *)str;
-(NSString *)acquireTimeStr;
@end
