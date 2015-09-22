//
//  Slqite.m
//  sqliteDemo
//
//  Created by ZPLAY005 on 14-3-27.
//  Copyright (c) 2014年 vbdsgfht. All rights reserved.
//

#import "GWSqlitelibray.h"
#import "FMDatabase.h"

#define SQLITE_NAME  @"GWUrl.sqlite"
#define SQLITE_BANNERTABLE_NAME @"ChapPathTableTime"
#define SQLITE_CHAPINGTABLE_NAME @"ChapPathTable"
#define SQLITE_SHANGBAO_NAME     @"ShangBaoTable"

#define Sqlite_Banner1Data   @"banner1"
#define Sqlite_Banner2Data   @"banner2"
#define Sqlite_Banner1Url    @"banner1Url"
#define Sqlite_Banner2Url    @"banner2Url"
#define Sqlite_Chap1Data   @"chap1"
#define Sqlite_Chap2Data   @"chap2"
#define Sqlite_Chap1Url    @"chap1Url"
#define Sqlite_Chap2Url    @"chap2Url"

#define SQLITE_UrlPath  @"url"
#define SQLITE_Number   @"num"
#define SQLITE_Status   @"advtype"
#define SQLITE_Advid    @"advid"




@implementation GWSqlitelibray
{
 
    FMDatabase *db;

}


#pragma mark- 单例
+(GWSqlitelibray *)shareInstance
{
    static GWSqlitelibray *mainVCtrl = nil;
    static dispatch_once_t onceToken;
    
    //使用GCD的dispatch_once创建单例
    dispatch_once(&onceToken, ^{
        mainVCtrl = [[self alloc] init];
    });
    return mainVCtrl;
}

-(id)init
{
    if (self=[super init]) {


    [self createBannerDBase]; //创建数据库
        
        
    [self createChapDBase];
        
        
   //  [self createShangbaoDbase];

     
        
        

    }
    return self;
}



//创建数据库

-(void)createBannerDBase
{
    
    if (!db) {
        [self createBannerDBPath];
    }
    
    //打开数据
    if ([db open]) {
        

        BOOL bannerRes=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS ChapPathTableTime(ID INTEGER PRIMARY KEY AUTOINCREMENT,clickTime TEXT,materielId TEXT,advertisers TEXT,provider TEXT)"];
        if (!bannerRes) {
            NSLog(@"Banner数据库创建失败");

        }else
        {
            NSLog(@"Banner数据库创建成功");
        }
        
        

        return;
    }
    
    
}







-(void)createChapDBase
{

    if (!db) {
        
        //Documents目录
        [self createChapingDBPath];
        
    }
    if ([db open]) {
        
        
        BOOL chapRes=[db executeUpdate:@"CREATE TABLE IF NOT EXISTS ChapPathTable(ID INTEGER PRIMARY KEY AUTOINCREMENT,gametime TEXT,geocode TEXT,longitude TEXT,latitude TEXT,ipLoc TEXT,accuracy TEXT,netModel TEXT)"];
        if (!chapRes) {
            NSLog(@"Chap数据库创建失败");
            
        }else
        {
            NSLog(@"Chap数据库创建成功");
        }
        
        
        
        return;
    }
    

    
}





-(void)createBannerDBPath
{

    db=[FMDatabase databaseWithPath:[self dataBasefliPath:SQLITE_BANNERTABLE_NAME]];
    
}



-(void)createChapingDBPath
{
    
    db=[FMDatabase databaseWithPath:[self dataBasefliPath:SQLITE_CHAPINGTABLE_NAME]];
    
}



//Documents目录
-(NSString *)dataBasefliPath:(NSString*)path
{
    
    //Documents目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathLj = [documentsDirectory stringByAppendingPathComponent:path];
    
    /*
     打印结果如下：
     path:   /Users/apple/Library/Application Support/iPhone Simulator/4.3/Applications/550AF26D-174B-42E6-881B-B7499FAA32B7/Documents
     */
    
    NSLog(@"数据库地址:%@",pathLj);
    
    return pathLj;
}




#pragma mark -----表一


-(void)addFavoriteRecord:(NSString *)gametime geocode:(NSString *)geocode  longitude:(NSString *)longitude latitude:(NSString *)latitude ipLoc:(NSString *)ipLoc accuracy:(NSString *) accuracy netModel:(NSString *)netModel
{
    // 首先检测表原来有没有这条记录，如果有，不重复插入
    //    if ([self isExistsFavoriteRecordWithAppModel:model])
    //    {
    //        NSLog(@"已经存在记录");
    //        return;
    //    }
    
    
    
    
    // 插入数据
    
    // @"CREATE TABLE IF NOT EXISTS ChapPathTable(ID INTEGER PRIMARY KEY AUTOINCREMENT,gametime TEXT,geocode TEXT,longitude TEXT,latitude TEXT,ipLoc TEXT,accuracy TEXT,netModel TEXT)"
    
    NSString *sql=@"insert into ChapPathTable(gametime,geocode,longitude,latitude,ipLoc,accuracy,netModel) values(?,?,?,?,?,?,?)";
    
    // model 传值问题
    BOOL c=[db executeUpdate:sql,gametime,geocode,longitude,latitude,ipLoc,accuracy,netModel];
    NSLog(@"cccc=%d",c);
}



