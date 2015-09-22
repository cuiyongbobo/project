//
//  Slqite.m
//  sqliteDemo
//
//  Created by ZPLAY005 on 14-3-27.
//  Copyright (c) 2014年 vbdsgfht. All rights reserved.
//

#import "Slqite.h"
#import "FMDatabase.h"
#import <sqlite3.h>
#import "DefineObjcs.h"
@implementation Slqite
{
 
    FMDatabase *db;

}
#pragma mark- 单例
+(Slqite *)shareInstance
{
    static Slqite *mainVCtrl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mainVCtrl = [[self alloc] init];
    });
    return mainVCtrl;
}

-(void)createDBase
{
    
    if (!db) {
        [self createDBPath];
    }
    if ([db open]) {
        

        BOOL res=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS UserSYSTable(ID INTEGER PRIMARY KEY AUTOINCREMENT,UserID TEXT UNIQUE,UserName TEXT,PassWord TEXT)"];
        if (!res) {
            NSLog(@"数据库创建失败");

        }else
        {
            NSLog(@"数据库创建成功");
        }
        return;
    }
    
    
}
-(NSString *)dataBasefliPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:SQLITE_NAME];
    return path;
}
-(void)createDBPath
{
    
    db=[[FMDatabase databaseWithPath:[self dataBasefliPath]] retain];

}
-(void)insertDbaseUserId:(NSString *)userId UserName:(NSString *)userName Password:(NSString *)pwd
{
    if ([db open]) {
        NSString *inserteSqlite=[NSString stringWithFormat:@"INSERT INTO '%@'('%@','%@','%@') VALUES ('%@','%@','%@')",SQLITE_TABLE_NAME,SQLITE_USERID,SQLITE_USERNAME,SQLITE_PASSWORD,userId,userName,pwd];
        BOOL res=[db executeUpdate:inserteSqlite];
        if (!res) {
            NSLog(@"数据库插入失败");

        }else
        {
            NSLog(@"数据库插入成功");
        }
        return;
    }
}
-(void)upDataDbaseOldUserId:(NSString *)userId UserName:(NSString *)userName Password:(NSString *)pwd
{
    BOOL res=0;
    if ([db open]) {

        if (userName.length !=0) {
            res=[db executeUpdate:@"UPDATE UserSYSTable SET UserName =? WHERE UserID=?",userName,userId];
        }
        if (!res) {
            NSLog(@"数据库更新失败");
            
        }else{
            NSLog(@"数据库更新成功");
        }
        if (pwd.length !=0 )
        {

            res=[db executeUpdate:@"UPDATE UserSYSTable SET PassWord =? WHERE UserID=?",pwd,userId];
        }
        
        if (!res) {
            NSLog(@"数据库更新失败");

        }else{
             NSLog(@"数据库更新成功");
        }
        return;
    }
}
-(void)deleteDbaseUserNmae:(NSString *)userId
{
    if ([db open]) {

        BOOL res=[db executeUpdate:@"DELETE FROM UserSYSTable WHERE UserID=?",userId];
        if (res) {
            NSLog(@"删除成功");
        }else{
            NSLog(@"删除失败");

        }
        return;
    }
}
-(NSMutableArray *)SelectSqlite
{
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM %@",SQLITE_TABLE_NAME];
    FMResultSet *rs=[db executeQuery:sql];
    NSMutableArray *mArry=[NSMutableArray arrayWithCapacity:[rs columnCount]];
    while ([rs next]) {
        
        NSString *userName=[rs stringForColumn:SQLITE_USERNAME];
        
        NSString *userID=[rs stringForColumn:SQLITE_USERID];
        
        NSString *zID=[rs stringForColumn:@"ID"];
        
        NSString *passWord=[rs stringForColumn:SQLITE_PASSWORD];
        
        NSDictionary *dic=@{SQLITE_USERNAME: userName,
                            SQLITE_USERID:userID,
                            SQLITE_ZID:zID,
                            SQLITE_PASSWORD:passWord};
        NSLog(@"dic=%@",dic);
        
        [mArry addObject:dic];
    }

     NSLog(@"%@",mArry);
    return mArry;
}


-(void)closeSqlite
{
    [db close];
}
@end
