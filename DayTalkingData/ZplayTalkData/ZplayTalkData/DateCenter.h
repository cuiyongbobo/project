//
//  DateCenter.h
//  爱限免（复习）
//
//  Created by Zzd on 14-6-16.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AppModel.h"

@interface DateCenter : NSObject

+(instancetype)shareInstant;


// 添加收藏记录
-(void)addFavoriteRecord:(NSString *)gametime geocode:(NSString *)geocode  longitude:(NSString *)longitude latitude:(NSString *)latitude ipLoc:(NSString *)ipLoc accuracy:(NSString *) accuracy netModel:(NSString *)netModel;


// 添加收藏记录
-(void)addFavoriteRecordtime:(NSString *)clickTime materielId:(NSString *)materielId  advertisers:(NSString *)advertisers provider:(NSString *)provider;



// 添加收藏记录
-(void)addFavoriteRecordgame:(NSString *)gameId channelId:(NSString *)channelId;



// 获取所有数据
-(NSArray *)allFavoriteRecord;


// 获取所有数据
-(NSArray *)allFavoriteRecordtime;


// 获取所有数据
-(NSArray *)allFavoriteRecordgame;




//删除数据
-(void)deleteFavoriteRecord;


//删除数据
-(void)deleteFavoriteRecordtime;


//删除数据
-(void)deleteFavoriteRecordgame;





//// 检测这个记录是否收藏过
//-(BOOL)isExistsFavoriteRecordWithAppModel:(AppModel *)model;
//
//// 添加收藏记录
//-(void)addFavoriteRecordWithAppModel:(AppModel *)model;
//
//// 删除收藏记录
//-(void)deleteFavoriteRecordWithAppModel:(AppModel *)model;
//
//// 获取所有收藏的应用
//-(NSArray *)allFavoriteRecord;
//
////  检测是否被下载
//-(BOOL)isDownloadRecordWithAppModel:(AppModel *)model;
//
//// 添加下载记录
//-(void)addDownloadRecordWithAppModel:(AppModel *)model;
//
//// 删除下载记录
//-(void)deleteDownloadRecordWithAppModel:(AppModel *)model;
//
//// 获取所有下载过的应用
//-(NSArray *)allDownloadRecord;

@end
