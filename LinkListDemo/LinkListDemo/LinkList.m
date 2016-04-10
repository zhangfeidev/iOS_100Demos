//
//  LinkList.m
//  LinkListDemo
//
//  Created by zhangfei on 16/3/30.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import "LinkList.h"
#import "Node.h"

@interface LinkList()

@end

@implementation LinkList

- (instancetype)init
{
    self = [super init];
    if (self) {
        _firstNode = nil;
        _lastNode = nil;
    }
    return self;
}

- (instancetype)initWithElement:(id)element{
    [self insert:element];
    return self;
}

- (void)insert:(id)element{
    Node *oneNode = [[Node alloc] init];
    oneNode.data = element;
    oneNode.next = nil;
    if (self.lastNode == nil) {
        self.lastNode = oneNode;
        self.firstNode = oneNode;
        self.length = 1;
        return;
    }
    self.lastNode.next = oneNode;
    self.lastNode = oneNode;
    self.length++;
}

- (void)deleteFirstElement{
    if (self.length == 0) {
        NSLog(@"链表为空");
        return;
    }
    self.firstNode = self.firstNode.next;
    self.length--;
}

- (void)delete:(id)element{
    if (self.firstNode == nil) {
        NSLog(@"链表为空");
        return;
    }
    if ([self.firstNode.data isEqual:element]) {
        self.firstNode = self.firstNode.next;
    }else{
        Node *pre = self.firstNode;
        Node *cur = self.firstNode;
        while (cur != nil) {
            if ([cur.data isEqual:element]) {
                pre.next = cur.next;
                self.length--;
            }
            pre = cur;
            cur = cur.next;
        }
    }
}

- (BOOL)replace:(id)originElement replaceElement:(id)replace{
    if (self.firstNode == nil) {
        NSLog(@"链表为空");
        return NO;
    }
    Node *node = self.firstNode;
    while (node != nil) {
        if ([node.data isEqual:originElement]) {
            node.data = replace;
            return YES;
        }
        node = node.next;
    }
    NSLog(@"你要替换掉元素不存在");
    return NO;
}

- (BOOL)find:(id)element{
    Node *node = self.firstNode;
    while (node != nil) {
        if ([node.data isEqual:element]) {
            return YES;
        }
        node = node.next;
    }
    return NO;
}

- (void)display:(Node *)head{
    if (self.lastNode == nil) {
        NSLog(@"empty");
        return;
    }
    Node *node = head;
    NSMutableString *listStr = nil;
    while (node != nil) {
        if (listStr == nil) {
            listStr = (NSMutableString *)[NSString stringWithFormat:@"%@",node.data];
        }else{
            listStr = (NSMutableString *)[NSString stringWithFormat:@"%@ -> %@",listStr,node.data];
        }
        node = node.next;
    }
    NSLog(@"%@",listStr);
}

- (Node *)reverseLinkList:(Node *)head{
    //采用递归的方式
    if (head == nil || head.next == nil) {
        return head;
    }
    Node *reverseHead = [self reverseLinkList:head.next];
    head.next.next = head;
    head.next = nil;
    return reverseHead;
    
    
    /*
    //采用三个指针遍历的方式
    if (head == nil || head.next == nil) {
        return head;
    }
    
    Node *pre = head;
    Node *cur = head.next;
    Node *next;
    while (cur != nil) {
        next = cur.next;
        cur.next = pre;
        pre = cur;
        cur = next;
    }
    
    head.next = nil;
    head = pre;
    return head;
     */
}

@end
