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
    return NO;
}

- (BOOL)creatTable{
    return NO;
}

- (BOOL)insertData:(NSString *)userName password:(NSString *)password{
    return NO;
}

- (BOOL)deleteData:(NSString *)userName{
    return NO;
}

- (BOOL)updateData:(NSString *)password{
    return NO;
}

- (BOOL)queryData:(NSString *)userName password:(NSString *)password{
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
    if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &stmt, NULL)) {
        if (sqlite3_step(stmt) == SQLITE_OK) {
            return YES;
        }else{
            int temp = sqlite3_step(stmt);
            NSLog(@"table is not exist ,result code is %d",temp);
        }
    }
    sqlite3_finalize(stmt);
    return NO;
}
@end
