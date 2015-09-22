//
//  SUser.h
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUser : NSObject

@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSString * text;

//-(SUser *)initWithDict:(NSDictionary *)dict strType:(NSString *)strType;
-(SUser *)initWithDict:(NSDictionary *)dict;
@end
