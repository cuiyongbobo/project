//
//  ViewController.m
//  ZplayTalkData
//
//  Created by Lee on 14/12/10.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "ViewController.h"

#import "ZplayNoject.h"


#import "DateCenter.h"


#import "AFNetworking.h"

#import "AFHTTPRequestOperation.h"

#import "ASIHTTPRequest.h"



#import <ifaddrs.h>



#import <arpa/inet.h>

#import "Ipmodel.h"

#import "talkTatas.h"

#import "Zplay_TalkData.h"



#define QQUrls  @"http://api.map.baidu.com/geoconv/v1/?coords=%@&from=1&to=5&ak=YDvr8I2QbRc98QwkAzNWMbKa"



#define baiduUrl   @"http://api.map.baidu.com/geocoder/v2/?ak=YDvr8I2QbRc98QwkAzNWMbKa&callback=renderReverse&location=%@&output=json&pois=0"


#define URL @"http://os.zplayworld.com/getmessage.php"


#define IPUrl @"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js&ip=115.156.238.114"
//http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js&ip=115.156.238.114


//@"http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js&ip=%@"



//@"http://api.map.baidu.com/geocoder/v2/?ak=YDvr8I2QbRc98QwkAzNWMbKa&callback=renderReverse&location=%@&output=json&pois=0"


//http://apis.map.qq.com/ws/geocoder/v1/?location=39.984154,116.307490&coord_type=1&key=YN5BZ-ISF3D-MWN4D-PHGQA-HN4L5-3UBAQ&get_poi=0



@interface ViewController ()

{
    CLLocationManager* locationmanager;
    
    
    AFHTTPRequestOperationManager *manager; //创建请求（iOS 6-7）
}
@end

@implementation ViewController

//@synthesize locationmanager;

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

-(void)gameIDD:(NSString *)gameid chennalIDD:(NSString *)chennalid adverttime:(NSString *)time advflat:(NSString *)flats
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
    CGFloat phoneresolution=size_screen.width * scale_screen;
    NSLog(@"--------------------------------------phoneresolution=%f",phoneresolution);
    
    
    
    
    
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
    
    
    
    
    
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    NSLog(@"------------------------------locationString:%@",timeString);
    
    
    
    
    
    
    if ([[ZplayNoject shareInstance]isHaveConnect]) {
        NSLog(@"有网络连接");
        //请求数据接口
        /*
         1.数据库中有时间戳（多次请求）
         2.数据库中没有时间戳
         */
        
        
        NSArray *arr=[[DateCenter shareInstant]allFavoriteRecord];
        if ([arr count]>0) {
            
           // for (NSDictionary *dict in arr) {
                
                //每个数组的元素都是一个字典
                
                //        NSLog(@"------------------------gtime=%@",dict[@"gtime"]);
                //        NSLog(@"------------------------ctime=%@",dict[@"ctime"]);  1418285895710.041992
              //  NSLog(@"------------------------dcit=%@",dict);
                
               //请求接口 post
                
                
               
                
                //致空请求
                if (manager) {
                    manager = nil;
                }
                
                //创建请求
                manager = [AFHTTPRequestOperationManager manager];
                
                //设置请求的解析器为AFHTTPResponseSerializer（用于直接解析数据NSData），默认为AFJSONResponseSerializer（用于解析JSON）
                //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                
                /*
                 参数
                 ystemType=0&gameLabel=ZplaySniffSDK&gameId=zplay01&gameVersion=1.0&channelId=zplay01&sdkVersion=1.0.1&manufacture=Genymotion&model=Google Nexus 5 - 4.4.4 - API 19 - 1080x1920&displayMetrics=1080x1776&systemRelease=4.4.4&systemCode=19&language=zh_CN&IMEI=000000000000000&mac=08:00:27:c3:05:0e&openList=[{"geocode":"","longitude":"0.0","openTime":"1418367188937","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418367310343","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418367754212","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418367851267","latitude":"0.0","ipLoc":"","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418367851267","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418368386040","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418368609902","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418368627702","latitude":"0.0","ipLoc":"","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418368627702","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418369424336","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418369434425","latitude":"0.0","ipLoc":"","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418369434425","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418369512041","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418370934088","latitude":"0.0","ipLoc":"中国-北京-北京","accuracy":"0.0","netModel":"wifi"},{"geocode":"","longitude":"0.0","openTime":"1418370962179","latitude":"0.0","ipLoc":"","accuracy":"0.0","netModel":"wifi"}]
                     &clicklist=[{"clickTime":"1418370939518","materielId":"-2","advertisers":"other","provider":"Inmobi"},{"clickTime":"1418370943056","materielId":"-2","advertisers":"other","provider":"Admob"}]
                 
                  存到数据库：
                 ---------------openList
                 geocode
                 longitude
                 openTime
                 latitude
                 ipLoc
                 accuracy
                 netModel
                 
                 -----------------clicklist
                 clickTime
                 materielId
                 advertisers
                 provider
                 
                 
                 
                 */
                
            
                
                
                
                
                
                
                
                
         //   }
            
        }else{
            
            //数据库没有时间戳
            //请求接口
            
            
            
        }
        
        
        
        
        
    }else
    {
        
        NSLog(@"没有网络");
        //插入时间戳
        
        //获取系统当前的时间戳
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
        NSLog(@"------------------------------locationString:%@",timeString);
        
        //插入数据
    //    [[DateCenter shareInstant] addFavoriteRecord:timeString clicktime:timeString];
        
    }
    
    
}






- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(50, 100, 200, 50)];
    [button setTitle:@"点击广告" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor blueColor];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    
    
    
  //  [[talkTatas shareInstant]gameIDD:@"1" chennalIDD:@"1" materielId:@"1" advertisers:@"1" provider:@"1"];
    
    
  //  [[talkTatas shareInstant] GPs];
    
    
    //调用gps,获得经纬度
    //[talkTatas shareInstant];
  //  [[talkTatas shareInstant]gameIDD:@"1" chennalIDD:@"1" materielId:@"1" advertisers:@"1" provider:@"1"];
    
  //  [[DateCenter shareInstant] gameIDD:@"1" chennalIDD:@"1" materielId:@"1" advertisers:@"1" provider:@"1"];
    
    
    
    //[[talkTatas shareInstant]gameIDD:@"1" chennalIDD:@"1" materielId:@"1" advertisers:@"1" provider:@"1"];
    
    
    //获取gps
    // [self GPs];
    
    
    
    
  //  [self talkdata];
    
    
    
    //获取网络模式
 //   [self getNetWorkStates];
    
    
    
    
    //系统时间
    //    NSDate *  senddate=[NSDate date];
    //
    //    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    //
    //    [dateformatter setDateFormat:@"YYYYMMdd"];
    //
    //    NSString *  locationString=[dateformatter stringFromDate:senddate];
    //
    //    NSLog(@"------------------------------locationString:%@",locationString);
    
    
    
    
    
    //AFN 的使用
    
    
  //  [self afn];
    
    //[self asi];
    
   
    
    //IP 定位信息
    
  //  [self IPAfn];
   // [self getIPAddress];
    
    
    
    
}


-(void)click:(UIButton *)button
{
    [[talkTatas shareInstant] gameIDD:@"1" chennalIDD:@"1" materielId:@"1" advertisers:@"1" provider:@"1"];
    
    
}




-(void)IPAfn
{
    
    //致空请求
    if (manager) {
        manager = nil;
    }
    
    //创建请求
    manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    

    [manager GET:IPUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
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
        
        
        
      
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //请求失败
        NSLog(@"Error: %@", error);
    }];
    

    
    
    
}





//afn 使用

-(void)afn
{

#if 0
    
    
    //致空请求
    if (manager) {
        manager = nil;
    }
    
    //创建请求
    manager = [AFHTTPRequestOperationManager manager];
    
    //设置请求的解析器为AFHTTPResponseSerializer（用于直接解析数据NSData），默认为AFJSONResponseSerializer（用于解析JSON）
    //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //发送POST请求
    [manager POST:QQUrls parameters:prame success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //请求成功（当解析器为AFJSONResponseSerializer时）
        NSLog(@"Success: %@", responseObject);
        
        //请求成功（当解析器为AFHTTPResponseSerializer时）
        //        NSString *JSONString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //        NSLog(@"success:%@", JSONString);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //请求失败
        NSLog(@"Error: %@", error);
    }];
    
