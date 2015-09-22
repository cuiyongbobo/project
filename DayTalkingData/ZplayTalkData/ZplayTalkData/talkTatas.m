//
//  talkTatas.m
//  ZplayTalkData
//
//  Created by Lee on 14/12/12.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "talkTatas.h"


#import "ZplayNoject.h"





#import "AFNetworking.h"

#import "AFHTTPRequestOperation.h"



#import <ifaddrs.h>



#import <arpa/inet.h>


//#import "Reachability.h"

#import "GWSqlitelibray.h"




#define QQUrls  @"http://api.map.baidu.com/geoconv/v1/?coords=%@&from=1&to=5&ak=YDvr8I2QbRc98QwkAzNWMbKa"



#define baiduUrl   @"http://api.map.baidu.com/geocoder/v2/?ak=YDvr8I2QbRc98QwkAzNWMbKa&callback=renderReverse&location=%@&output=json&pois=0"

#define TalkDataUrl @"http://os.zplayworld.com/getmessage.php"  //http://os.zplayworld.com/getmessage.php


#define IPUrl @"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js"




@interface talkTatas()
{
    
    AFHTTPRequestOperationManager *manager; //创建请求（iOS 6-7）
    
    //Reachability  *hostReach;
    
    double  latitude;
    double  longitude;
    float   accuracy;
    NSString *geocode;
    
    NSString  *ipLocs;
    //ipLoc
    BOOL ishaves;
}



@end


@implementation talkTatas





#pragma mark ----暴漏出来的接口/点击广告的接口



-(void)gameIDD:(NSString *)gameid chennalIDD:(NSString *)chennalid materielId:(NSString *)materielId advertisers:(NSString *)advertisers provider:(NSString *)provider
{
    
    
    
    /*
     接口请求部分
     --------***-------
     
     
     */
    
    NSLog(@"--------------------------------开始测试数据");
    
    
    //保存数据
    self.materielId=materielId;
    self.advertisers=advertisers;
    self.provider=provider;
    self.gameid=gameid;
    self.chennalid=chennalid;
    
    //存入点击广告的信息到数据库
    [self materielIdAD:_materielId advertisers:_advertisers provider:_provider];
    
}



#pragma mark----检测网络状态

//- (void) reachabilityChangeds:(NSNotification*)note {
//
//    NSLog(@"------------------------------检测网络");
//
//    NSLog(@"------------------------------ssssssssssssssss");
//    Reachability* curReach = [note object];
//    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
//    NetworkStatus status = [curReach currentReachabilityStatus];
//
//    if (status == NotReachable) {
//        NSLog(@"网络不可用");
//
//    }else{
//        // NSArray *arr=[[DateCenter shareInstant] allFavoriteRecordgame];
//        //有网络的时候请求接口
//        [self storage:_gameid channelId:_chennalid];
//    }
//
//
//}









#pragma mark -------根据gps的经纬度，请求百度接口
//afn 使用

-(void)afn
{
    
    
    //致空请求
    if (manager) {
        manager = nil;
    }
    
    //创建请求
    
    //设置请求格式
    manager = [AFHTTPRequestOperationManager manager];
    
    NSString * s1 =[NSString stringWithFormat:@"%f,%f",longitude,latitude];
    NSString * st = [NSString stringWithFormat:QQUrls,s1];
    NSLog(@"----------------------------------------------url=%@",st);
    //发送GET请求//@"接口地址"
    [manager GET:st parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //请求成功（当解析器为AFJSONResponseSerializer时）
        NSDictionary *dic=responseObject;
        
        NSString *burl;
        NSArray*Disc=dic[@"result"];
        for (NSDictionary *ddict in Disc) {
            NSLog(@"dic: %@", ddict[@"y"]);
            burl=[NSString stringWithFormat:@"%@,%@",ddict[@"y"],ddict[@"x"]];
        }
        
        [self afnbaidu:burl];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //请求失败
        NSLog(@"Error: %@", error);
    }];
    
    
    
    
    
}



