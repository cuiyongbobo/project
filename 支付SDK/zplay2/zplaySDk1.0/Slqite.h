//
//  Slqite.h
//  sqliteDemo
//
//  Created by ZPLAY005 on 14-3-27.
//  Copyright (c) 2014年 vbdsgfht. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Slqite : NSObject
+(Slqite *)shareInstance;
-(void)createDBase;
-(void)insertDbaseUserId:(NSString *)userId UserName:(NSString *)userName Password:(NSString *)pwd;
-(void)upDataDbaseOldUserId:(NSString *)Id UserName:(NSString *)userName Password:(NSString *)pwd;
-(void)deleteDbaseUserNmae:(NSString *)userId;
-(NSMutableArray *)SelectSqlite;

-(void)closeSqlite;
@end
