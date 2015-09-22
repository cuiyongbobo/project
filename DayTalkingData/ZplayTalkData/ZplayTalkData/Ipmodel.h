//
//  Ipmodel.h
//  ZplayTalkData
//
//  Created by Lee on 14/12/15.
//  Copyright (c) 2014年 Lee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ipmodel : NSObject

/*
"ret":1,
"start":"115.156.128.0",
"end":"115.156.255.255",
"country":"\u4e2d\u56fd",
"province":"\u6e56\u5317",
"city":"\u6b66\u6c49",
"district":"",
"isp":"\u6559\u80b2\u7f51",
"type":"\u5b66\u6821",
"desc":"\u534e\u4e2d\u79d1\u6280\u5927\u5b66\u4e1c\u6821\u533a\u6559\u80b2\u7f51"
*/

@property (nonatomic,assign) NSString *ret;
@property (nonatomic,assign) NSString *start;
@property (nonatomic,assign) NSString *end;
@property (nonatomic,assign) NSString *country;
@property (nonatomic,assign) NSString *province;
@property (nonatomic,assign) NSString *city;
@property (nonatomic,assign) NSString *district;
@property (nonatomic,assign) NSString *isp;
@property (nonatomic,assign) NSString *type;
@property (nonatomic,assign) NSString *desc;




@end
