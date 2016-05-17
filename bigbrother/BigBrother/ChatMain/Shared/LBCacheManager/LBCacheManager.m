//
//  LBCacheManager.m
//  BigBrother
//
//  Created by 李祖建 on 16/5/17.
//  Copyright © 2016年 bigbrother. All rights reserved.
//

#import "LBCacheManager.h"

@interface LBCacheManager ()

NSString *getDataBaseFilePath(NSString *dbname);

BOOL openDatabase(NSString *dbname);

NSString *createTableSQL(NSString *tablename,NSDictionary *parmas_dic,NSString *primary_key);

NSString *createSelectSQL(NSString *tablename,NSArray *column_list,NSDictionary *condition_map);

NSString *createUpdateSQL(NSString *tablename, NSDictionary *value_map, NSDictionary *condition_map);

NSString *createInsertSQL(NSString *dbname,NSString *tablename,NSArray *keys_list,NSDictionary *value_map);

NSString *createDeleteSQL(NSString *tablename,NSDictionary *condition_map);

@end

@implementation LBCacheManager

+ (LBCacheManager *)sharedManager
{
    static LBCacheManager *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
        
        
    });
    return sharedAccountManagerInstance;
}


#pragma mark - 其它操作
// 删除数据库
- (void)deleteDatabseWithDbname:(NSString *)dbname
{
    BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = getDataBaseFilePath(dbname);
    // delete the old db.
    if ([fileManager fileExistsAtPath:filePath])
    {
        
        FMDatabase *database = [FMDatabase databaseWithPath:filePath];
        [database close];
        success = [fileManager removeItemAtPath:filePath error:&error];
        if (!success) {
            NSAssert1(0, @"Failed to delete old database file with message '%@'.", [error localizedDescription]);
        }
    }
}

/**
 *  删除表-彻底删除表
 *
 *  @param tableName 表名
 *
 *  @return 结果
 */
- (BOOL) deleteTableWithDbname:(NSString *)dbname tableName:(NSString *)tableName
{
    NSString *filePath = getDataBaseFilePath(dbname);
    NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableName];
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    if (![database open]) {
        return [self deleteTableWithDbname:dbname tableName:tableName];
    }
    if (![database executeUpdate:sqlstr])
    {
        [database close];
        return NO;
    }
    [database close];
    return YES;
}

/**
 *  判断表是否存在
 */
- (BOOL)isTableOKWithDbname:(NSString *)dbname tableName:(NSString *)tableName
{
    NSString *filePath = getDataBaseFilePath(dbname);
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    if (![database open]) {
        return [self isTableOKWithDbname:dbname tableName:tableName];
    }
    FMResultSet *rs = [database executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %ld", (long)count);
        
        if (0 == count)
        {
            [database close];
            return NO;
        }
        else
        {
            [database close];
            return YES;
        }
    }
    [database close];
    return NO;
    //    if(![database open])
    //    {
    //        return [self isTableOKWithDbname:dbname tableName:tableName];
    //    }
}



#pragma mark - fmdb
/**
 *  根据条件语句查询
 *
 *  @param dbname  数据库名
 *  @param sql     查询条件语句
 *
 *  @return 返回结果
 */
- (NSArray *)execQueryWithDbname:(NSString *)dbname sql:(NSString *)sql
{
    NSString *filePath = getDataBaseFilePath(dbname);
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    NSMutableArray *results = [NSMutableArray array];
    if (![database open]) {
        [database close];
        return results;
    }
    FMResultSet *resultSet = [database executeQuery:sql];
    while ([resultSet next]) {
        NSMutableDictionary *record = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        for (int i =0 ; i<[resultSet columnCount]; i++) {
            NSString *key = [resultSet columnNameForIndex:i];
            NSString *value = [resultSet stringForColumn:key];
            if (value) {
                [record setObject:value forKey:key];
            }
        }
        
        [results addObject:record];
        //        [record release];
    }
    [database close];
    return results;
}