-(void)afnbaidu:(NSString *)parme
{
    
    
    NSLog(@"-----------------------------parmes=%@",parme);
    //致空请求
    if (manager) {
        manager = nil;
    }
    
    //创建请求
    manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSString * st = [NSString stringWithFormat:baiduUrl,parme];
    NSLog(@"----------------------------------------------url=%@",st);
    //发送GET请求//@"接口地址"
    [manager GET:st parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        //请求成功（当解析器为AFJSONResponseSerializer时）
        
        
        NSString *shabi =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"dic: %@", shabi);
        
        //NSString *b = [a substringFromIndex:4];
        // NSString *substring=[shabi substringFromIndex:28];
        NSRange ran;
        NSRange rans;
        ran=[shabi rangeOfString:@"("];
        
        rans=[shabi rangeOfString:@")"];
        
        
        NSString *Strings=[shabi substringWithRange:NSMakeRange(ran.location+1, (rans.location-ran.location-1))];
        
        NSData* xmlData = [Strings dataUsingEncoding:NSUTF8StringEncoding];
        
        // NSData *returnData = [ NSURLConnection sendSynchronousRequest: request returningResponse:&response error:&err];//获取网络链接返回的数据
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:xmlData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        NSDictionary *currendict=content[@"result"];
        
        
        
        NSLog(@"-----------------------------------dictttttt:  %@",currendict[@"formatted_address"]);
        
        
        
        //保存
        
        geocode=currendict[@"formatted_address"];
        
        NSLog(@"----------------------------------formatted_addressgeocode=%@",geocode);
        
        
        [self IPAfn];
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"----------------------------------error");
        
        //请求失败
        NSLog(@"Error: %@", [error description]);
        
    }];
    
    
    
}


#pragma mark ------获取手机语言

- (NSString*)getPreferredLanguage

{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSLog(@"当前语言:%@", preferredLang);//zh-Hans----简体中文
    
    return preferredLang;
    
}



#pragma mark -------GPS 开始定位
//GPRS定位

static bool isfast=YES;

-(void)GPs
{
    
    
    NSLog(@"--------------------------执行");
    
//    _locationmanager = [[CLLocationManager alloc]init];
//    _locationmanager.delegate = self;
//    [_locationmanager requestAlwaysAuthorization];
//    _locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
//    _locationmanager.distanceFilter = kCLDistanceFilterNone;
//    [_locationmanager startUpdatingLocation];
    

    if ([[UIDevice currentDevice].systemVersion doubleValue]>8) {
        _locationmanager = [[CLLocationManager alloc]init];
        _locationmanager.delegate = self;
        [_locationmanager requestAlwaysAuthorization];
        _locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationmanager.distanceFilter = kCLDistanceFilterNone;
        [_locationmanager startUpdatingLocation];
    }else{
        
        //设置定位的精度
        _locationmanager = [[CLLocationManager alloc]init];
        _locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
        //实现协议
        _locationmanager.delegate = self;
        NSLog(@"开始定位");
        //开始定位
        [_locationmanager startUpdatingLocation];
        
        NSLog(@"--------------------------执行111111");
    }
    
   
    
}





#pragma mark locationManager delegate

// iso 6.0以上SDK版本使用，包括6.0。
//-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *cl = [locations objectAtIndex:0];
//    NSLog(@"纬度--%f",cl.coordinate.latitude);
//    NSLog(@"经度--%f",cl.coordinate.longitude);
//
//}



- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation

{
    
    if (isfast) {
        NSLog(@"-------------------------------------hello");
        
        //打印出精度和纬度
        
        CLLocationCoordinate2D coordinate = newLocation.coordinate;
        
        NSLog(@"输出当前的精度和纬度");
        
        NSLog(@"精度：%f 纬度：%f",coordinate.latitude,coordinate.longitude);
        
        
        latitude=coordinate.latitude;
        
        longitude=coordinate.longitude;
        
        
        // NSURL *url=[NSURL URLWithString:QQUrls];
        
        
        
        //停止定位
        
        [_locationmanager stopUpdatingLocation];
        
        //    水平经度，也就是显示经纬度的经度
        accuracy = newLocation.horizontalAccuracy;
        
        NSLog(@"------------------------------------accuracy=%f",accuracy);
        
        isfast=NO;
        
        [self afn];
        
        
    }else
    {
        return;
    }
    
    
    
}




- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"==================================%@",error);
    
    //  [self afn];
}







#pragma mark -------网络服务模式
//网络服务模式

