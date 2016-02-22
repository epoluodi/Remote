//
//  SearchViewController.m
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "SearchViewController.h"
#import "MainViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize navbar,navtitle;
@synthesize table;
@synthesize IsHidereturn;
@synthesize mainview;
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
    
    emptybtnitem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
    IsHidereturn=YES;
    [self inittable];
    
    [self showLoadview];
    [self StartSearchDevice];
    


    
    // Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated
{
    if ([YNet GetNetWorkState] != WIFI)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"搜索接收设备前,请先设置WIFI网络，点击确定进行设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [navtitle setRightBarButtonItem:nil];
        [navtitle setLeftBarButtonItem:nil];
        return;
    }
    else
    {
        [navtitle setRightBarButtonItem:rightbtnitem];
//        if (IsHidereturn)
//            [navtitle setLeftBarButtonItem:leftbtnitem];
//        else
            [navtitle setLeftBarButtonItem:emptybtnitem];
    }
}




#pragma mark UDP



-(void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"发送完毕");
    [sock close];
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *host = nil;
    uint16_t port = 0;
    
    	[GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
      NSLog(@"来自连接地址--%@",host);
      NSLog(@"来自数据--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSString *devicename =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [sock close];
    
    DeviceInfo * di = [[DeviceInfo alloc] init];
    di.DeviceName =devicename;
    di.DeviceIP =host;
    di.DeviceStatus=@"0";
    [devices addObject:di];
    [table reloadData];
    [condtion lock];
    [condtion signal];
    [condtion unlock];
}
#pragma mark -

//初始化 表格
-(void)inittable
{
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    devices = [[NSMutableArray alloc] init];
    //测试


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
    
    return [devices count];
    
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
    DeviceInfo *di = [devices objectAtIndex:indexPath.row];
    ((MainViewController *)mainview).DeviceIP = di.DeviceIP;
    ((MainViewController *)mainview).DeviceName = di.DeviceName;
    [((MainViewController *)mainview) ConnectToDeviceInit];
    [self dismissViewControllerAnimated:YES completion:nil];
    

}
#pragma mark -

//现实loading
-(void)showLoadview
{
    if (!loadview)
    {
        loadview = [[LoadingView alloc] init];
    }
    condtion = [[NSCondition alloc] init];
  
    [self.view addSubview: loadview];
    [loadview StartAnimation];
  
}

//开始搜索设备
-(void)StartSearchDevice
{
    dispatch_queue_t mainQ = dispatch_get_main_queue();
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ, ^{
        dnet = [[DeviceNet alloc] init];
        [devices removeAllObjects];
        [dnet initdelegate:self];
        [dnet SearchDevice];
        [condtion lock];
        [condtion waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:5]];
        [condtion unlock];
        condtion=nil;
        dispatch_async(mainQ, ^{
            
            [dnet initdelegate:nil];
            [dnet stopSearchDevice];
            dnet=nil;
            [loadview StopAnimation];
            [loadview removeFromSuperview];
            loadview=nil;
            
            if([devices count] == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有搜索到设备，请检查网络!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            }
            
            
        });
    });
}



//搜索点击
-(void)rightbtnlick
{
    

    [self showLoadview];
    [self StartSearchDevice];
    
    

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
