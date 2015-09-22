//
//  Slqite.h
//  sqliteDemo
//
//  Created by ZPLAY005 on 14-3-27.
//  Copyright (c) 2014年 vbdsgfht. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "GWCustomClass.h"

@interface GWSqlitelibray : NSObject


//数据库单利类
+(GWSqlitelibray *)shareInstance;



// 添加收藏记录
-(void)addFavoriteRecord:(NSString *)gametime geocode:(NSString *)geocode  longitude:(NSString *)longitude latitude:(NSString *)latitude ipLoc:(NSString *)ipLoc accuracy:(NSString *) accuracy netModel:(NSString *)netModel;


// 添加收藏记录
-(void)addFavoriteRecordtime:(NSString *)clickTime materielId:(NSString *)materielId  advertisers:(NSString *)advertisers provider:(NSString *)provider;





// 获取所有数据
-(NSArray *)allFavoriteRecord;



// 获取所有数据
-(NSArray *)allFavoriteRecordtime;




//删除数据
-(void)deleteFavoriteRecord;


//删除数据
-(void)deleteFavoriteRecordtime;


//删除数据
-(void)deleteFavoriteRecordtime :(NSString *)clickTime;











//-(void)insertDbaseType:(NSString *)typeStr Data1:(NSString *)oData Data2:(NSString *)sData Data1Url:(NSString *)oUrl Data2Url:(NSString *)sUrl;
//
//
//-(void)upDataDbaseType:(NSString *)type Bann1:(NSString *)Banner1 Bann2:(NSString *)Banner2 bann1url:(NSString *)oUrl bann2Url:(NSString *)sUrl;
//
//-(void)insertDbaseUrlP:(NSString *)path selectNum:(NSString *)num status:(NSString *)sta adviId:(NSString *)Advid;
//
//-(void)upDataDbaseOldurlPath:(NSString *)path selectNum:(NSString *)num;
//
//-(NSMutableArray *)SelectShangBaoSqlite;
//
//-(void)deleteDbase;
//
//-(BOOL)selectSfbdjb:(NSString *)asfbnbj;
//
//-(NSString *)selesdasd:(NSString *)afjgf;
//
//-(NSMutableArray *)SelectBannerSqlite;
//-(NSMutableArray *)SelectChapSqlite;


-(void)closeSqlite;
@end
