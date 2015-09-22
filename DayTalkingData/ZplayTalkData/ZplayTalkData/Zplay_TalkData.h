//
//  Zplay_TalkData.h
//  ZplayTalkData
//
//  Created by Lee on 14/12/16.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <CoreLocation/CoreLocation.h>



@interface Zplay_TalkData : UIViewController<CLLocationManagerDelegate>


+(instancetype)shareInstant;

-(void)gameIDD:(NSString *)gameid chennalIDD:(NSString *)chennalid materielId:(NSString *)materielId advertisers:(NSString *)advertisers provider:(NSString *)provider;
-(void)GPs;

@property (nonatomic,assign) NSString *materielId;
@property (nonatomic,assign) NSString *advertisers;
@property (nonatomic,assign) NSString *provider;


@end
