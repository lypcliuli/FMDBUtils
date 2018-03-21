//
//  FMDBUtils.m
//  LLDemo
//
//  Created by LYPC on 2018/3/14.
//  Copyright © 2018年 LYPC. All rights reserved.
//

#import "FMDBUtils.h"
#import "FMDB.h"

#define CREAT_TABLE_IFNOT_EXISTS             @"create table if not exists %@ (key text primary key, data blob)"
#define DELETE_DATA_WITH_PRIMARYKEY          @"delete from %@ where key = ?"
#define INSERT_TO_TABLE                      @"insert into %@ (key, data) values (?, ?)"
#define READ_DATA_TABLE_WITH_PRIMARYKEY      @"select data from %@ where key = ?"
#define READ_ALL_DATA                        @"select data from %@"
#define UPDATE_DATA_WHTH_PRIMARYKEY          @"update %@ set data = ? where key = ?"
#define CLEAR_ALL_DATA                       @"DELETE FROM %@"
#define DELETE_TABLE                       @"drop table if exists %@"


@interface FMDBUtils()

@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic,copy) NSString *dataBaseName;
@property (nonatomic,strong) FMDatabase *db;

@end

@implementation FMDBUtils

static FMDBUtils* _instance = nil;

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)configDatabasePath:(NSString *)dbPath dataBaseName:(NSString *)dataBaseName {
    self.dbPath = dbPath;
    self.dataBaseName = dataBaseName;
    if (self.dbPath || ![self.dbPath isEqualToString:@""]) {
        NSString *fileName = [self.dbPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", dataBaseName]];
        // 获取数据库
        self.db = [FMDatabase databaseWithPath:fileName];
    }
}

/**
 创建表

 @param tableName 表名
 @return 成功/失败
 */
- (BOOL)creatTableIfNotExists:(NSString *)tableName {
    NSString *fileName = @"";
    NSString *dataBaseName = @"appData"; // 不配置configDatabasePath 默认叫做appData
    if (self.dataBaseName || ![self.dataBaseName isEqualToString:@""]) {
        dataBaseName = self.dataBaseName;
    }
    if (self.dbPath || ![self.dbPath isEqualToString:@""]) {
        fileName = [self.dbPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", dataBaseName]];
    }
    // 获取数据库
    self.db = [FMDatabase databaseWithPath:fileName];
    // 打开数据库
    if ([self.db open]) {
        // 创建表
        BOOL result = [self.db executeUpdate:[NSString stringWithFormat:CREAT_TABLE_IFNOT_EXISTS, tableName]];
        if (result) {
            // 创建表成功
            return YES;
        } else {
            // 创建表失败
        }
    } else {
        // 打开数据库失败
    }
    [self.db close];
    return NO;
}

- (BOOL)saveDataTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(id)data {
    if ([self creatTableIfNotExists:tableName]) {
        NSString *deleteSql = [NSString stringWithFormat:DELETE_DATA_WITH_PRIMARYKEY,tableName];
        BOOL ret = [self.db executeUpdate:deleteSql,primaryKey];
        if (ret) {
            NSString *storeURL = [NSString stringWithFormat:INSERT_TO_TABLE,tableName];
            ret = [self.db executeUpdate:storeURL,primaryKey,[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil]];
        }
        [self.db close];
        return ret;
    }
    return NO;
}

- (BOOL)deleteDataTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey {
    if ([self creatTableIfNotExists:tableName]) {
        NSString *deleteSql = [NSString stringWithFormat:DELETE_DATA_WITH_PRIMARYKEY,tableName];
        BOOL ret = [self.db executeUpdate:deleteSql,primaryKey];
        [self.db close];
        return ret;
    }else {
        return NO;
    }
}

- (BOOL)updateDataTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(id)data {
    if ([self creatTableIfNotExists:tableName]) {
        NSString *updateSql = [NSString stringWithFormat:UPDATE_DATA_WHTH_PRIMARYKEY,tableName];
        BOOL ret = [self.db executeUpdate:updateSql,[NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil],primaryKey];
        [self.db close];
        return ret;
    }else {
        return NO;
    }
}

- (id)queryDataTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey {
    if ([self creatTableIfNotExists:tableName]) {
        NSString *readSql = [NSString stringWithFormat:READ_DATA_TABLE_WITH_PRIMARYKEY,tableName];
        FMResultSet *resultSet = [self.db executeQuery:readSql,primaryKey];
        NSData *data;
        while ([resultSet next]) {
            data = [resultSet dataForColumn:@"data"];
        }
        [self.db close];
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }else {
        return nil;
    }
}

- (NSArray *)queryAllDataTableName:(NSString *)tableName {
    if ([self creatTableIfNotExists:tableName]) {
        NSMutableArray *dataArr = [NSMutableArray array];
        NSString *readSql = [NSString stringWithFormat:READ_ALL_DATA,tableName];
        FMResultSet *result = [self.db executeQuery:readSql];
        while ([result next]) {
            NSData *data = [result dataForColumn:@"data"];
            [dataArr addObject:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil]];
        }
        [self.db close];
        return dataArr;
    }else {
        return @[];
    }
}

- (BOOL)clearAllDataInTable:(NSString *)tableName {
    if ([self creatTableIfNotExists:tableName]) {
        NSString *clearSql = [NSString stringWithFormat:CLEAR_ALL_DATA,tableName];
        BOOL ret = [self.db executeUpdate:clearSql];
        [self.db close];
        return ret;
    }else {
        return NO;
    }
}

- (BOOL)deleteTableName:(NSString *)tableName {
    if ([self creatTableIfNotExists:tableName]) {
//        BOOL ret = [self.db executeUpdate:DELETE_TABLE, tableName];
        BOOL ret = [self.db executeUpdate:@"drop table if exists homeData"];
        [self.db close];
        return ret;
    }else {
        return NO;
    }
}

@end
