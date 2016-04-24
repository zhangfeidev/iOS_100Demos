//
//  AddViewController.m
//  Sqlite3Demo
//
//  Created by Feliu on 16/4/24.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import "AddViewController.h"
#import "DBManager.h"
#import "People.h"

@interface AddViewController ()

@end

@implementation AddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)add:(UIButton *)sender {
    UILabel *infoLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 20)];
    infoLable.textColor = [UIColor redColor];
    [self.view addSubview:infoLable];
    if ([self.name.text isEqualToString:@""] && [self.telphoneNum.text isEqualToString:@""] && [self.city.text isEqualToString:@""]) {
        infoLable.text = @"联系人信息不能为空";
        return;
    }
    DBManager *manager = [DBManager sharedDBManager];
    NSDictionary *info = @{@"name":self.name.text,@"telphoneNum":self.telphoneNum.text,@"city":self.city.text};
    People *people = [People initPeopleWithDictionary:info];
    if (![manager insertPeople:people]) {
        infoLable.text = @"添加联系人失败";
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(didAddContact)]) {
        [_delegate didAddContact];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
