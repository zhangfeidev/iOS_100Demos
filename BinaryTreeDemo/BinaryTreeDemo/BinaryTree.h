//
//  BinaryTree.h
//  BinaryTreeDemo
//
//  Created by Feliu on 16/4/10.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BinaryTreeNode;

@interface BinaryTree : NSObject
/**
 *  root节点
 */
@property(nonatomic, strong) BinaryTreeNode *rootNode;
/**
 *  创建一棵二叉树
 *
 *  @return 一颗二叉树
 */
- (BinaryTreeNode *)creatBinaryTree;
/**
 *  前序遍历
 *
 *  @param rootNode root节点
 */
- (void)preOrderTraverse:(BinaryTreeNode *)rootNode;
/**
 *  中序遍历
 *
 *  @param rootNode root节点
 */
- (void)inOrderTraverse:(BinaryTreeNode *)rootNode;
/**
 *  后序遍历
 *
 *  @param rootNode root节点
 */
- (void)postOrderTraerse:(BinaryTreeNode *)rootNode;

@end
