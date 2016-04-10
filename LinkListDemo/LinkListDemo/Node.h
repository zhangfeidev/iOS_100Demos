//
//  Node.h
//  LinkListDemo
//
//  Created by zhangfei on 16/3/30.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Node : NSObject

/**
 *  数据域
 */
@property (nonatomic, strong) id data;
/**
 *  指针域
 */
@property (nonatomic, strong) Node *next;

@end
