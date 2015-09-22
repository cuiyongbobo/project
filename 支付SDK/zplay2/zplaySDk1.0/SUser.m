//
//  SUser.m
//  SDatabase
//
//  Created by SunJiangting on 12-10-20.
//  Copyright (c) 2012年 sun. All rights reserved.
//

#import "SUser.h"

@implementation SUser

- (SUser *)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        //用户ID
        if (!self.uid) {
            self.uid = [dict objectForKey:@"userid"];
        }
        //用户名
        if (!self.name) {
            self.name = [dict objectForKey:@"username"];
        }
        if (!self.code) {
            self.code = [dict objectForKey:@"code"];
        }
//        self.description = [dict objectForKey:@"description"];
        self.text = [dict objectForKey:@"text"];
    }
    return self;
}

@end
