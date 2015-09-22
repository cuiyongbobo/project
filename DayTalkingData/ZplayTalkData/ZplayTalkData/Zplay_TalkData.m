//
//  Zplay_TalkData.m
//  ZplayTalkData
//
//  Created by Lee on 14/12/16.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "Zplay_TalkData.h"


#import "ZplayNoject.h"


#import "DateCenter.h"


#import "AFNetworking.h"

#import "AFHTTPRequestOperation.h"



#import <ifaddrs.h>



#import <arpa/inet.h>


#import "Reachability.h"



#define QQUrls  @"http://api.map.baidu.com/geoconv/v1/?coords=%@&from=1&to=5&ak=YDvr8I2QbRc98QwkAzNWMbKa"



#define baiduUrl   @"http://api.map.baidu.com/geocoder/v2/?ak=YDvr8I2QbRc98QwkAzNWMbKa&callback=renderReverse&location=%@&output=json&pois=0"

#define TalkDataUrl @"http://os.zplayworld.com/getmessage.php"


#define IPUrl @"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js&ip=%@"



@interface Zplay_TalkData ()
{
    
    CLLocationManager* locationmanager;
    AFHTTPRequestOperationManager *manager; //创建请求（iOS 6-7）
    
    Reachability  *hostReach;
    
    double  latitude;
    double  longitude;
    float   accuracy;
    NSString *geocode;
    
    NSString  *ipLocs;
}


@end

@implementation Zplay_TalkData

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
  //  [];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark ----暴漏出来的接口


-(void)gameIDD:(NSString *)gameid chennalIDD:(NSString *)chennalid materielId:(NSString *)materielId advertisers:(NSString *)advertisers provider:(NSString *)provider
{
    NSLog(@"--------------------------------开始测试数据");
    
    
    //保存数据
    self.materielId=materielId;
    self.advertisers=advertisers;
    self.provider=provider;
    
    
    if ([[ZplayNoject shareInstance]isHaveConnect]) {
        NSLog(@"有网络连接");
        
        
        //调用gps,获得经纬度
       // [self GPs];
        
        //通过gps获得的经纬度 来让百度编码出滴名字
        [self afn];
        
        //获得ip 地址参数
        [self IPAfn];
        
        
        //插入数据
        
        [self materielId:_materielId advertisers:_advertisers provider:_provider];
        
        //请求数据接口
        
        [self storage:gameid channelId:chennalid];
        
        
        
        
    }else
    {
        
        NSLog(@"没有网络");
        
        //由网路获取的参数，统一设置为0
        latitude=0.0;
        longitude=0.0;
        accuracy=0.0;
        geocode=@"0";
        ipLocs=@"0";
        
        //插入数据
        
        [self materielId:_materielId advertisers:_advertisers provider:_provider];
        
        //存储gameid,channelid
        [[DateCenter shareInstant]addFavoriteRecordgame:gameid channelId:chennalid];
        
        
        // SystemConfiguration.framework
        
        // 监测网络情况
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanged:)
                                                     name: kReachabilityChangedNotification
                                                   object: nil];
        hostReach =[Reachability reachabilityWithHostName:TalkDataUrl];
        
        [hostReach startNotifier];
        
    }
    
    
}



#pragma mark----检测网络状态

- (void) reachabilityChanged: (NSNotification*)note {
    
    
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {
        NSLog(@"网络不可用");
        
        
    }
    
    NSArray *arr=[[DateCenter shareInstant] allFavoriteRecordgame];
    
    [self storage:arr[0] channelId:arr[1]];
    
    
    
}









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

-(void)GPs
{
    NSLog(@"--------------------------执行");
    
    locationmanager = [[CLLocationManager alloc]init];
    locationmanager.delegate = self;
    [locationmanager requestAlwaysAuthorization];
    locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
    locationmanager.distanceFilter = kCLDistanceFilterNone;
    [locationmanager startUpdatingLocation];
    
    
    
   
    
}



#pragma mark locationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation


{
    
    NSLog(@"-------------------------------------hello");
    
    //打印出精度和纬度
    
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    NSLog(@"输出当前的精度和纬度");
    
    NSLog(@"精度：%f 纬度：%f",coordinate.latitude,coordinate.longitude);
    
    
    latitude=coordinate.latitude;
    
    longitude=coordinate.longitude;
    
    
    // NSURL *url=[NSURL URLWithString:QQUrls];
    
    
    
    //停止定位
    
    [locationmanager stopUpdatingLocation];
    
    //    水平经度，也就是显示经纬度的经度
    accuracy = newLocation.horizontalAccuracy;
    
    NSLog(@"------------------------------------accuracy=%f",accuracy);
    
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"-------------------------只能怪");
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
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
            
            switch (netType) {
                case 0:
                    state = @"无网络";
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
    }
    
    NSLog(@"----------------------------state=%@",state);
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
    
    NSString *text =[NSString stringWithFormat:@"%@ %@",appName,versionNum];
    
    
    NSLog(@"-----------------------------text=%@",text);
    
    
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
    
    //致空请求
    if (manager) {
        manager = nil;
    }
    
    
    
    //NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    
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
    
    [params setObject:Plmn forKey:@"plmn"];
    NSLog(@"------------------------plmn=%@",params[@"plmn"]);
    
    [params setObject:deviceName forKey:@"manufacture"];
    NSLog(@"------------------------manufacture=%@",params[@"manufacture"]);
    
    [params setObject:phoneModel forKey:@"model"];
    NSLog(@"------------------------model=%@",params[@"model"]);
    
    [params setObject:[NSString stringWithFormat:@"%@",phoneresolution] forKey:@"displayMetrics"];
    NSLog(@"------------------------displayMetrics=%@",params[@"displayMetrics"]);
    
    [params setObject:phoneVersion forKey:@"systemRelease"];
    NSLog(@"------------------------systemRelease=%@",params[@"systemRelease"]);
    
    [params setObject:@"0" forKey:@"systemCode"];
    NSLog(@"------------------------systemCode=%@",params[@"systemCode"]);
    
    [params setObject:[self getPreferredLanguage] forKey:@"language"];
    NSLog(@"------------------------language=%@",params[@"language"]);
    
    [params setObject:Idfa forKey:@"IMEI"];
    NSLog(@"------------------------IMEI=%@",params[@"IMEI"]);
    
    [params setObject:MacAddress forKey:@"mac"];
    NSLog(@"------------------------mac=%@",params[@"mac"]);
    
    
    //    if ([[DateCenter shareInstant]allFavoriteRecord]==nil) {
    //
    //        NSLog(@"------------------------openList");
    //        NSArray *arr=[NSArray arrayWithObjects:@"1",@"2", nil];
    //
    //         [params setObject:arr forKey:@"openList"];
    //    }else
    //    {
    //        [params setObject:[[DateCenter shareInstant]allFavoriteRecord] forKey:@"openList"];
    //        NSLog(@"------------------------openList=%@",params[@"openList"]);
    //    }
    
    
    [params setObject:[[DateCenter shareInstant]allFavoriteRecord] forKey:@"openList"];
    
    NSLog(@"------------------------openList=%@",params[@"openList"]);
    
    
    //[params setObject:@"0" forKey:@"openList"];
    [params setObject:[[DateCenter shareInstant] allFavoriteRecordtime] forKey:@"clicklist"];
    NSLog(@"------------------------clicklist=%@",params[@"clicklist"]);
    
    
    
    
    //发送POST请求
    [manager POST:TalkDataUrl parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //请求成功（当解析器为AFJSONResponseSerializer时）
        NSLog(@"Success: %@", responseObject);
        //如果返回结果成功 ，调用数据库中得删除方法
        
        
        
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //请求失败,存入数据
        [self materielId:_materielId advertisers:_advertisers provider:_provider];
        
        //存储gameid,channelid
        [[DateCenter shareInstant]addFavoriteRecordgame:gameId channelId:channelId];
        
        //请求失败
        NSLog(@"Error: %@", error);
        
    }];
    
}





#pragma mark ----无网络的时候存储数据库