-(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc]init];
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            NSLog(@"**********************netType=%d",netType);
            switch (netType) {
                case 0:
                    state =@"0";
                    
                    //无网模式
                    break;
                case 1:
                    state = @"2G";
                    break;
                case 2:
                    state = @"3G";
                    break;
                case 3:
                    state = @"4G";
                    break;
                case 5:
                {
                    state = @"WIFI";
                }
                    break;
                default:
                    break;
            }
        }
        
        //        else{
        //            state=@"0";//无网络
        //            break;
        //        }
    }
    
    NSLog(@"----------------------------statessssssssssss=%@",state);
    //根据状态选择
    return state;
}



+(instancetype)shareInstant
{
    static id dc=nil;
    if (dc==nil)
    {
        dc=[[[self class]alloc]init];
    }
    return dc;
}




#pragma mark ---请求接口参数


-(void)storage:(NSString *)gameId channelId:(NSString *)channelId
{
    
    
    //死的参数
    
    //应用程序的名称和版本号等信息都保存在mainBundle的一个字典中，用下面代码可以取出来。
    
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    
    
    
    
    
    //应用版本
    NSString * versionNum =[infoDict objectForKey:@"CFBundleVersion"];
    
    
    
    
    
    //应用名称
    NSString *appName =[infoDict objectForKey:@"CFBundleDisplayName"];
    
   // NSString *text =[NSString stringWithFormat:@"%@ %@",appName,versionNum];
    
    
  //  NSLog(@"-----------------------------text=%@",text);
    
    
    /*
     
     
     IOS：
     
     游戏名称（应用名称）、游戏ID（传）、游戏版本（应用版本）、渠道（传）、SDK版本（写死）
     
     设备品牌（手机品牌）、设备型号（手机型号）、设备分辨率（手机分辨率）、OS版本（手机系统）、手机语言（获取手机）
     
     MAC（地址）、PLMN（）、IDFA（）、GPS（）、网络模式（WiFi/2G/3G/4G）、
     
     游戏开始时间、广告点击时间、被点击广告平台（Admob/InMobi）
     
     
     
     
     注：
     
     
     游戏开始时间——统计SDK启动时间即可
     广告点击时间——每次广告点击时间
     
     */
    
    //////////////////////////////////////////////////////////////////
    
    
    
    
    // 手机型号
    NSString *phoneModel=[[UIDevice currentDevice]model];
    NSLog(@"--------------------------------------------phoneModel=%@",phoneModel);
    
    
    
    
    
    //手机版本
    NSString *phoneVersion=[[UIDevice currentDevice] systemName];
    
    NSLog(@"--------------------------------------------phoneVersion=%@",phoneVersion);
    
    
    
    
    
    //设备名称
    NSString *deviceName=[[UIDevice currentDevice]systemName];
    
    NSLog(@"--------------------------------------------deviceName=%@",deviceName);
    
    
    
    
    
    
    //此时屏幕尺寸的宽高与scale的乘积就是相应的分辨率值。
    //1、得到当前屏幕的尺寸：
    CGRect rect_screen = [[UIScreen mainScreen]bounds];
    CGSize size_screen = rect_screen.size;
    
    
    
    
    
    //2、获得scale：
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    
    
    
    
    //分辨率
    CGFloat phoneresolutionwidth=size_screen.width * scale_screen;
    
    CGFloat phoneresolutionheight=size_screen.height * scale_screen;
    
    NSString *phoneresolution=[NSString stringWithFormat:@"%fX%f",phoneresolutionwidth,phoneresolutionheight];
    
    
    
    NSLog(@"--------------------------------------phoneresolution=%@",phoneresolution);
    
    
    
    
    
    //获取手机语言
    
    [self getPreferredLanguage];
    
    
    
    
    
    //MAC（地址）
    NSString *MacAddress=[[ZplayNoject shareInstance]findMacAddress];
    NSLog(@"-----------------------------------------MacAddress=%@",MacAddress);
    
    
    
    
    
    
    //PLMN
    /*
     中国移动的PLMN为46000，中国联通的PLMN为46001
     */
    NSString *Plmn=[[ZplayNoject shareInstance] findPLMNCode];
    
    NSLog(@"-----------------------------------------Plmn=%@",Plmn);//Plmn=460 中国移动
    
    
    
    
    
    //IDFA
    /*
     //广告标示符（IDFA-identifierForIdentifier）
     这是iOS 6中另外一个新的方法，advertisingIdentifier是新框架AdSupport.framework的一部分。ASIdentifierManager单例提供了一个方法advertisingIdentifier，通过调用该方法会返回一个上面提到的NSUUID实例。
     */
    NSString *Idfa=[[ZplayNoject shareInstance]findIdfa];
    
    NSLog(@"-----------------------------------------Idfa=%@",Idfa);
    
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    
    
    
    if ([self isBlankString:gameId]) {
        gameId=@"0";
    }
    
    if ([self isBlankString:versionNum]) {
        versionNum=@"0";
    }
    
    
    if ([self isBlankString:channelId]) {
        channelId=@"0";
    }
    
    if ([self isBlankString:deviceName]) {
        deviceName=@"0";
    }
    
    if ([self isBlankString:phoneModel]) {
        phoneModel=@"0";
    }
    
    if ([self isBlankString:phoneresolution]) {
        phoneresolution=@"0";
    }
    
    if ([self isBlankString:phoneVersion]) {
        phoneVersion=@"0";
    }
    
    NSString *Languagestring=[self getPreferredLanguage];
    if ([self isBlankString:Languagestring]) {
        Languagestring=@"0";
    }
    
    
    if ([self isBlankString:Idfa]) {
        Idfa=@"0";
    }
    
    if ([self isBlankString:MacAddress]) {
        MacAddress=@"0";
    }
    
    if ([self isBlankString:Plmn]) {
        Plmn=@"0";
    }
    
    
    if ([self isBlankString:appName]) {
        appName=@"0";
    }
    
    
    
    
    
    [params setObject:@"1" forKey:@"systemType"];
    NSLog(@"------------------------systemType=%@",params[@"systemType"]);
    
    [params setObject:appName forKey:@"gameLabel"];
    NSLog(@"------------------------gameLabel=%@",params[@"gameLabel"]);
    
    [params setObject:gameId forKey:@"gameId"];
    NSLog(@"------------------------gameId=%@",params[@"gameId"]);
    
    [params setObject:versionNum forKey:@"gameVersion"];
    NSLog(@"------------------------gameVersion=%@",params[@"gameVersion"]);
    
    [params setObject:channelId forKey:@"channelId"];
    NSLog(@"------------------------channelId=%@",params[@"channelId"]);
    
    [params setObject:@"1" forKey:@"sdkVersion"];
    NSLog(@"------------------------sdkVersion=%@",params[@"sdkVersion"]);
    
    [params setObject:deviceName forKey:@"manufacture"];
    NSLog(@"------------------------manufacture=%@",params[@"manufacture"]);
    
    [params setObject:phoneModel forKey:@"model"];
    NSLog(@"------------------------model=%@",params[@"model"]);
    
    [params setObject:phoneresolution forKey:@"displayMetrics"];
    NSLog(@"------------------------displayMetrics=%@",params[@"displayMetrics"]);
    
    [params setObject:phoneVersion forKey:@"systemRelease"];
    NSLog(@"------------------------systemRelease=%@",params[@"systemRelease"]);
    
    [params setObject:@"0" forKey:@"systemCode"];
    NSLog(@"------------------------systemCode=%@",params[@"systemCode"]);
    
    [params setObject:Languagestring forKey:@"language"];
    NSLog(@"------------------------language=%@",params[@"language"]);
    
    [params setObject:Idfa forKey:@"IMEI"];
    NSLog(@"------------------------IMEI=%@",params[@"IMEI"]);
    
    [params setObject:MacAddress forKey:@"mac"];
    NSLog(@"------------------------mac=%@",params[@"mac"]);
    
    
    [params setObject:Plmn forKey:@"plmn"];
    NSLog(@"------------------------plmn=%@",params[@"plmn"]);
    
    
    
    
    NSData *dataclicklist=[NSJSONSerialization dataWithJSONObject:[[GWSqlitelibray shareInstance] allFavoriteRecordtime] options:0 error:nil];
    
    
    NSLog(@"-------------------------------------------------------------------");
    NSData *dataopenList=[NSJSONSerialization dataWithJSONObject:[[GWSqlitelibray shareInstance]allFavoriteRecord] options:0 error:nil];
    NSLog(@"******************************************************************");
    
    
    
    NSString *jsonStringclicklist = [[NSString alloc] initWithData:dataclicklist
                                                          encoding:NSUTF8StringEncoding];
    
    NSString *jsonStringopenList = [[NSString alloc] initWithData:dataopenList
                                                         encoding:NSUTF8StringEncoding];
    
    [params setObject:jsonStringclicklist forKey:@"clicklist"];
    
    
    NSLog(@"------------------------clicklist=%@",params[@"clicklist"]);
    
    [params setObject:jsonStringopenList forKey:@"openList"];
    
    NSLog(@"------------------------openList=%@",params[@"openList"]);
    
    
    
    NSLog(@"------------------------paramsdata=%@",params);
    
    //致空请求
    if (manager) {
        manager = nil;
    }
    
    //创建请求
    manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    /*
     AFHTTPResponseSerializer  返回格式 字符串
     AFJSONResponseSerializer  返回格式  json
     */
    NSLog(@"---------------------------------params=%@",params[@"mac"]);
    //发送POST请求
    [manager POST:TalkDataUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict=responseObject;
        
        NSLog(@"-----------------------------------------------请求数据成功");
        
        
        //请求成功（当解析器为AFJSONResponseSerializer时）
        NSLog(@"-----------------------------------------------Success: %@", responseObject);
        //如果返回结果成功 ，调用数据库中得删除方法
        if ([dict[@"result"] isEqual:@"success"]) {
            
            
            NSLog(@"----------------------请求完毕");
            //清空数据库(清空上次的，clcick还没有点击呢所以不走,不删除)
            [[GWSqlitelibray shareInstance] deleteFavoriteRecord];
            [[GWSqlitelibray shareInstance]deleteFavoriteRecordtime];
            
            if (ishaves==NO) {//不是一次运行游戏
                //清空NSUsedefault 里面的数值
                NSUserDefaults *use=[NSUserDefaults standardUserDefaults];
                [use removeObjectForKey:@"Timestirng"];
                [use synchronize];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        NSLog(@"-------------------------------请求失败");
        
        //请求失败,存入数据
        //   [self materielId:_materielId advertisers:_advertisers provider:_provider];
        
        
        //请求失败
        NSLog(@"Error: %@", error);
        
    }];
    
    
}



#pragma mark ----无网络的时候存储数据库/请求失败的时候将数据存储数据库


//:(NSString *)materielId advertisers:(NSString *)advertisers provider:(NSString *)provider



-(void)materielIdOpen
{
    
    
    //clickTime,materielId,advertisers,provider
    
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    NSLog(@"------------------------------locationString:%@",timeString);
    
    
    //******插入time
    
    
    NSString *longitudestring=[NSString stringWithFormat:@"%f",longitude];
    NSString *latitudestring=[NSString stringWithFormat:@"%f",latitude];
    NSString *accuracystring=[NSString stringWithFormat:@"%f",accuracy];
    NSString *NetWorkStatesstring=[self getNetWorkStates];
    NSString *geocodestring=geocode;
    NSString *ipLocsstring=ipLocs;
    
    
    /****判断是否为空置**/
    
    //isBlankString
    // [timeString isbla]
    BOOL c=[self isBlankString:timeString];
    // BOOL d=[self isBlankString:materielId];
    // BOOL e=[self isBlankString:advertisers];
    //  BOOL f=[self isBlankString:provider];
    BOOL g=[self isBlankString:longitudestring];
    BOOL h=[self isBlankString:latitudestring];
    BOOL l=[self isBlankString:accuracystring];
    BOOL m=[self isBlankString:NetWorkStatesstring];
    BOOL n=[self isBlankString:geocodestring];
    BOOL o=[self isBlankString:ipLocsstring];
    
    if (c) {
        timeString=@"0";
    }
    //    if (d) {
    //        materielId=@"0";
    //    }
    //    if (e) {
    //        advertisers=@"0";
    //    }
    //    if (f) {
    //        provider=@"0";
    //    }
    if (g) {
        longitudestring=@"0";
    }
    if (h) {
        latitudestring=@"0";
    }
    if (l) {
        accuracystring=@"0";
    }
    if (m) {
        NetWorkStatesstring=@"0";
    }
    
    if (n) {
        geocodestring=@"0";
    }
    
    if (o) {
        ipLocsstring=@"0";
    }
    
    
    
    /*****插入数据库********/
    
    [[GWSqlitelibray shareInstance] addFavoriteRecord:timeString geocode:geocodestring longitude:longitudestring latitude:latitudestring ipLoc:ipLocsstring accuracy:accuracystring netModel:NetWorkStatesstring];
    
}




#pragma mark -------保存点击广告到数据库

-(void)materielIdAD:(NSString *)materielId advertisers:(NSString *)advertisers provider:(NSString *)provider
{
    
    //clickTime,materielId,advertisers,provider
    
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    NSLog(@"------------------------------locationString:%@",timeString);
    
    
    //******插入time
    //    NSString *longitudestring=[NSString stringWithFormat:@"%f",longitude];
    //    NSString *latitudestring=[NSString stringWithFormat:@"%f",latitude];
    //    NSString *accuracystring=[NSString stringWithFormat:@"%f",accuracy];
    //    NSString *NetWorkStatesstring=[self getNetWorkStates];
    //    NSString *geocodestring=geocode;
    //    NSString *ipLocsstring=ipLocs;
    
    
    /****判断是否为空置**/
    
    //isBlankString
    // [timeString isbla]
    BOOL c=[self isBlankString:timeString];
    BOOL d=[self isBlankString:materielId];
    BOOL e=[self isBlankString:advertisers];
    BOOL f=[self isBlankString:provider];
    //    BOOL g=[self isBlankString:longitudestring];
    //    BOOL h=[self isBlankString:latitudestring];
    //    BOOL l=[self isBlankString:accuracystring];
    //    BOOL m=[self isBlankString:NetWorkStatesstring];
    //    BOOL n=[self isBlankString:geocodestring];
    //    BOOL o=[self isBlankString:ipLocsstring];
    
    if (c) {
        timeString=@"0";
    }
    if (d) {
        materielId=@"0";
    }
    if (e) {
        advertisers=@"0";
    }
    if (f) {
        provider=@"0";
    }
    //    if (g) {
    //        longitudestring=@"0";
    //    }
    //    if (h) {
    //        latitudestring=@"0";
    //    }
    //    if (l) {
    //        accuracystring=@"0";
    //    }
    //    if (m) {
    //        NetWorkStatesstring=@"0";
    //    }
    //
    //    if (n) {
    //        geocodestring=@"0";
    //    }
    //
    //    if (o) {
    //        ipLocsstring=@"0";
    //    }
    
    
    /*****插入数据库********/
    
    
    [[GWSqlitelibray shareInstance] addFavoriteRecordtime:timeString materielId:materielId advertisers:advertisers provider:provider];
    
}




#pragma mark ----Opentime保存数据库

-(void)Opengametime
{
    //保存时间到本地
    NSUserDefaults *usetime=[NSUserDefaults standardUserDefaults];
    //clickTime,materielId,advertisers,provider
    
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1;
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    
    
    
    NSLog(@"------------------------------------------Timestirng%f",[[usetime objectForKey:@"Timestirng"] doubleValue]);
    
    
    NSString *oldtime=[[NSString alloc]init];
    if ([usetime objectForKey:@"Timestirng"]) {//第二次运行游戏的时候  才有oldtime
        //时间戳转换成时间
        NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateStyle:NSDateFormatterMediumStyle];
        [formatter1 setTimeStyle:NSDateFormatterShortStyle];
        [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//yyyy-MM-dd HH:mm:ss
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[usetime objectForKey:@"Timestirng"] doubleValue]];
        oldtime = [formatter1 stringFromDate:date];
        NSLog(@"oldtime =  %@",oldtime);
    }
    
    
    
    
    if (![usetime objectForKey:@"Timestirng"]) {// 第一次启动游戏,只执行一次（第一次没有值所以为空）
        ishaves=YES;//******第一次运行游戏
        
        [usetime setObject:timeString forKey:@"Timestirng"];//给第一次启动游戏 的时间赋值（fugai）
        [usetime synchronize];
        //请求接口
        
        if ([[ZplayNoject shareInstance] isHaveConnect]) {
            
            NSLog(@"有网络连接");
            //        //调用gps,获得经纬度
            [self GPs];// 保存 latitude  longitude;
            
        }else
            
        {
            
            NSLog(@"没有网络");
            
            //插入数据
            
            [self materielIdOpen];
            
            
            
            
            
            
            // SystemConfiguration.framework
            
            
            
            //            //实时监测网络
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChangeds:) name:kReachabilityChangedNotification object:nil];
            //            NSLog(@"-----------------------------发送网络检测通知");
            //
            //            hostReach =[Reachability reachabilityWithHostName:@"www.apple.com"];
            //
            //            [hostReach startNotifier];
            
        }
        
        
        
        
    }else if ([[self intervalSinceNow:oldtime] intValue]>=1)
    {
        ishaves=NO;//******不是地一次运行游戏啦
        //先判断有没有网络 有网络请求接口
        
        if ([[ZplayNoject shareInstance] isHaveConnect]) {
            NSLog(@"有网络连接Timestirng有值");
            //        //调用gps,获得经纬度
            [self GPs];// 保存 latitude  longitude;
            
        }else
            
        {
            NSLog(@"没有网络");
            
            //由网路获取的参数，统一设置为0
            //        latitude=0.0;
            //        longitude=0.0;
            //        accuracy=0.0;
            //        geocode=@"0";
            //        ipLocs=@"0";
            
            //插入数据（插入的是opentimeList）
            
            [self materielIdOpen];
            
            
            
            
            
            
            // SystemConfiguration.framework
            
            
            //            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChangeds:) name:kReachabilityChangedNotification object:nil];
            //            NSLog(@"-----------------------------发送网络检测通知");
            //
            //            hostReach =[Reachability reachabilityWithHostName:@"www.apple.com"];
            //
            //            [hostReach startNotifier];
            
        }
        
    }
    
    
}



