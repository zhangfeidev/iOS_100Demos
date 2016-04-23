//
//  People.m
//  Sqlite3Demo
//
//  Created by Feliu on 16/4/22.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import "People.h"

@implementation People

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)initPeopleWithDictionary:(NSDictionary *)dic{
    People *people = [[People alloc] init];
    people.name = [dic valueForKey:@"name"];
    people.telphoneNum = [dic valueForKey:@"telPhone"];
    people.city = [dic valueForKey:@"city"];
    return people;
}
@end
