//
//  ViewController.m
//  SingletonPatternDemo
//
//  Created by Feliu on 16/4/10.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import "ViewController.h"
#import "Singleton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Singleton *singleTon = [Singleton shareSingleton];
    NSLog(@"singleTon:%p",singleTon);
    Singleton *singleTon2 = [Singleton new];
    NSLog(@"singleTon2:%p",singleTon2);
    Singleton *singleTon3 = [[Singleton alloc] init];
    NSLog(@"singleTon3:%p",singleTon3);
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
