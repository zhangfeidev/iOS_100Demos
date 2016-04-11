//
//  BinaryTreeNode.h
//  BinaryTreeDemo
//
//  Created by Feliu on 16/4/10.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BinaryTreeNode : NSObject
/**
 *  数据
 */
@property(nonatomic, strong) id data;
/**
 *  左节点
 */
@property(nonatomic, strong) BinaryTreeNode *leftNode;
/**
 *  右节点
 */
@property(nonatomic, strong) BinaryTreeNode *rightNode;

@end
