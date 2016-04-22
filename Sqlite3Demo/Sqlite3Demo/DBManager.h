//
//  DBManager.h
//  SqliteDemo
//
//  Created by Feliu on 16/4/21.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+ (instancetype)sharedDBManager;
- (BOOL)creatDB;
- (BOOL)creatTable;
- (BOOL)insertData:(NSString *)userName password:(NSString *)password;
- (BOOL)deleteData:(NSString *)userName;
- (BOOL)updateData:(NSString *)password userName:(NSString *)userName;
- (BOOL)queryData:(NSString *)userName password:(NSString *)password;
- (BOOL)queryAllData;

@end
