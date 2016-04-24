//
//  DBManager.m
//  SqliteDemo
//
//  Created by Feliu on 16/4/21.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

#define DB_NAME @"userinfo.sqlite"
#define TABLE_NAME @"user"

#define BEGIN_TRANS "begin transaction"      //开始事务
#define COMMIT_TRANS "commit transaction"    //编辑事务
#define ROLLBACK_TRANS "rollback transaction"//回滚事务

@implementation DBManager

static DBManager *sharedInstance;
static sqlite3 *db;

#pragma mark - life cycle
+ (instancetype)sharedDBManager{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance creatDB];
        [sharedInstance creatTable];
    });
    return sharedInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return sharedInstance;
}

+ (instancetype)new{
    return [self sharedDBManager];
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

#pragma mark - public methods
- (BOOL)insertPeople:(People *)people{
    BOOL isSuccess = NO;
    
    if (![self openDB]) {
        NSLog(@"插入数据失败,error：未能打开DB");
        [self closeDB];
        return NO;
    }
    
    if (![self isExistTable:TABLE_NAME]) {
        NSLog(@"插入数据失败,error:表不存在");
        sqlite3_close(db);
        return NO;
    }

    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (name, telphoneNum, city) VALUES(?, ?, ?)",TABLE_NAME];
    sqlite3_stmt *stmt = nil;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [people.name UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [people.telphoneNum UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [people.city UTF8String], -1, NULL);
        sqlite3_exec(db, BEGIN_TRANS, NULL, NULL, NULL);
        if (sqlite3_step(stmt) == SQLITE_DONE) {
            NSLog(@"插入数据成功");
            sqlite3_exec(db, COMMIT_TRANS, NULL, NULL, NULL);
            isSuccess = YES;
        }else{
            sqlite3_exec(db, ROLLBACK_TRANS, NULL, NULL, NULL);
        }
    }else{
        NSLog(@"插入数据失败,sqlite3_prepare_v2.error.");
    }
    int finalizeStatus = sqlite3_finalize(stmt);
    if (finalizeStatus == SQLITE_OK) {
        [self closeDB];
    }else{
        NSLog(@"sqlite3_finalize error.%i",finalizeStatus);
    }
    
    return isSuccess;
}

- (BOOL)deleteData:(NSString *)name{
    
    if ([self openDB]) {
        NSLog(@"删除数据失败,error：未能打开DB");
        [self closeDB];
        return NO;
    }
    
    if (![self isExistTable:TABLE_NAME]) {
        NSLog(@"删除数据失败,error:表不存在");
        [self closeDB];
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE name = '%@'",TABLE_NAME,name];
    char *error;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"删除数据成功");
        [self closeDB];
        return YES;
    }
    NSLog(@"删除数据失败，error:%s",error);
    return NO;
}

- (BOOL)updatePeopleWithName:(NSString *)name telPhone:(NSString *)newTelPhone city:(NSString *)newCity{
    if (sqlite3_open([[self getDBPath:DB_NAME] UTF8String], &db)) {
        NSLog(@"更新数据失败,error：未能打开DB");
        sqlite3_close(db);
        return NO;
    }
    if (![self isExistTable:TABLE_NAME]) {
        NSLog(@"更新数据失败,error:表不存在");
        sqlite3_close(db);
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET telPhone = '%@', city = '%@' WHERE name = '%@'",TABLE_NAME,newTelPhone,newCity,name];
    char *error;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"更新数据成功");
        sqlite3_close(db);
        return YES;
    }
    NSLog(@"更新数据失败，error:%s",error);
    return NO;
}

//- (BOOL)updateData:(NSString *)password userName:(NSString *)userName{
//    if (sqlite3_open([[self getDBPath:DB_NAME] UTF8String], &db)) {
//        NSLog(@"更新数据失败,error：未能打开DB");
//        sqlite3_close(db);
//        return NO;
//    }
//    if (![self isExistTable:TABLE_NAME]) {
//        NSLog(@"更新数据失败,error:表不存在");
//        sqlite3_close(db);
//        return NO;
//    }
//    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET password = '%@' WHERE name = '%@'",TABLE_NAME,password,userName];
//    char *error;
//    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
//        NSLog(@"更新数据成功");
//        sqlite3_close(db);
//        return YES;
//    }
//    NSLog(@"更新数据失败，error:%s",error);
//    return NO;
//}

- (NSArray *)queryPeopleWithName:(NSString *)name{
    NSMutableArray *queryResultArray = [[NSMutableArray alloc] init];
    if ([self openDB]) {
        NSLog(@"删除数据失败,error：未能打开DB");
        [self closeDB];
        return queryResultArray;
    }
    
    if (![self isExistTable:TABLE_NAME]) {
        NSLog(@"删除数据失败,error:表不存在");
        [self closeDB];
        return queryResultArray;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ where name = ?",DB_NAME];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, nil) == SQLITE_OK) {
        sqlite3_bind_text(stmt, 1, [name UTF8String], -1, nil);
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            People *people = [[People alloc] init];
            people.name = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            people.telphoneNum = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            people.city = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
            [queryResultArray addObject:people];
        }
    }else{
        NSLog(@"查询失败");
    }
    sqlite3_finalize(stmt);
    [self closeDB];
    return queryResultArray;
}

