//
//  ViewController.h
//  SqliteDemo
//
//  Created by zhangfei on 16/4/18.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

- (IBAction)login:(id)sender;

@end

