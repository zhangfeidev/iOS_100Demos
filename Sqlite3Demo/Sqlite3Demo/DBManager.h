//
//  DBManager.h
//  SqliteDemo
//
//  Created by Feliu on 16/4/21.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "People.h"

@interface DBManager : NSObject

+ (instancetype)sharedDBManager;
/**
 *  新增一个联系人
 *
 *  @param people 联系人
 *
 *  @return 新增是否成功
 */
- (BOOL)insertPeople:(People *)people;
/**
 *  删除一个联系人
 *
 *  @param name 姓名
 *
 *  @return 删除是否成功
 */
- (BOOL)deleteDataWithname:(NSString *)name;
/**
 *  更新联系人信息
 *
 *  @param name 需要更新的联系人
 *  @param newTelPhone 更新的手机号码
 *  @param newCity 更新的城市
 *
 *  @return 更新是否成功
 */
- (BOOL)updatePeopleWithName:(NSString *)name telPhone:(NSString *)newTelPhone city:(NSString *)newCity;
/**
 *  通过姓名查找联系人
 *
 *  @param name 姓名
 *
 *  @return 联系人数组
 */
- (NSArray *)queryPeopleWithName:(NSString *)name;
/**
 *  通过手机号码查找联系人
 *
 *  @param telPhone 手机号码
 *
 *  @return 联系人数组
 */
- (NSArray *)queryPeopleWithTelphone:(NSString *)telPhone;
/**
 *  查询指定的条数联系人
 *
 *  @param count 指定的条数
 *
 *  @return 联系人数组
 */
- (NSArray *)querySomePeopleWithCount:(NSInteger)count;
/**
 *  查询全部的联系人
 *
 *  @return 联系人数组
 */
- (NSArray *)queryAllPeople;

@end