//- (BOOL)queryData:(NSString *)userName password:(NSString *)password{
//    if (sqlite3_open([[self getDBPath:DB_NAME] UTF8String], &db)) {
//        NSLog(@"查询数据失败,error：未能打开DB");
//        sqlite3_close(db);
//        return NO;
//    }
//    if (![self isExistTable:TABLE_NAME]) {
//        NSLog(@"查询数据失败,error:表不存在");
//        sqlite3_close(db);
//        return NO;
//    }
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE username = '%@' AND password = '%@'",TABLE_NAME,userName,password];
//    sqlite3_stmt *stmt;
//    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
//        int temp = sqlite3_step(stmt);
//        if (temp == SQLITE_ROW) {
//            NSLog(@"查询数据成功");
//            return YES;
//        }else{
//            NSLog(@"查询失败,error:%i",temp);
//        }
//    }
//    return NO;
//}

- (NSArray *)queryAllPeople{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if (![self openDB]) {
        NSLog(@"获取全部数据失败,error：未能打开DB");
        [self closeDB];
        return resultArray;
    }
    BOOL isTable = [self isExistTable:TABLE_NAME];
    if (!isTable) {
        NSLog(@"获取全部数据失败,error:表不存在");
        [self closeDB];
        return resultArray;
    }
    NSString *sql = [NSString stringWithFormat:@"select * from %@",TABLE_NAME];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String ], -1, &stmt, NULL) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            People *people = [[People alloc] init];
            people.name = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 1) encoding:NSUTF8StringEncoding];
            people.telphoneNum = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
            people.city = [NSString stringWithCString:(char *)sqlite3_column_text(stmt, 3) encoding:NSUTF8StringEncoding];
            [resultArray addObject:people];
        }
        NSLog(@"获取全部数据完毕");
    }else{
        NSLog(@"获取全部数据失败");
    }
    return resultArray;
}
//- (BOOL)queryAllData{
//    if (sqlite3_open([[self getDBPath:DB_NAME] UTF8String], &db)) {
//        NSLog(@"查询数据失败,error：未能打开DB");
//        sqlite3_close(db);
//        return NO;
//    }
//    if (![self isExistTable:TABLE_NAME]) {
//        NSLog(@"查询数据失败,error:表不存在");
//        sqlite3_close(db);
//        return NO;
//    }
//    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@]",TABLE_NAME];
//    sqlite3_stmt *stmt;
//    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
//        int temp = sqlite3_step(stmt);
//        if (temp == SQLITE_ROW) {
//            
//            NSLog(@"查询数据成功");
//            return YES;
//        }else{
//            NSLog(@"查询失败,error:%i",temp);
//        }
//    }
//    return NO;
//}

#pragma mark - private methods
//获取Document的路径
- (NSString *)getDocumentPath{
    NSArray *dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return dirPath[0];
}
//获取DB的路径
- (NSString *)getDBPath:(NSString *)dbName{
    return [[self getDocumentPath] stringByAppendingPathComponent:dbName];
}
//DB是否存在
- (BOOL)isExistDB:(NSString *)dbName{
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:[self getDBPath:dbName]]) {
        return YES;
    }
    return NO;
}
//表是否存在
- (BOOL)isExistTable:(NSString *)tableName{
    NSString *sql = [NSString stringWithFormat:@"SELECT name FROM sqlite_master where type = 'table' and name = '%@'",tableName];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        int temp = sqlite3_step(stmt);
        if (temp == SQLITE_ROW) {
            sqlite3_finalize(stmt);
            NSLog(@"表存在");
            return YES;
        }else{
            NSLog(@"table is not exist ,result code is %d",temp);
        }
    }else{
        NSLog(@"判断表是否存在，prepare.error");
    }
    sqlite3_finalize(stmt);
    return NO;
}
//创建DB
- (BOOL)creatDB{
    //判断DB是否存在
    if ([self isExistDB:DB_NAME]) {
        NSLog(@"DB已经存在");
        return YES;
    }
    //创建DB
    NSString *dbPath = [self getDBPath:DB_NAME];
    if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        NSLog(@"创建DB成功");
        sqlite3_close(db);
        return YES;
    }
    sqlite3_close(db);
    NSLog(@"创建DB失败");
    return NO;
}
//创建表
- (BOOL)creatTable{
    if (!(sqlite3_open([[self getDBPath:DB_NAME] UTF8String], &db) == SQLITE_OK)) {
        NSLog(@"建表失败，error：DB打开异常");
        sqlite3_close(db);
        return NO;
    }
    if ([self isExistTable:TABLE_NAME]) {
        NSLog(@"表已经存在");
        sqlite3_close(db);
        return YES;
    }
    char *error;
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, telphoneNum TEXT, city TEXT)",TABLE_NAME];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"建表成功");
        [self closeDB];
        return YES;
    }
    NSLog(@"建表失败,error:%s",error);
    [self closeDB];
    return NO;
}
//打开DB
- (BOOL)openDB{
    return [self openDBWithPath:[self getDBPath:DB_NAME] db:db];
}
//关闭DB
- (void)closeDB{
    [self closeDBWithDB:db];
    db = NULL;
}
- (BOOL)openDBWithPath:(NSString *)path db:(sqlite3 *)db{
#ifdef DEBUG
    NSLog(@"openDataBase begin:%@", path);
#endif
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
#ifdef DEBUG
        NSLog(@"database open fail.");
#endif
        return NO;
    }
#ifdef DEBUG
    NSLog(@"openDataBase end");
#endif
    return YES;
}
- (void)closeDBWithDB:(sqlite3 *)db{
    if (db != NULL) {
#ifdef DEBUG
        NSLog(@"closeDataBase.");
#endif
        int rst = sqlite3_close(db);
        if (rst == SQLITE_OK) {
#ifdef DEBUG
            NSLog(@"CLOSE DATABASE OK");
#endif
        } else {
#ifdef DEBUG
            NSLog(@"closeDataBase.rst=%d", rst);
#endif
        }
    }
}
@end
