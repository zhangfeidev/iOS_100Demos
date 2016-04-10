//
//  Node.m
//  LinkListDemo
//
//  Created by zhangfei on 16/3/30.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import "Node.h"

@implementation Node

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = nil;
        _next = nil;
    }
    return self;
}
@end
