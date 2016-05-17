//
//  LBCacheManager.h
//  BigBrother
//
//  Created by 李祖建 on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBCacheManager : NSObject

+ (LBCacheManager *)sharedManager;

// 删除数据库
- (void)deleteDatabseWithDbname:(NSString *)dbname;
/**
 *  判断表是否存在
 */
- (BOOL)isTableOKWithDbname:(NSString *)dbname tableName:(NSString *)tableName;
/**
 *  删除表-彻底删除表
 */
- (BOOL) deleteTableWithDbname:(NSString *)dbname tableName:(NSString *)tableName;

/**
 *  根据条件语句查询
 */
- (NSArray *)execQueryWithDbname:(NSString *)dbname sql:(NSString *)sql;
//NSArray *execQuery(NSString *dbname, NSString *sql);
//void execQuery(NSString *dbname, NSString *sql ,NSMutableArray **results);
/**
 *  查询返回需要的列
 */
- (NSArray *)executeQueryDbname:(NSString *)dbname tablename:(NSString *)tablename column_list:(NSArray *)column_list condition_map:(NSDictionary *)condition_map;
//NSArray *executeQuery(NSString *dbname, NSString *tablename,NSArray *column_list,NSDictionary *condition_map);
//void executeQuery(NSString *dbname, NSString *tablename,NSArray *column_list,NSDictionary *condition_map, NSMutableArray **results);


- (BOOL)execUpdateWithDbname:(NSString *)dbname sql:(NSString *)sql;
//BOOL execUpdate(NSString *dbname, NSString *sql);

/**
 *  创建表
 *
 *  @param dbname      数据库名
 *  @param tablename   表名
 *  @param parmas_dic  键——类型 字典
 *  @param primary_key 主键
 *
 *  @return 结果
 */
- (BOOL)executeCreateWithDbname:(NSString *)dbname tablename:(NSString *)tablename params_dic:(NSDictionary *)params_dic primary_key:(NSString *)primary_key;

/**
 *  更新表
 *
 *  @param dbname        数据库名
 *  @param tablename     表名
 *  @param value_map     更新内容
 *  @param condition_map 更新条件
 *
 *  @return 成功/失败
 */
- (BOOL)executeUpdateWithDbname:(NSString *)dbname tablename:(NSString *)tablename value_map:(NSDictionary *)value_map condition_map:(NSDictionary *)condition_map;


/**
 *  插入内容
 *
 *  @param dbname    数据库名
 *  @param tablename 表名
 *  @param value_map 插入内容dic
 *
 *  @return 成功/失败
 */
- (BOOL)executeInsertWithDbname:(NSString *)dbname tablename:(NSString *)tablename value_map:(NSDictionary *)value_map;

/**
 *  删除
 *
 *  @param dbname        数据库名
 *  @param tablename     表名
 *  @param condition_map 删除条件
 *
 *  @return 成功/失败
 */
- (BOOL)executeDeleteWithDbname:(NSString *)dbname tablename:(NSString *)tablename condition_map:(NSDictionary *)condition_map;

@end
