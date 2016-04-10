//
//  main.m
//  LinkListDemo
//
//  Created by zhangfei on 16/3/30.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinkList.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        LinkList *list = [[LinkList alloc] init];
        [list insert:@1];
        [list insert:@2];
        [list insert:@3];
        [list insert:@4];
        [list insert:@5];
        [list insert:@6];
        [list insert:@7];
        [list insert:@8];
        [list insert:@9];
        [list insert:@10];
        [list deleteFirstElement];
        [list deleteFirstElement];
        [list delete:@10];
        [list replace:@7 replaceElement:@"你好"];
        [list display:list.firstNode];
        NSLog(@"%hhd",[list find:@00]);
        NSLog(@"链表的长度：%ld",(long)list.length);
        
        [list display:list.firstNode];
        Node *reversedFirstNode = [list reverseLinkList:list.firstNode];
        [list display:reversedFirstNode];
        
    }
    return 0;
}
