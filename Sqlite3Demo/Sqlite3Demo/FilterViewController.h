//
//  FilterViewController.h
//  Sqlite3Demo
//
//  Created by Feliu on 16/4/24.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate <NSObject>

- (void)didFilterByCity:(NSString *)city;
- (void)didFilterByConut:(NSString *)count;

@end

@interface FilterViewController : UIViewController

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *errorInfo;
@property (weak, nonatomic) IBOutlet UITextField *cityFilter;
@property (weak, nonatomic) IBOutlet UITextField *countFilter;

- (IBAction)filterByCity:(UIButton *)sender;
- (IBAction)filterByCount:(UIButton *)sender;
@end
