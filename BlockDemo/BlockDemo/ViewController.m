//
//  ViewController.m
//  BlockDemo
//
//  Created by zhangfei on 16/4/5.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

typedef  void (^AddCallBlock)(int r);


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  Block可以看做是一个类C函数
     */
    
    //定义一个Block，名字是：addBlock，参数是a,b;返回值是int类型的
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
    
    //block作为回调
    [self addTwoIntNum:1 num2:2 withBlock:^(int r) {
        NSLog(@"1+2=%i",r);
    }];
    
    Person *p = [[Person alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self doSamething:p];
    });
    
    int (^testBlock)(void) = ^(void){
        return 1;
    };
    NSLog(@"%i",testBlock());
    
}

//将block作为函数的参数来达到回调的目的
- (void)addTwoIntNum:(int)a num2:(int)b withBlock:(AddCallBlock)addblock{
    int r = a + b;
    addblock(r);
}

- (void)doSamething:(Person *)p{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
