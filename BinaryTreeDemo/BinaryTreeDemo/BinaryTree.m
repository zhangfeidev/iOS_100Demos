//
//  BinaryTree.m
//  BinaryTreeDemo
//
//  Created by Feliu on 16/4/10.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import "BinaryTree.h"
#import "BinaryTreeNode.h"

@interface BinaryTree ()

@end

@implementation BinaryTree

- (BinaryTreeNode *)creatBinaryTree{
    
    BinaryTreeNode *rootNode = [[BinaryTreeNode alloc] init];
    rootNode.data = @0;
    self.rootNode = rootNode;
    
    BinaryTreeNode *oneNode = [[BinaryTreeNode alloc] init];
    oneNode.data = @1;
    BinaryTreeNode *twoNode = [[BinaryTreeNode alloc] init];
    twoNode.data = @2;
    BinaryTreeNode *threeNode = [[BinaryTreeNode alloc] init];
    threeNode.data = @3;
    BinaryTreeNode *fourNode = [[BinaryTreeNode alloc] init];
    fourNode.data = @4;
    BinaryTreeNode *fiveNode = [[BinaryTreeNode alloc] init];
    fiveNode.data = @5;
    BinaryTreeNode *sixNode = [[BinaryTreeNode alloc] init];
    sixNode.data = @6;
    BinaryTreeNode *sevenNode = [[BinaryTreeNode alloc] init];
    sevenNode.data = @7;
    
    rootNode.leftNode = oneNode;
    rootNode.rightNode = twoNode;
    
    oneNode.leftNode = threeNode;
    oneNode.rightNode = fourNode;
    
    twoNode.leftNode = fiveNode;
    twoNode.rightNode = sixNode;
    
    fiveNode.leftNode = sevenNode;
    
    return rootNode;
}

- (void)preOrderTraverse:(BinaryTreeNode *)rootNode{
    if (rootNode == nil) {
        return;
    }
    NSString *str = [NSString stringWithFormat:@"%@ ",rootNode.data];
    NSLog(@"%@",str);
    [self preOrderTraverse:rootNode.leftNode];
    [self preOrderTraverse:rootNode.rightNode];
}

- (void)inOrderTraverse:(BinaryTreeNode *)rootNode{
    if (rootNode == nil) {
        return;
    }
    [self inOrderTraverse:rootNode.leftNode];
    NSString *str = [NSString stringWithFormat:@"%@ ",rootNode.data];
    NSLog(@"%@",str);
    [self inOrderTraverse:rootNode.rightNode];
}

- (void)postOrderTraerse:(BinaryTreeNode *)rootNode{
    if (rootNode == nil) {
        return;
    }
    [self postOrderTraerse:rootNode.leftNode];
    [self postOrderTraerse:rootNode.rightNode];
    NSString *str = [NSString stringWithFormat:@"%@ ",rootNode.data];
    NSLog(@"%@",str);
}
@end