/**
 *  查询返回需要的列
 *
 *  @param dbname        数据库名
 *  @param tablename     表名
 *  @param column_list   列名集合
 *  @param condition_map 条件
 *  @param results       结果
 */

- (NSArray *)executeQueryDbname:(NSString *)dbname tablename:(NSString *)tablename column_list:(NSArray *)column_list condition_map:(NSDictionary *)condition_map
{
    NSString *sql = createSelectSQL(tablename, column_list, condition_map);
    
    return [self execQueryWithDbname:dbname sql:sql];
}


/**
 *  根据条件语句（更新、创建）
 *
 *  @param dbname 数据库名
 *  @param sql    创建表sql
 *
 *  @return 创建结果（成功失败）
 */
- (BOOL)execUpdateWithDbname:(NSString *)dbname sql:(NSString *)sql
{
    NSString *filePath = getDataBaseFilePath(dbname);
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    
    if (![database open]) {
        [database close];
        return false;
    }
    
    if (![database executeUpdate:sql]) {
        [database close];
        return false;
    }
    [database close];
    return true;
}

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
- (BOOL)executeCreateWithDbname:(NSString *)dbname tablename:(NSString *)tablename params_dic:(NSDictionary *)params_dic primary_key:(NSString *)primary_key
{
    NSString *sql = createTableSQL(tablename, params_dic, primary_key);
    
    return [self execUpdateWithDbname:dbname sql:sql];
}

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
- (BOOL)executeUpdateWithDbname:(NSString *)dbname tablename:(NSString *)tablename value_map:(NSDictionary *)value_map condition_map:(NSDictionary *)condition_map
{
    NSString *sql = createUpdateSQL(tablename, value_map, condition_map);
    
    return [self execUpdateWithDbname:dbname sql:sql];
}


/**
 *  插入内容
 *
 *  @param dbname    数据库名
 *  @param tablename 表名
 *  @param value_map 插入内容dic
 *
 *  @return 成功/失败
 */
- (BOOL)executeInsertWithDbname:(NSString *)dbname tablename:(NSString *)tablename value_map:(NSDictionary *)value_map
{
    NSArray *keys = [self execQueryWithDbname:dbname sql:[NSString stringWithFormat:@"PRAGMA table_info ('%@')",tablename]];
    NSMutableArray *keys_list = [NSMutableArray array];
    for (NSDictionary *keyDic in keys) {
        if (keyDic[@"name"]) {
            [keys_list addObject:keyDic[@"name"]];
        }
    }
    NSString *sql = createInsertSQL(dbname, tablename, keys_list, value_map);
    
    return [self execUpdateWithDbname:dbname sql:sql];
}


/**
 *  删除
 *
 *  @param dbname        数据库名
 *  @param tablename     表名
 *  @param condition_map 删除条件
 *
 *  @return 成功/失败
 */
- (BOOL)executeDeleteWithDbname:(NSString *)dbname tablename:(NSString *)tablename condition_map:(NSDictionary *)condition_map
{
    NSString *sql = createDeleteSQL(tablename, condition_map);
    return [self execUpdateWithDbname:dbname sql:sql];
}



#pragma mark - private methods
BOOL executeAddFileName(NSString *dbname,NSString *tablename,NSString *filename,NSString* filetype)
{
    NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD %@ %@",tablename,filename,filetype];
    NSString *filePath = getDataBaseFilePath(dbname);
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    
    if (![database open]) {
        [database close];
        return false;
    }
    
    if (![database executeUpdate:sql]) {
        [database close];
        return false;
    }
    [database close];
    return true;
}

NSString *getDataBaseFilePath(NSString *dbname)
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:dbname];
}

