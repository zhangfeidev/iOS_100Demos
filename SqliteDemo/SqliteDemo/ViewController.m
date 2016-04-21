//
//  ViewController.m
//  SqliteDemo
//
//  Created by zhangfei on 16/4/18.
//  Copyright © 2016年 zhangfei. All rights reserved.
//

#import "ViewController.h"
#import "HomePageViewController.h"
#import <sqlite3.h>

static sqlite3 *database = nil;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (IBAction)login:(id)sender {
    NSString *userName = self.userName.text;
    NSString *passWord = self.passWord.text;
    //获取数据库路径,user.sqlite是数据库的名字
    NSString *dbPath = [self getDataBasePathWithName:@"user.sqlite"];
    //是否存在数据库，存在：打开数据库；不存在：新建
    BOOL isExistDB = [self isDatabaseExist:@"user.sqlite"];
    if (isExistDB) {
        //数据库存在
        if (sqlite3_open([dbPath UTF8String],&database) == SQLITE_OK) {
            //打开数据库成功
            //判断表是否存在，存在：打开表查询用户名；不存在：新建表，并且将数据存入数据库
            BOOL isExistsTabview = [self isTableExist:@"userinfo"];
            if (isExistsTabview) {
                //表存在，打开表查询用户名；如果用户名在表中存在，查询密码是否正确
                NSString *selectSql = [NSString stringWithFormat:@"SELECT username FROM userinfo where username = '%@' and password = '%@'",userName,passWord];
                sqlite3_stmt *stmt;
//                if (sqlite3_exec(database, [selectSql UTF8String], NULL, NULL, NULL) == SQLITE_OK) {
//                    NSLog(@"000000");
//                }else{
//                    NSLog(@"dffjfdfn");
//                }
                
                if (sqlite3_prepare_v2(database, [selectSql UTF8String], -1, &stmt, NULL) == SQLITE_OK) {
                    int stepStatus = sqlite3_step(stmt);
                    if (stepStatus == SQLITE_ROW) {
                        //用户名和密码存在，登录
                        //NSString *name = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(stmt, 0)];
                        NSLog(@"登录成功!");
                        HomePageViewController *homePage = [[HomePageViewController alloc] init];
                        [self.navigationController pushViewController:homePage animated:YES];
                    }else{
                        //不存在，登录失败
                        NSLog(@"登录失败！");
                        return;
                    }
                }else{
                    //执行查询语句失败
                    NSLog(@"执行语句失败");
                }
            }else{
                //表不存在，新建表，将用户名和密码存入表中
                NSLog(@"表不存在");
                return;
            }
        }else{
            //打开数据库失败
            NSLog(@"数据库存在，但是打开失败");
            return;
        }
        
        
    }
    //数据库不存在
    
    //通过sqlite3_open函数来打开一个数据库，如果不存在则新建一个，所以新建一个数据库也是这个函数
    //sqlite3_open的第一个参数是数据库的路径，是char类型的，所以需要转一下；第二个是sqlite句柄
    BOOL isOpenSuccess = sqlite3_open([dbPath UTF8String],&database) == SQLITE_OK;
    if (isOpenSuccess) {
        //表明已经创建或者打开成功
        //是否存在表userinfo,不用判断也可以，因为已经存在的表再创建一次是不会覆盖创建的
        BOOL isExistsTabview = [self isTableExist:@"userinfo"];
        //如果存在表就不用创建了
        if (!isExistsTabview) {
            char *error;//捕获错误信息
            //创建一张userinfo表，用来存放用户名和密码
            NSString *sql = @"CREATE TABLE IF NOT EXISTS userinfo (ID INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, password TEXT)";
            if (sqlite3_exec(database,[sql UTF8String],NULL,NULL,&error) != SQLITE_OK) {
                //创建表失败
                NSLog(@"创建表失败,error:%s",error);
                sqlite3_close(database);
                return;
            }
            //创建表成功
            NSLog(@"创建表成功");
        }
        //将数据插入表中
        NSString *insertDataSql = [NSString stringWithFormat:@"INSERT INTO userinfo ('username', 'password') values ('%@', '%@')",userName,passWord];
        if (sqlite3_exec(database,[insertDataSql UTF8String],NULL,NULL,NULL) != SQLITE_OK) {
            //插入数据失败
            NSLog(@"插入数据失败");
            return;
        }
        //插入数据成功
        NSLog(@"插入数据成功");
        sqlite3_close(database);//不管成功与否都要关闭数据库
    } else{
        //表明创建或者打开失败
        sqlite3_close(database);
    }
    
    //[self performSegueWithIdentifier:@"login" sender:self];
}
//获取Document的路径
- (NSString *)getDocumentPath{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return dirPaths[0];
}
//获取DB的路径
- (NSString *)getDataBasePathWithName:(NSString *)name{
    return [[self getDocumentPath] stringByAppendingPathComponent:name];
}
//判断DB是否存在
- (BOOL)isDatabaseExist:(NSString *)dbName{
    NSString *dbPath = [self getDataBasePathWithName:dbName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:dbPath]) {
        return YES;
    }
    return NO;
}
#pragma mark - 判断该表是否存在
- (BOOL)isTableExist:(NSString *)aTableName{
    BOOL exist = NO;
    sqlite3_stmt *stmt;//解析以后的sql语句就放在这个结构里,相当于sql语句的句柄
    NSString *judgeString = [NSString stringWithFormat:@"SELECT name FROM sqlite_master where type ='table' and name = '%@';",aTableName];
    const char *sql_stmt = [judgeString UTF8String];
    if (sqlite3_prepare_v2(database, sql_stmt, -1, &stmt, nil) == SQLITE_OK){
        int temp = sqlite3_step(stmt);
        if (temp == SQLITE_ROW){
            exist = YES;
        } else{
            //sqlite3_step() has finished executing
            NSLog(@"table is not exist ,result code is %d",temp);
        } 
    }
    sqlite3_finalize(stmt); 
    
    return exist; 
}
@end
