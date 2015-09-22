//
//  ZplayRequest.m
//  Zpaly
//
//  Created by ZPLAY005 on 13-12-31.
//  Copyright (c) 2013年 ZPLAY005. All rights reserved.
//

#import "ZplayRequest.h"
#import "Zplay.h"
#import "XMLDictionary.h"
#define kZplaySDKerrorDomain   @"ZplaySDKErrorDomain"

@interface Zplay (SinaWeiboRequest)<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
- (void)requestDidFinish:(ZplayRequest *)request;

@end
@interface ZplayRequest (Private)

- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData;

//处理响应数据
- (void)handleResponseData:(NSData *)data;

//解析json数据
- (id)parseJSONData:(NSData *)data error:(NSError **)error;

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo;
- (void)failedWithError:(NSError *)error;
@end

@interface Zplay (ZplayRequest)
- (void)requestDidFinish:(ZplayRequest *)request;
@end

@implementation ZplayRequest

@synthesize zplay;
@synthesize url;
@synthesize httpMethod;
@synthesize params;
@synthesize delegate;
- (void)dealloc
{
    zplay=nil;
    [url release], url = nil;
    [httpMethod release], httpMethod = nil;
    [params release], params = nil;
    
    [responseData release];
	responseData = nil;
    
    [connection cancel];
    [connection release], connection = nil;
    
    [super dealloc];
}

#pragma mark-获取请求参数
+(ZplayRequest *)requestWithUrl:(NSString *)url
                     httpMethod:(NSString *)httpMethod
                         params:(NSDictionary *)params
                       delegate:(id<ZplayRequestDelegate>)delegate
{
    ZplayRequest *request = [[[ZplayRequest alloc] init] autorelease];
    
    request.url = url;
    request.httpMethod = httpMethod;
    request.params = params;
    request.delegate = delegate;
    
    return request;
}

#pragma mark-处理响应数据
- (void)handleResponseData:(NSData *)data
{
    
    NSString *strdata=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"----------------------------------------------------------------------%@",strdata);
       if ([delegate respondsToSelector:@selector(request:didReceiveRawData:)])
    {
        [delegate request:self didReceiveRawData:data];
    }
    
	NSError *error = nil;
  
	id result = [self parseJSONData:data error:&error];
    if (error)
	{
		[self failedWithError:error];
	}
	else
	{
        if (result) {
            NSString *codeText=nil;
            NSDictionary *msgDic=Nil;
            if([result isKindOfClass:[NSDictionary class]])
            {
                msgDic=[result objectForKey:@"msg"];
                codeText=[msgDic objectForKey:@"text"] ;
            }
            if ([delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)])
            {
                [delegate request:self didFinishLoadingWithResult:(result == nil ? data : result)];
            }

        }else
        {
            [self disconnect];
            NSError *error=[[NSError alloc]initWithDomain:@"经解析后无数据" code:0 userInfo:Nil];
            [self failedWithError:error];
            [error release];
            }
        	}
}

#pragma mark- 合成json数据
-(NSData *)compoundJSONData:(NSDictionary *)dic
{
    NSError *error=Nil;
    NSData *data=[NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    if (error !=Nil) {
        return nil;
    }
    [error release]; error=nil;
    return data;
}


#pragma mark-解析json数据
- (id)parseJSONData:(NSData *)data error:(NSError **)error
{
   
    NSError *parseError=nil;
      id  jsonData=[NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
    if (parseError) {
        jsonData=Nil;
    }
    return jsonData;
}

- (id)errorWithCode:(NSInteger)code userInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:kZplaySDKerrorDomain code:code userInfo:userInfo];
}

#pragma mark-响应出错delegate方法
- (void)failedWithError:(NSError *)error
{
	if ([delegate respondsToSelector:@selector(request:didFailWithError:)])//如果响应了这个方法   返回布尔值
	{
		[delegate request:self didFailWithError:error];
	}
}

#pragma mark- 请求方法主题
- (void)connect
{
    NSURL *urls=[NSURL URLWithString:self.url];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]init];
   
    [request setURL:urls];
    [request setHTTPMethod:self.httpMethod];
    [request setTimeoutInterval:30];
        NSData *jsonData=[self compoundJSONData:self.params];
        NSString *str=[[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [request setHTTPBody:[NSData dataWithBytes:[str UTF8String] length:strlen([str UTF8String])]];
          NSLog(@"------------%@",str);
         [str release];
    NSLog(@"%@",self.url);
    [request setValue:@"application/x-www.form-urlencoded" forHTTPHeaderField:@"Accept"];
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}

#pragma mark- 取消请求
-(void)disconnect
{

    [responseData release];
	responseData = nil;
    
    [connection cancel];
    [connection release], connection = nil;


}

#pragma  mark - NSURLConnection 代理方法
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
	
	if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)])//如果响应这个方法 返回布尔值
        
    {
		[delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   	[responseData appendData:data];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
	[self handleResponseData:responseData];
   	[responseData release];
	responseData = nil;
    
    [connection cancel];
	[connection release];
	connection = nil;
    [zplay requestDidFinish:self];
}



- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
	
    [self failedWithError:error];
    [responseData release];
	responseData = nil;
    [connection cancel];
	[connection release];
	connection = nil;
    [zplay requestDidFinish:self];
    
}
@end