NSString *createTableSQL(NSString *tablename,NSDictionary *parmas_dic,NSString *primary_key)
{
    NSString *sqlString = @"create table if not exists";
    //    personInfo(uid integer primary key autoincrement, name text,gender text,age integer,country text)";
    if (!tablename) {
        return nil;
    }
    sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@" %@(",tablename]];
    sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"%@ %@,",primary_key,parmas_dic[primary_key]]];
    
    
    for (int i = 0; i<[[parmas_dic allKeys] count]; i++) {
        NSString *key = [parmas_dic allKeys][i];
        if (![key isEqualToString:primary_key]) {
            sqlString = [sqlString stringByAppendingString:[NSString stringWithFormat:@"%@ %@",key,parmas_dic[key]]];
            if (i != [parmas_dic allKeys].count-1) {
                sqlString = [sqlString stringByAppendingString:@","];
            }
        }
    }
    
    sqlString = [sqlString stringByAppendingString:@")"];
    return sqlString;
}

NSString *createSelectSQL(NSString *tablename,NSArray *column_list,NSDictionary *condition_map)
{
    if (tablename == nil) {
        return nil;
    }
    NSString *sqlString = @"select";
    
    NSString *fields = @"";
    
    if (column_list == nil || [column_list count]<1) {
        fields = @" * ";
    } else {
        for (int i = 0; i<[column_list count]; i++) {
            NSString *seperator = [fields length]<1?@" ":@",";
            fields = [[fields stringByAppendingString:seperator] stringByAppendingString:[column_list objectAtIndex:i]];
        }
        
        fields = [fields stringByAppendingString:@" "];
    }
    
    sqlString = [sqlString stringByAppendingString:fields];
    sqlString = [sqlString stringByAppendingString:@"from "];
    sqlString = [sqlString stringByAppendingString:tablename];
    
    if (condition_map == nil || [condition_map count]<1) {
        return sqlString;
    }
    sqlString = [sqlString stringByAppendingString:@" where "];
    
    NSString *conditions = @"";
    
    
    for (int j =0; j < [[condition_map allKeys] count]; j++) {
        
        NSString *key = [[condition_map allKeys] objectAtIndex:j];
        NSString *value = [NSString stringWithFormat:@"%@",[condition_map objectForKey:key]];
        
        NSString *seperator = [conditions length]<1?@"":@" and ";
        
        conditions = [[[[conditions stringByAppendingString:seperator] stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:conditions];
    
    return sqlString;
}

NSString *createUpdateSQL(NSString *tablename, NSDictionary *value_map, NSDictionary *condition_map)
{
    NSArray *keys = [[LBCacheManager sharedManager] execQueryWithDbname:DBNAME sql:[NSString stringWithFormat:@"PRAGMA table_info ('%@')",tablename]];
    NSMutableArray *mKeys_list = [NSMutableArray array];
    for (NSDictionary *keyDic in keys) {
        if (keyDic[@"name"]) {
            [mKeys_list addObject:keyDic[@"name"]];
        }
    }
    
    if (tablename == nil || value_map == nil) {
        return nil;
    }
    NSString *sqlString = @"update ";
    
    sqlString = [sqlString stringByAppendingString:tablename];
    
    sqlString = [sqlString stringByAppendingString:@" set"];
    
    NSString *updateFields = @"";
    
    for (int i = 0; i<[[value_map allKeys] count]; i++) {
        
        NSString *seperator = [updateFields length]<1?@" ":@",";
        NSString *key = [[value_map allKeys] objectAtIndex:i];
        NSInteger index = [mKeys_list indexOfObject:key];
        if (index == NSNotFound) {
            BOOL addResult = executeAddFileName(DBNAME, tablename, key, @"text");
            if (!addResult) {
                continue;
            }else{
                [mKeys_list addObject:key];
            }
        }
        
        NSString *value = [NSString stringWithFormat:@"%@",[value_map objectForKey:key]];
        
        if ([[value_map objectForKey:key] isKindOfClass:[NSArray class]] ||
            [[value_map objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            value = @"";
        }
        
        value = [NSString stringWithFormat:@"\"%@\"",value];
        
        
        
        updateFields = [[[[updateFields stringByAppendingString:seperator] stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:updateFields];
    
    if (condition_map == nil || [condition_map count]<1) {
        return sqlString;
    }
    sqlString = [sqlString stringByAppendingString:@" where "];
    
    NSString *conditions = @"";
    
    for (int j =0; j < [[condition_map allKeys] count]; j++) {
        
        NSString *key = [[condition_map allKeys] objectAtIndex:j];
        NSString *value = [NSString stringWithFormat:@"%@",[condition_map objectForKey:key]];
        
        NSString *seperator = [conditions length]<1?@"":@" and ";
        
        conditions = [[[[conditions stringByAppendingString:seperator] stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:conditions];
    
    return sqlString;
}

NSString *createInsertSQL(NSString *dbname,NSString *tablename,NSArray *keys_list,NSDictionary *value_map)
{
    NSMutableArray *mKeys_list = [NSMutableArray arrayWithArray:keys_list];
    if (tablename == nil || value_map == nil) {
        return nil;
    }
    NSString *sqlString = @"insert into ";
    sqlString = [sqlString stringByAppendingString:tablename];
    sqlString = [sqlString stringByAppendingString:@" ("];
    
    NSString *keyString = @"";
    
    for (int i = 0 ; i<[[value_map allKeys] count]; i++) {
        NSString *key = [[value_map allKeys] objectAtIndex:i];
        NSInteger index = [mKeys_list indexOfObject:key];
        if (index == NSNotFound) {
            BOOL addResult = executeAddFileName(dbname, tablename, key, @"text");
            if (!addResult) {
                continue;
            }else{
                [mKeys_list addObject:key];
            }
        }
        
        NSString *seperator = [keyString length]<1?@"":@",";
        keyString = [[keyString stringByAppendingString:seperator] stringByAppendingString:key];
    }
    sqlString = [sqlString stringByAppendingString:keyString];
    sqlString = [sqlString stringByAppendingString:@") values ("];
    
    NSString *valueString = @"";
    for (int j = 0 ; j<[[value_map allKeys] count]; j++) {
        NSString *key = [[value_map allKeys] objectAtIndex:j];
        NSInteger index = [mKeys_list indexOfObject:key];
        if (index == NSNotFound) {
            continue;
        }
        
        NSString *seperator = [valueString length]<1?@"\"":@",\"";
        NSString *value = [NSString stringWithFormat:@"%@",[value_map objectForKey:key]];
        if ([[value_map objectForKey:key] isKindOfClass:[NSArray class]] ||
            [[value_map objectForKey:key] isKindOfClass:[NSDictionary class]]) {
            value = @"";
        }
        
        valueString = [[valueString stringByAppendingString:seperator] stringByAppendingString:value];
        valueString = [valueString stringByAppendingString:@"\""];
    }
    
    
    
    sqlString = [sqlString stringByAppendingString:valueString];
    sqlString = [sqlString stringByAppendingString:@")"];
    
    return sqlString;
}

NSString *createDeleteSQL(NSString *tablename,NSDictionary *condition_map)
{
    if (tablename == nil) {
        return nil;
    }
    NSString *sqlString = @"delete from ";
    sqlString = [sqlString stringByAppendingString:tablename];
    
    if (condition_map == nil || [condition_map count]<1) {
        return sqlString;
    }
    sqlString = [sqlString stringByAppendingString:@" where "];
    
    NSString *conditions = @"";
    
    for (int j =0; j < [[condition_map allKeys] count]; j++) {
        
        NSString *key = [[condition_map allKeys] objectAtIndex:j];
        NSString *value = [NSString stringWithFormat:@"%@",[condition_map objectForKey:key]];
        
        NSString *seperator = [conditions length]<1?@"":@" and ";
        
        conditions = [[[[conditions stringByAppendingString:seperator] stringByAppendingString:key] stringByAppendingString:@"="] stringByAppendingString:value];
    }
    
    sqlString = [sqlString stringByAppendingString:conditions];
    
    return sqlString;
    
}

@end
