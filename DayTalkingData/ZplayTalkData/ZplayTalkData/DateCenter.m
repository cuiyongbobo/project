//
//  DateCenter.m
//  爱限免（复习）
//
//  Created by Zzd on 14-6-16.
//  Copyright (c) 2014年 qianfeng. All rights reserved.
//

#import "DateCenter.h"

#import "FMDatabase.h"

@implementation DateCenter
{
    FMDatabase *_datebase;
}
+(instancetype)shareInstant
{
    static id dc=nil;
    if (dc==nil)
    {
        
        dc=[[[self class]alloc]init];
       
    }
    return dc;
}

-(id)init
{
    if (self=[super init])
    {
        NSLog(@"----------------------------进入");
        // 初始化数据库
        [self initDatebase];
        
        
        [self createtable];
    }
    return self;
}

-(void)initDatebase
{
    NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/record.sqlite"];
    
    _datebase=[[FMDatabase alloc]initWithPath:path];
    
    if (_datebase.open!=YES)
    {
        NSLog(@"创建失败");
        return;
    }
    
    
    /*
     存到数据库：
     ---------------openList
     geocode
     longitude
     openTime
     latitude
     ipLoc
     accuracy
     netModel
     
     -----------------clicklist
     clickTime
     materielId
     advertisers
     provider
     
     */
    
    
    NSString *sql=@"CREATE TABLE IF NOT EXISTS ChapPathTable(ID INTEGER PRIMARY KEY AUTOINCREMENT,gametime TEXT,geocode TEXT,longitude TEXT,latitude TEXT,ipLoc TEXT,accuracy TEXT,netModel TEXT)";
    
    BOOL b=[_datebase executeUpdate:sql];
    
    NSLog(@"b=%d",b);
}


-(void)createtable
{
    // NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/record.sqlite"];
    
    //  _datebase=[[FMDatabase alloc]initWithPath:path];
    
    if (_datebase.open!=YES)
    {
        NSLog(@"创建失败");
        return;
    }
    
    /*
     存到数据库：
     ---------------openList
     geocode
     longitude
     openTime
     latitude
     ipLoc
     accuracy
     netModel
     
     -----------------clicklist
     clickTime
     materielId
     advertisers
     provider
     
     */
    
    
    NSString *sql=@"CREATE TABLE IF NOT EXISTS ChapPathTableTime(ID INTEGER PRIMARY KEY AUTOINCREMENT,clickTime TEXT,materielId TEXT,advertisers TEXT,provider TEXT)";
    
    BOOL b=[_datebase executeUpdate:sql];
    
    NSLog(@"h=%d",b);
}




-(void)createtablegame
{
    // NSString *path=[NSHomeDirectory() stringByAppendingString:@"/Documents/record.sqlite"];
    
    //  _datebase=[[FMDatabase alloc]initWithPath:path];
    
    if (_datebase.open!=YES)
    {
        NSLog(@"创建失败");
        return;
    }
    
    
    NSString *sql=@"CREATE TABLE IF NOT EXISTS ChapPathTableGame(ID INTEGER PRIMARY KEY AUTOINCREMENT,gameId TEXT,channelId TEXT)";
    
    BOOL b=[_datebase executeUpdate:sql];
    
    NSLog(@"b=%d",b);
}


#pragma mark -----表三

// 添加收藏记录
-(void)addFavoriteRecordgame:(NSString *)gameId channelId:(NSString *)channelId
{
    // 首先检测表原来有没有这条记录，如果有，不重复插入
    //    if ([self isExistsFavoriteRecordWithAppModel:model])
    //    {
    //        NSLog(@"已经存在记录");
    //        return;
    //    }
    
    
    
    
    // 插入数据
    
    // @"CREATE TABLE IF NOT EXISTS ChapPathTable(ID INTEGER PRIMARY KEY AUTOINCREMENT,gametime TEXT,geocode TEXT,longitude TEXT,latitude TEXT,ipLoc TEXT,accuracy TEXT,netModel TEXT)"
    
    NSString *sql=@"insert into ChapPathTableGame(gameId,channelId) values(?,?)";
    
    // model 传值问题
    BOOL c=[_datebase executeUpdate:sql,gameId,channelId];
    NSLog(@"c=%d",c);
    
}


