//
//  AddViewController.h
//  Sqlite3Demo
//
//  Created by Feliu on 16/4/24.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddViewControllerDelegate <NSObject>

- (void)didAddContact;

@end

@interface AddViewController : UIViewController

@property (nonatomic, weak) id<AddViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *telphoneNum;
@property (weak, nonatomic) IBOutlet UITextField *city;

- (IBAction)add:(UIButton *)sender;
@end