// 获取所有数据
-(NSArray *)allFavoriteRecord
{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:10];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *sql=@"select * from ChapPathTable";
    FMResultSet *set=[db executeQuery:sql];
    
    
    while ([set next])
    {
        
        NSString *gametime=[set stringForColumn:@"gametime"];
        NSString *geocode=[set stringForColumn:@"geocode"];//geocode
        
        NSLog(@"---------------------------------geocode=%@",geocode);
        
        NSString *longitude=[set stringForColumn:@"longitude"];
        NSString *latitude=[set stringForColumn:@"latitude"];
        NSString *ipLoc=[set stringForColumn:@"ipLoc"];//ipLoc
        NSLog(@"----------------------------ipLoc=%@",ipLoc);
        
        NSString *accuracy=[set stringForColumn:@"accuracy"];
        NSString *netModel=[set stringForColumn:@"netModel"];
        
        
        [dic setObject:gametime forKey:@"gametime"];
        [dic setObject:geocode forKey:@"geocode"];
        [dic setObject:longitude forKey:@"longitude"];
        [dic setObject:latitude forKey:@"latitude"];
        [dic setObject:ipLoc forKey:@"ipLoc"];//获取数据这里为空必须崩溃
        [dic setObject:accuracy forKey:@"accuracy"];
        [dic setObject:netModel forKey:@"netModel"];
        [arr addObject:dic];
        
    }
   // NSLog(@"cout--------------------====%lu",(unsigned long)[arr count]);
    if ([arr count]==0) {
        return nil;
    }
    return arr;
    
}


#pragma mark -----表二


// 添加收藏记录
-(void)addFavoriteRecordtime:(NSString *)clickTime materielId:(NSString *)materielId  advertisers:(NSString *)advertisers provider:(NSString *)provider
{
    // 首先检测表原来有没有这条记录，如果有，不重复插入
    //    if ([self isExistsFavoriteRecordWithAppModel:model])
    //    {
    //        NSLog(@"已经存在记录");
    //        return;
    //    }
    
    
    
    
    // 插入数据
    
    // @"CREATE TABLE IF NOT EXISTS ChapPathTable(ID INTEGER PRIMARY KEY AUTOINCREMENT,gametime TEXT,geocode TEXT,longitude TEXT,latitude TEXT,ipLoc TEXT,accuracy TEXT,netModel TEXT)"
    
    NSString *sql=@"insert into ChapPathTableTime(clickTime,materielId,advertisers,provider) values(?,?,?,?)";
    
    // model 传值问题
    BOOL d=[db executeUpdate:sql,clickTime,materielId,advertisers,provider];
    NSLog(@"d=%d",d);
}




// 获取所有数据
-(NSArray *)allFavoriteRecordtime
{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:10];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *sql=@"select * from ChapPathTableTime";
    FMResultSet *set=[db executeQuery:sql];
    while ([set next])
    {
        
        NSString *gametime=[set stringForColumn:@"clickTime"];
        NSString *geocode=[set stringForColumn:@"materielId"];
        NSString *longitude=[set stringForColumn:@"advertisers"];
        NSString *latitude=[set stringForColumn:@"provider"];
        
        
        
        [dic setObject:gametime forKey:@"clickTime"];
        [dic setObject:geocode forKey:@"materielId"];
        [dic setObject:longitude forKey:@"advertisers"];
        [dic setObject:latitude forKey:@"provider"];
        [arr addObject:dic];
        
        
    }
    
    if ([arr count]==0) {
        [dic setObject:@"0" forKey:@"clickTime"];
        [dic setObject:@"0" forKey:@"materielId"];
        [dic setObject:@"0" forKey:@"advertisers"];
        [dic setObject:@"0" forKey:@"provider"];
        [arr addObject:dic];
        return arr;
    }
    return arr;
    
}


////数据的删除
//-(void)deleteDbase
//{
//    if ([db open]) {
//        
//        BOOL res=[db executeUpdate:@"DELETE FROM ShangBaoTable"];
//        if (res) {
//            NSLog(@"删除成功");
//        }else{
//            NSLog(@"删除失败");
//            
//        }
//        return;
//    }
//}



//删除数据
-(void)deleteFavoriteRecord
{
    if ([db open]) {
        NSString *sql=@"delete from ChapPathTable";
        BOOL d=[db executeUpdate:sql];
        NSLog(@"删除结果 %d",d);
    }else{
        NSLog(@"数据库没有打开!");
        return;
    }
    
   
}


//删除数据
-(void)deleteFavoriteRecordtime
{
    if ([db open]) {
        NSString *sql=@"delete from ChapPathTableTime";
        BOOL d=[db executeUpdate:sql];
        NSLog(@"删除结果 %d",d);
    }else
    {
        NSLog(@"数据库没有打开!");
        return;
        
    }
    
    
}


//删除数据
-(void)deleteFavoriteRecordtime :(NSString *)clickTime
{
    if ([db open]) {
        NSString *sql=@"delete from ChapPathTableTime where clickTime=?";
        BOOL d=[db executeUpdate:sql,clickTime];
        NSLog(@"删除结果 %d",d);
    }else
    {
        NSLog(@"数据库没有打开!");
        return;
        
    }
    
    
}





//关闭数据
-(void)closeSqlite
{
    [db close];
}




@end
