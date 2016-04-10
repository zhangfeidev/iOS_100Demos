//
//  LinkList.h
//  LinkListDemo
//
//  Created by zhangfei on 16/3/30.
//  Copyright © 2016年 zhangfei. All rights reserved.
//  单链表

#import <Foundation/Foundation.h>

@class Node;

@interface LinkList : NSObject

/**
 *  链表的长度
 */
@property (nonatomic, assign) NSInteger length;
/**
 *  链表的头结点
 */
@property (nonatomic, strong) Node *firstNode;
/**
 *  链表的尾节点
 */
@property (nonatomic, strong) Node *lastNode;
/**
 *  用一个元素初始化一个链表
 *
 *  @param element 元素
 *
 *  @return 链表
 */
- (instancetype)initWithElement:(id)element;
/**
 *  插入一个元素
 *
 *  @param element 元素
 */
- (void)insert:(id)element;
/**
 *  删除第一个元素
 */
- (void)deleteFirstElement;
/**
 *  移除一个元素
 *
 *  @param element 元素
 */
- (void)delete:(id)element;
/**
 *  替换一个元素
 *
 *  @param element 替换的新值
 *
 *  @return 是否替换成功
 */
- (BOOL)replace:(id)originElement replaceElement:(id)replace;
/**
 *  查找
 *
 *  @param element
 *
 *  @return 是否存在
 */
- (BOOL)find:(id)element;
/**
 *  打印链表
 */
- (void)display:(Node *)head;
/**
 *  反转链表
 *
 *  @param head 链表的头结点
 *
 *  @return 反转后链表的头结点
 */
- (Node *)reverseLinkList:(Node *)head;

@end
