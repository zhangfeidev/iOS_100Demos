//
//  ViewController.m
//  Sqlite3Demo
//
//  Created by Feliu on 16/4/22.
//  Copyright © 2016年 Feliu. All rights reserved.
//

#import "ViewController.h"
#import "People.h"
#import "DBManager.h"

#import "AddViewController.h"
#import "FilterViewController.h"

@interface ViewController () <AddViewControllerDelegate,FilterViewControllerDelegate>

@property (nonatomic, copy) NSArray *data;
@property (nonatomic, strong) People *mode;
@property (nonatomic, strong) DBManager *manager;

@end

@implementation ViewController
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager = [DBManager sharedDBManager];
    self.data = [self.manager queryAllPeople];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - tabview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *rid=@"reuseIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:rid];
    }
    _mode = self.data[indexPath.row];
    cell.textLabel.text = _mode.name;
    NSString *detailText = [NSString stringWithFormat:@"%@  |  %@",_mode.telphoneNum,_mode.city];
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return YES;
}
#pragma mark - AddViewController Delegate
- (void)didAddContact{
    self.data = [self.manager queryAllPeople];
}
#pragma mark - FilterViewController Delegate
- (void)didFilterByCity:(NSString *)city{
    
}
- (void)didFilterByConut:(NSString *)count{
    
}
@end
