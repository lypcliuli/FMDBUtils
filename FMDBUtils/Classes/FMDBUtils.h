//
//  FMDBUtils.h
//  LLDemo
//
//  Created by LYPC on 2018/3/14.
//  Copyright © 2018年 LYPC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMDBUtils : NSObject

+ (instancetype)shareInstance;

/**
 设置缓存路径  （* 每次使用的时候 调用一下该配置方法）
 // 如果你传入的参数是空串：@"" ，则fmdb会在临时文件目录下创建这个数据库，数据库断开连接时，数据库文件被删除
 // 如果你传入的参数是 NULL，则它会建立一个在内存中的数据库，数据库断开连接时，数据库文件被删除
 @param dbPath 路径
 @param dataBaseName 数据库名字
 */
- (void)configDatabasePath:(NSString *)dbPath dataBaseName:(NSString *)dataBaseName;

/**
 创建表

 @param tableName 表名
 @return 成功/失败
 */
- (BOOL)creatTableIfNotExists:(NSString *)tableName;

/**
 存储数据

 @param tableName 表名字
 @param primaryKey key
 @param data 数据
 @return 成功/失败
 */
- (BOOL)saveDataTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(id)data;


/**
 删除指定的数据

 @param tableName 表名字
 @param primaryKey key
 @return 成功/失败
 */
- (BOOL)deleteDataTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey;

/**
 清除该表里所有数据

 @param tableName 表名字
 @return 成功/失败
 */
- (BOOL)clearAllDataInTable:(NSString *)tableName;

/**
 修改更新数据

 @param tableName 表名字
 @param primaryKey key
 @param data 新数据
 @return 成功/失败
 */
- (BOOL)updateDataTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey data:(id)data;

/**
 查询数据

 @param tableName 表名字
 @param primaryKey key
 @return 查询到的数据
 */
- (id)queryDataTableName:(NSString *)tableName primaryKey:(NSString *)primaryKey;


/**
 查询表里所有数据

 @param tableName 表名字
 @return 表里所有数据
 */
- (NSArray *)queryAllDataTableName:(NSString *)tableName;


/**
 删除表

 @param tableName 表名字
 @return 成功/失败
 */
- (BOOL)deleteTableName:(NSString *)tableName;

@end