// 获取所有数据
-(NSArray *)allFavoriteRecordgame
{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:10];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *sql=@"select * from ChapPathTableGame";
    FMResultSet *set=[_datebase executeQuery:sql];
    while ([set next])
    {
        
        NSString *gameId=[set stringForColumn:@"gameId"];
        NSString *channelId=[set stringForColumn:@"channelId"];
        
        
        
        
        [dic setObject:gameId forKey:@"gameId"];
        [dic setObject:channelId forKey:@"channelId"];
        [arr addObject:dic];
        
    }
    
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
    BOOL c=[_datebase executeUpdate:sql,clickTime,materielId,advertisers,provider];
    NSLog(@"c=%d",c);
}




// 获取所有数据
-(NSArray *)allFavoriteRecordtime
{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:10];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *sql=@"select * from ChapPathTableTime";
    FMResultSet *set=[_datebase executeQuery:sql];
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
        return nil;
    }
    return arr;
    
}










#pragma mark -----表一
// 添加收藏记录

//addFavoriteRecord:timeString geocode:@"北京" longitude:[NSString stringWithFormat:@"%f",32.2] latitude:[NSString stringWithFormat:@"%f",113.2] ipLoc:ipLocs accuracy:[NSString stringWithFormat:@"%f",20.3] netModel:[self getNetWorkStates]];

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
    BOOL c=[_datebase executeUpdate:sql,gametime,geocode,longitude,latitude,ipLoc,accuracy,netModel];
    NSLog(@"c=%d",c);
}



// 获取所有数据
-(NSArray *)allFavoriteRecord
{
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithCapacity:10];
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *sql=@"select * from ChapPathTable";
    FMResultSet *set=[_datebase executeQuery:sql];
    
    
    while ([set next])
    {
        
        NSString *gametime=[set stringForColumn:@"gametime"];
        NSString *geocode=[set stringForColumn:@"geocode"];//geocode
        
         NSLog(@"---------------------------------geocode=%@",geocode);
        
        NSString *longitude=[set stringForColumn:@"longitude"];
        NSString *latitude=[set stringForColumn:@"latitude"];
        NSString *ipLoc=[set stringForColumn:@"ipLoc"];
        NSString *accuracy=[set stringForColumn:@"accuracy"];
        NSString *netModel=[set stringForColumn:@"netModel"];
        
        
        [dic setObject:gametime forKey:@"gametime"];
        [dic setObject:geocode forKey:@"geocode"];
        [dic setObject:longitude forKey:@"longitude"];
        [dic setObject:latitude forKey:@"latitude"];
        [dic setObject:ipLoc forKey:@"ipLoc"];
        [dic setObject:accuracy forKey:@"accuracy"];
        [dic setObject:netModel forKey:@"netModel"];
        [arr addObject:dic];
        
    }
    NSLog(@"cout--------------------====%lu",(unsigned long)[arr count]);
    if ([arr count]==0) {
        return nil;
    }
    return arr;
    
}






//删除数据
-(void)deleteFavoriteRecord
{
    NSString *sql=@"delete from ChapPathTable";
    BOOL d=[_datebase executeUpdate:sql];
    NSLog(@"删除结果 %d",d);
}


//删除数据
-(void)deleteFavoriteRecordtime
{
    NSString *sql=@"delete from ChapPathTableTime";
    BOOL d=[_datebase executeUpdate:sql];
    NSLog(@"删除结果 %d",d);
}


//删除数据
-(void)deleteFavoriteRecordgame
{
    NSString *sql=@"delete from ChapPathTableGame";
    BOOL d=[_datebase executeUpdate:sql];
    NSLog(@"删除结果 %d",d);
}









@end
