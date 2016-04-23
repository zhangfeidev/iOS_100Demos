//
//  People.h
//  Sqlite3Demo
//
//  Created by Feliu on 16/4/22.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *telphoneNum;
@property (nonatomic, copy) NSString *city;

+ (instancetype)initPeopleWithDictionary:(NSDictionary *)dic;

@end
