//
//  ZplaySendNotify.m
//  zplaySDk1.0
//
//  Created by MyDelegate on 14/11/6.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

#import "ZplaySendNotify.h"
@implementation ZplaySendNotify
@synthesize myDelegate;
+(ZplaySendNotify *)sharedInstance
{
    static ZplaySendNotify *defaultZplayNotify = nil;
    @synchronized(self){
        if (defaultZplayNotify == nil){
            defaultZplayNotify = [[ZplaySendNotify alloc]init];
        }
    }
    return defaultZplayNotify;
}


    



@end
