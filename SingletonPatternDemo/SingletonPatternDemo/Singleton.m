//
//  Singleton.m
//  SingletonPatternDemo
//
//  Created by Feliu on 16/4/10.
//  Copyright © 2016年 Feliu. All rights reserved.
//  苹果官方单例示例地址：https://developer.apple.com/legacy/library/documentation/Cocoa/Conceptual/CocoaFundamentals/CocoaObjects/CocoaObjects.html#//apple_ref/doc/uid/TP40002974-CH4-SW32

#import "Singleton.h"

static Singleton *shareInstance = nil;

@implementation Singleton

+ (instancetype)shareSingleton{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[Singleton alloc] init];
    });
    return shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self) {
        if (shareInstance == nil) {
            shareInstance = [super allocWithZone:zone];
            return shareInstance;
        }
    }
    return shareInstance;
}

+ (instancetype)new{
    return [self shareSingleton];
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

/*
- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}
 */
@end
