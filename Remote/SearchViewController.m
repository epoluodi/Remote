//
//  SearchViewController.m
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize navbar,navtitle;
@synthesize table;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [navbar setBackgroundImage:[UIImage imageNamed:@"title_bar"] forBarMetrics:UIBarMetricsDefault];
    
    
    //添加标题
    UILabel *titlelab = [[UILabel alloc] init];
    titlelab.text=@"查找我的设备";
    titlelab.textColor= [UIColor whiteColor];
   
    titlelab.frame = CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width, 30);
    titlelab.textAlignment=NSTextAlignmentCenter;
    titlelab.font = [UIFont systemFontOfSize:20];
    navtitle.titleView = titlelab;
    
    //添加搜索
//    UIButton *rightbtn = [[UIButton alloc] init];
//    [rightbtn setTitle:@"搜索" forState:UIControlStateNormal];
//    rightbtn.frame = CGRectMake(0,0, 40, 30);
//    [rightbtn addTarget:self action:@selector(rightbtnlick) forControlEvents:UIControlEventTouchUpInside];
//    [rightbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightbtnitem =[[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(rightbtnlick)];
    


    leftbtnitem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftclick)];
    rightbtnitem.tintColor=[UIColor whiteColor];
    leftbtnitem.tintColor=[UIColor whiteColor];
    [navtitle setRightBarButtonItem:rightbtnitem];
    [navtitle setLeftBarButtonItem:leftbtnitem];
    
    [self inittable];
    // Do any additional setup after loading the view.
}


//初始化 表格
-(void)inittable
{
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    devices = [[NSMutableArray alloc] init];
    //测试
    DeviceInfo *di = [[DeviceInfo alloc] init];
    di.DeviceName =@"测试设备";
    di.DeviceIP = @"192.168.1.1";
    di.DeviceStatus = @"0";
    [devices addObject:di];
    int _row = (int)[devices count];
    rows = &_row;

    UINib *nib = [UINib nibWithNibName:@"deviceCell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"deviceCell"];
    
    table.delegate=self;
    table.dataSource= self;
    //自动执行搜索
}

#pragma mark 表格

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return *rows;
    
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] init];
    return v;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCell *cell = (DeviceCell *)[table dequeueReusableCellWithIdentifier:@"deviceCell"];
    DeviceInfo *di = [devices objectAtIndex:indexPath.row];
    cell.ip.text =[NSString stringWithFormat:@"设备地址：%@", di.DeviceIP ];
    cell.name.text = [NSString stringWithFormat:@"设备名称：%@", di.DeviceName ];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showmain" sender:self];
}
#pragma mark -
//搜索点击
-(void)rightbtnlick
{
    
    
    __block LoadingView *l = [[LoadingView alloc] init];
    [self.view addSubview: l];
    [l StartAnimation];
    
    dispatch_group_t mainQ = dispatch_get_main_queue();
    dispatch_group_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ, ^{
    
        sleep(3);
        dispatch_async(mainQ, ^{
            [l StopAnimation];
            [l  removeFromSuperview];
            l=nil;
        });
    });
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftclick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
