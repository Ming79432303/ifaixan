//
//  LGSqliteManager.m
//  FMDB工具类的封装
//
//  Created by ming on 17/2/15.
//  Copyright © 2017年 ming. All rights reserved.
//

#import "LGSqliteManager.h"
#import "FMDB.h"
@interface LGSqliteManager()

@end
@implementation LGSqliteManager{
    
    NSString *dbName;
    FMDatabaseQueue *queue;
}

+ (instancetype)shareSqlite{
    
    return [[self alloc] init];
    
}

- (instancetype)init{
    
    if (self == [super init]) {
        
        NSString *file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        NSString *dbPath =  [file stringByAppendingPathComponent:@"ifaxian.db"];
        queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        //创建一个表
        [self createTable];
    }
      return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static LGSqliteManager *sqlite;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sqlite = [super allocWithZone:zone];
    });
    
    
    return sqlite;
}


- (NSArray *)loadDataDbNmae:(NSString *)name limit:(NSInteger)limit curentCount:(NSInteger)count{
    
    //从数据库获取数据
    dbName = name;
    
    NSString *sql = [NSString stringWithFormat:@"select * from %@ order by id asc limit %zd,%zd;",name,count,limit];
    NSMutableArray *resultM = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
      FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:nil];
        
        while ([resultSet next]) {
            //列数
            int colCount = resultSet.columnCount;
            for (int i = 0; i < colCount; i ++) {
                //列名
              NSString *name = [resultSet columnNameForIndex:i];
                //值
               id value = [resultSet objectForColumnIndex:i];
                if (value == nil) {
                    continue;
                }
                //加入到数组中
                [resultM addObject: @{name:value}];
            }
        }
        
    }];
    
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dict in resultM) {
        if (dict[@"content"]) {
            [dataArray addObject:dict[@"content"]];
        }
        
    }
 
    return dataArray;
}

//创建一个表
- (void)createTable{
   
    NSString *sql = @"create table if not exists t_home(id INTEGER PRIMARY KEY AUTOINCREMENT,content text,postId integer UNIQUE);create table if not exists t_share(id INTEGER PRIMARY KEY AUTOINCREMENT,content text,postId integer UNIQUE);";
    [queue inDatabase:^(FMDatabase *db) {
    BOOL result = [db executeStatements:sql];
       if (result == YES) {
           NSLog(@"创建表成功");
                 }else{
           
           NSLog(@"创建表失败");
       }
   }];


}
//更新数据库，同名则更新，没有则添加
- (void)updateDataTableName:(NSString *)tbName dataArray:(NSArray *)dataArray{

    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (NSDictionary *dict in dataArray) {
          NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil];
           NSString *contenStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *sql = [NSString stringWithFormat:@"replace into  %@ (content,postId) values (?,?)",tbName];
            if ([db executeUpdate:sql withArgumentsInArray:@[contenStr,dict[@"id"]]] == YES) {
            
            }else{
                LGLog(@"插入数据失败");
                *rollback = YES;
            }

        }
        
        
    }];
}

@end
