//
//  BinaryTreeNode.m
//  BinaryTreeDemo
//
//  Created by Feliu on 16/4/10.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import "BinaryTreeNode.h"

@implementation BinaryTreeNode

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = nil;
        _leftNode = nil;
        _rightNode = nil;
    }
    return self;
}

@end
