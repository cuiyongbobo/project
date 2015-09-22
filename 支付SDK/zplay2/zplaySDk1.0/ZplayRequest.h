//
//  ZplayRequest.h
//  Zpaly
//
//  Created by ZPLAY005 on 13-12-31.
//  Copyright (c) 2013年 ZPLAY005. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZplayRequest;
@class Zplay;


@protocol ZplayRequestDelegate <NSObject>
@optional
- (void)request:(ZplayRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(ZplayRequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(ZplayRequest *)request didFailWithError:(NSError *)error;
- (void)request:(ZplayRequest *)request didFinishLoadingWithResult:(id)result;
@end



@interface ZplayRequest : NSObject <NSURLConnectionDataDelegate,NSURLConnectionDelegate>
{
    __weak Zplay  *zplay;
    
    NSString                *url;
    NSString                *httpMethod;
    NSDictionary            *params;
    NSURLConnection         *connection;
    NSMutableData           *responseData;
    __weak id<ZplayRequestDelegate>    delegate;
}



@property(nonatomic,weak)Zplay *zplay;
@property(nonatomic,retain)NSString *url;
@property(nonatomic,retain)NSString *httpMethod;
@property(nonatomic,retain)NSDictionary *params;
@property(nonatomic,weak)id<ZplayRequestDelegate> delegate;

+(ZplayRequest *)requestWithUrl:(NSString *)url
                     httpMethod:(NSString *)httpMethod
                         params:(NSDictionary *)params
                       delegate:(id<ZplayRequestDelegate>)delegate;
- (void)connect;

- (void)disconnect;



@end
