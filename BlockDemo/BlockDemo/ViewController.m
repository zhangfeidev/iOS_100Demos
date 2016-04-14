//
//  ViewController.m
//  BlockDemo
//
//  Created by zhangfei on 16/4/5.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  Block可以看做是一个类C函数
     */
    
    //定义一个Block，名字是：addBlock
    int (^addBlock)(int a,int b);
    addBlock = ^(int a,int b){
        return a + b;
    };
    
    NSLog(@"addBlock's result is %d",addBlock(3,4));
    
    //类似定义一个新的Block类型叫HelloBlock，该‘类型’接收一个String类型的参数，没有返回值
    typedef void (^HelloBlock)(NSString *);
    HelloBlock oneHelloBlock = ^(NSString *hello){
        NSLog(@"%@",hello);
    };
    oneHelloBlock(@"你好");
    //如果要在block内修改block外声明的 栈变量 ，那么一定要对该变量加__block标记
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