-(void)IPAfn
{
    
    
    //致空请求
    if (manager) {
        manager = nil;
    }
    
    //创建请求
    manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:IPUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *shabi =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        // NSDictionary *dict=responseObject;
        
        NSLog(@"-----------------------------------------strstrstrstrstrstrstr=%@",shabi);
        /*
         var remote_ip_info = {"ret":1,"start":"219.142.127.0","end":"219.143.255.255","country":"\u4e2d\u56fd","province":"\u5317\u4eac","city":"\u5317\u4eac","district":"","isp":"\u7535\u4fe1","type":"","desc":""};
         
         */
        NSRange ran;
        NSRange rans;
        ran=[shabi rangeOfString:@"{"];
        
        rans=[shabi rangeOfString:@"}"];
        
        
        NSString *Strings=[shabi substringWithRange:NSMakeRange(ran.location, (rans.location+1-ran.location))];
        
        NSLog(@"-----------------------------------------strstrstrstrstrstrstr=%@",Strings);
        NSData* xmlData = [Strings dataUsingEncoding:NSUTF8StringEncoding];
        
        
        NSDictionary *content = [NSJSONSerialization JSONObjectWithData:xmlData options:NSJSONReadingMutableContainers error:nil];//转换数据格式
        
        NSLog(@"-----------------------------------------strstrstrstrstrstrstr=%@",content);
        
        
        NSString *centat=[NSString stringWithFormat:@"%@-%@-%@",content[@"country"],content[@"province"],content[@"city"]];
        
        NSLog(@"------------------------ipcity=%@",centat);
        
        
        
        ipLocs=centat;
        
        NSLog(@"---------------------ipLocsipLocsipLocsipLocsipLocsipLocs=%@",ipLocs);
        
        //插入数据
        
        [self materielIdOpen];
        
        //    [self saveopentimelist];//  保存游戏启动时间
        
        
        
        //请求数据接口
        
        [self performSelector:@selector(aftertime) withObject:self afterDelay:1.5];
        //  [self performSelector:@selector(storage::) withObject:_gameid,_chennalid afterDelay:5];
        //  [self storage:_gameid channelId:_chennalid];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //请求失败
        NSLog(@"Error: %@", error);
    }];
    
    
}



-(void)aftertime
{
    [self storage:_gameid channelId:_chennalid];
}


//判断空值***********空为YES/飞空为NO


- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}



#pragma mark ----计算时间差


- (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSLog(@"========================================计算时间差值");
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"0";
    
    
    NSTimeInterval cha=now-late;
    
//        if (cha/3600<1) {
//    
//            NSLog(@"========================================计算时间");
//    
//            timeString = [NSString stringWithFormat:@"%f", cha/60];
//            timeString = [timeString substringToIndex:timeString.length-7];
//            //timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
//    
//        }
    
    
    //        if (cha/3600>1&&cha/86400<1) {
    //            timeString = [NSString stringWithFormat:@"%f", cha/3600];
    //            timeString = [timeString substringToIndex:timeString.length-7];
    //           // timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    //        }
    
    
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        // timeString=[NSString stringWithFormat:@"%@天前", timeString];
        
    }
    
    //[date release];
    NSLog(@"-----------------------------------多少天后=%@",timeString);
    return timeString;
}




@end