-(void)materielId:(NSString *)materielId advertisers:(NSString *)advertisers provider:(NSString *)provider
{
    NSLog(@"////////////////////////////////有望");
    
    if ([[ZplayNoject shareInstance]isHaveConnect]) {
        
        NSLog(@"////////////////////////////////有望");
        
        
        //获取ip 地址信息
        // [self IPAfn];
        
        //调用gps
        
        // [self afn];
        
        
        /*
         openTime
         netModel
         latitude
         longitude
         accuracy
         geocode
         ipLoc
         
         这些参数，都为0
         
         */
        
        
        //clickTime,materielId,advertisers,provider
        
        //获取系统当前的时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
        NSLog(@"------------------------------locationString:%@",timeString);
        
        
        
        
        
        [[DateCenter shareInstant] addFavoriteRecordtime:timeString materielId:materielId advertisers:advertisers provider:provider];
        
        
        
        
        //gametime,geocode,longitude,latitude,ipLoc,accuracy,netModel
        
        
        
       // NSLog(@"-----------------------------------geocodegeocode=%@",geocode);
        //        [[DateCenter shareInstant] addFavoriteRecord:timeString geocode:geocode longitude:[NSString stringWithFormat:@"%f",longitude] latitude:[NSString stringWithFormat:@"%f",latitude] ipLoc:ipLocs accuracy:[NSString stringWithFormat:@"%f",accuracy] netModel:[self getNetWorkStates]];
        
        [[DateCenter shareInstant] addFavoriteRecord:timeString geocode:@"北京" longitude:[NSString stringWithFormat:@"%f",32.2] latitude:[NSString stringWithFormat:@"%f",113.2] ipLoc:ipLocs accuracy:[NSString stringWithFormat:@"%f",20.3] netModel:[self getNetWorkStates]];
        
        
        
    }else{
        
        NSLog(@"////////////////////////////////无望");
        //获取ip 地址信息
        // [self IPAfn];
        
        //调用gps
        
        // [self afn];
        
        
        /*
         openTime
         netModel
         latitude
         longitude
         accuracy
         geocode
         ipLoc
         
         这些参数，都为0
         
         */
        
        
        //clickTime,materielId,advertisers,provider
        
        //获取系统当前的时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
        NSLog(@"------------------------------locationString:%@",timeString);
        
        
        
        
        
        [[DateCenter shareInstant] addFavoriteRecordtime:timeString materielId:materielId advertisers:advertisers provider:provider];
        
        
        
        
        //gametime,geocode,longitude,latitude,ipLoc,accuracy,netModel
        
        // NSLog(@"-----------------------------------geocodegeocode=%@",geocode);
        
        
        [[DateCenter shareInstant] addFavoriteRecord:timeString geocode:geocode longitude:[NSString stringWithFormat:@"%f",longitude] latitude:[NSString stringWithFormat:@"%f",latitude] ipLoc:ipLocs accuracy:[NSString stringWithFormat:@"%f",accuracy] netModel:@"0"];
        
        
        
    }
    
    
    
}


#pragma mark -------获取IP


// Get IP Address
- (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    NSLog(@"---------------IP=%@",address);
    return address;}



#pragma mark --------获取ip地址


-(void)IPAfn
{
    
    
    //致空请求
    if (manager) {
        manager = nil;
    }
    
    //创建请求
    manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString *url=[NSString stringWithFormat:IPUrl,[self getIPAddress]];
    
    
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        NSString *substr= [str substringFromIndex:21];
        
        NSRange range;
        range=[substr rangeOfString:@";"];
        NSString *newstr=[substr substringToIndex:(range.location)];
        
        NSLog(@"------------------------ipcity=%@",newstr);
        NSData *data=[newstr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        
        NSString *centat=[NSString stringWithFormat:@"%@-%@-%@",dict[@"country"],dict[@"province"],dict[@"city"]];
        
        NSLog(@"------------------------ipcity=%@",centat);
        
        
        
        ipLocs=centat;
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //请求失败
        NSLog(@"Error: %@", error);
    }];
    
    
}












/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
