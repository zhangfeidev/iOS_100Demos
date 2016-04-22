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

@implementation DBManager

static DBManager *sharedInstance;
static sqlite3 *db;

#pragma mark - life cycle
+ (instancetype)sharedDBManager{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
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
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (ID INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)",TABLE_NAME];
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"建表成功");
        sqlite3_close(db);
        return YES;
    }
    NSLog(@"建表失败,error:%s",error);
    sqlite3_close(db);
    return NO;
}

- (BOOL)insertData:(NSString *)userName password:(NSString *)password{
    if (!(sqlite3_open([[self getDBPath:DB_NAME] UTF8String], &db) == SQLITE_OK)) {
        NSLog(@"插入数据失败,error：未能打开DB");
        sqlite3_close(db);
        return NO;
    }
    if (![self isExistTable:TABLE_NAME]) {
        NSLog(@"插入数据失败,error:表不存在");
        sqlite3_close(db);
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (username, password) VALUES('%@', '%@')",TABLE_NAME,userName,password];
    char *error;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"插入数据成功");
        sqlite3_close(db);
        return YES;
    }
    NSLog(@"插入数据失败,error:%s",error);
    sqlite3_close(db);
    return NO;
}

- (BOOL)deleteData:(NSString *)userName{
    if (sqlite3_open([[self getDBPath:DB_NAME] UTF8String], &db)) {
        NSLog(@"删除数据失败,error：未能打开DB");
        sqlite3_close(db);
        return NO;
    }
    if (![self isExistTable:TABLE_NAME]) {
        NSLog(@"删除数据失败,error:表不存在");
        sqlite3_close(db);
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE username = '%@'",TABLE_NAME,userName];
    char *error;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"删除数据成功");
        sqlite3_close(db);
        return YES;
    }
    NSLog(@"删除数据失败，error:%s",error);
    return NO;
}

- (BOOL)updateData:(NSString *)password userName:(NSString *)userName{
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
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET password = '%@' WHERE name = '%@'",TABLE_NAME,password,userName];
    char *error;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        NSLog(@"更新数据成功");
        sqlite3_close(db);
        return YES;
    }
    NSLog(@"更新数据失败，error:%s",error);
    return NO;
}

- (BOOL)queryData:(NSString *)userName password:(NSString *)password{
    if (sqlite3_open([[self getDBPath:DB_NAME] UTF8String], &db)) {
        NSLog(@"查询数据失败,error：未能打开DB");
        sqlite3_close(db);
        return NO;
    }
    if (![self isExistTable:TABLE_NAME]) {
        NSLog(@"查询数据失败,error:表不存在");
        sqlite3_close(db);
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE username = '%@' AND password = '%@'",TABLE_NAME,userName,password];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        int temp = sqlite3_step(stmt);
        if (temp == SQLITE_ROW) {
            NSLog(@"查询数据成功");
            return YES;
        }else{
            NSLog(@"查询失败,error:%i",temp);
        }
    }
    return NO;
}
- (BOOL)queryAllData{
    if (sqlite3_open([[self getDBPath:DB_NAME] UTF8String], &db)) {
        NSLog(@"查询数据失败,error：未能打开DB");
        sqlite3_close(db);
        return NO;
    }
    if (![self isExistTable:TABLE_NAME]) {
        NSLog(@"查询数据失败,error:表不存在");
        sqlite3_close(db);
        return NO;
    }
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@]",TABLE_NAME];
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
        int temp = sqlite3_step(stmt);
        if (temp == SQLITE_ROW) {
            
            NSLog(@"查询数据成功");
            return YES;
        }else{
            NSLog(@"查询失败,error:%i",temp);
        }
    }
    return NO;
}

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
            return YES;
        }else{
            NSLog(@"table is not exist ,result code is %d",temp);
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}

@end
