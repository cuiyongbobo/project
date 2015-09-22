//
//  TakeGPS.m
//  ZplayTalkData
//
//  Created by Lee on 14/12/17.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import "TakeGPS.h"

@interface TakeGPS ()

{
    CLLocationManager* locationmanager;
}
@end

@implementation TakeGPS

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark locationManager delegate





- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation

{
    
    NSLog(@"sssssss-------------------------------------hello");
    
    //打印出精度和纬度
    
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    NSLog(@"输出当前的精度和纬度");
    
    NSLog(@"精度：%f 纬度：%f",coordinate.latitude,coordinate.longitude);
    
    
   // latitude=coordinate.latitude;
    
   // longitude=coordinate.longitude;
    
    
    // NSURL *url=[NSURL URLWithString:QQUrls];
    
    
    
    //停止定位
    
    [locationmanager stopUpdatingLocation];
    
    //    水平经度，也就是显示经纬度的经度
   // accuracy = newLocation.horizontalAccuracy;
    
  //  NSLog(@"------------------------------------accuracy=%f",accuracy);
    
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
