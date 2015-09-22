//
//  talkTatas.h
//  ZplayTalkData
//
//  Created by Lee on 14/12/12.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <CoreLocation/CoreLocation.h>


@interface talkTatas : NSObject <CLLocationManagerDelegate>

+(instancetype)shareInstant;


-(void)gameIDD:(NSString *)gameid chennalIDD:(NSString *)chennalid materielId:(NSString *)materielId advertisers:(NSString *)advertisers provider:(NSString *)provider;

-(void)Opengametime;





@property (nonatomic,assign) NSString *materielId;
@property (nonatomic,assign) NSString *advertisers;
@property (nonatomic,assign) NSString *provider;
@property (nonatomic,assign) NSString *gameid;
@property (nonatomic,assign) NSString *chennalid;

@property(nonatomic,retain)CLLocationManager* locationmanager;




@end