#endif
    
    
    
    
    //致空请求
    if (manager) {
        manager = nil;
    }
    
    //创建请求
    manager = [AFHTTPRequestOperationManager manager];
    NSString * s1 = @"116.333392,39.972857";
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
    
   // manager.requestSerializer=[AFHTTPRequestSerializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
   // NSString * s1 = @"116.333392,39.972857";
    
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
       // NSLog(@"------------------------content=%@",content[@"result"]);
        
        NSDictionary *currendict=content[@"result"];
        
        
        
        NSLog(@"-----------------------------------dictttttt:  %@",currendict[@"formatted_address"]);
       
        //保存
        
      //  geocode=currendict[@"formatted_address"];
        
        
        
        
        
      //  return currendict[@"formatted_address"];
        
      
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"----------------------------------error");
        
        //请求失败
        NSLog(@"Error: %@", [error description]);
        
    }];
    
    
    
}



-(void)asi
{
    NSString *urlString = @"http://www.baidu.com";
    ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    //开始异步请求
    //设置代理作用: 数据下载完成后能通知我们
    //遵守协议: ASIHTTPRequestDelegate
    httpRequest.delegate = self;
    [httpRequest startAsynchronous];
    
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






-(void)talkdata
{
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
     
     游戏名称（应用名称 gameLabel）、游戏ID（gameId传）、游戏版本（gameVersion应用版本）、渠道（channelId传）、SDK版本（sdkVersion写死）
     
     设备品牌（manufacture手机品牌）、设备型号（model手机型号）、设备分辨率（displayMetrics手机分辨率）、OS版本（systemRelease手机系统）、
     systemCode=@"0"
     
     手机语言（language获取手机）
     
     MAC（mac地址）、PLMN（）、IDFA（IMEI）、GPS（）、网络模式（WiFi/2G/3G/4G）、
     
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
    CGFloat phoneresolution=size_screen.width * scale_screen;
    NSLog(@"--------------------------------------phoneresolution=%f",phoneresolution);
    
    
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
    
    
    
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%f", a]; //转为字符型
    NSLog(@"------------------------------locationString:%@",timeString);
    
    
    
    if ([[ZplayNoject shareInstance]isHaveConnect]) {
        NSLog(@"有网络连接");
        
        
        //插入数据
        // [[DateCenter shareInstant] addFavoriteRecord:timeString clicktime:timeString];
        
        
    }else
    {
        NSLog(@"没有网络");
    }
    
    
    
    
    NSArray *arr=[[DateCenter shareInstant]allFavoriteRecord];
    for (NSDictionary *dict in arr) {
        
        //每个数组的元素都是一个字典
        
        //        NSLog(@"------------------------gtime=%@",dict[@"gtime"]);
        //        NSLog(@"------------------------ctime=%@",dict[@"ctime"]);  1418285895710.041992
        NSLog(@"------------------------dcit=%@",dict);
        
    }
    
}








- (NSString*)getPreferredLanguage

{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    NSLog(@"当前语言:%@", preferredLang);//zh-Hans----简体中文
    
    return preferredLang;
    
}




//GPRS定位

-(void)GPs
{
    
    locationmanager = [[CLLocationManager alloc]init];
    locationmanager.delegate = self;
    locationmanager.desiredAccuracy = kCLLocationAccuracyBest;
    locationmanager.distanceFilter = 10;
    [locationmanager requestAlwaysAuthorization];//添加这句
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
    
    
    // NSURL *url=[NSURL URLWithString:QQUrls];
    
    
    //停止定位
    
     NSLog(@"------------------------------------accuracy=%f",newLocation.horizontalAccuracy);
    
    [locationmanager stopUpdatingLocation];
    
    
    
    //计算两个位置的距离
    
    float distance = [newLocation distanceFromLocation:oldLocation];
    
    
    
    NSLog(@" 距离 %f",distance);
    
    
    
    
    
    
    
}



- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}








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





////处理下载完成
//-(void)requestFinished:(ASIHTTPRequest *)request
//{
//    NSLog(@"下载数据为 %@",request.responseString);
//    
//    
//    
//    
//}
//-(void)requestFailed:(ASIHTTPRequest *)request
//{
//    NSLog(@"请求失败");
//}


-(void)afnpost:(NSString *)pra
{
    
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



@end
