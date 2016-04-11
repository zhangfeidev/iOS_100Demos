//
//  main.m
//  BinaryTreeDemo
//
//  Created by Feliu on 16/4/10.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryTree.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        BinaryTree *tree = [[BinaryTree alloc] init];
        [tree creatBinaryTree];
        NSLog(@"前序遍历");
        [tree preOrderTraverse:tree.rootNode];
        NSLog(@"中序遍历");
        [tree inOrderTraverse:tree.rootNode];
        NSLog(@"后序遍历");
        [tree postOrderTraerse:tree.rootNode];
        
    }
    return 0;
}
