//
//  ZplaySendNotify.h
//  zplaySDk1.0
//
//  Created by MyDelegate on 14/11/6.
//  Copyright (c) 2014年 ZPLAY005. All rights reserved.
//

typedef enum {
    ZplayLoginResult,
    ZplayRegisterResult
    
}resultType;

#import <Foundation/Foundation.h>

@protocol AddObserverDelegate <NSObject>

- (void)addObserver:(id)info result:(resultType)type;

@end



@interface ZplaySendNotify : NSObject

@property(nonatomic,assign)id<AddObserverDelegate> myDelegate;


+ (ZplaySendNotify *)sharedInstance;


@end
