//
//  ScanFileController.m
//  Remote
//
//  Created by 程嘉雯 on 16/2/28.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "ScanFileController.h"
#import "MainViewController.h"
#import "LoadingView.h"
#import "TipView.h"
#import "FolderCell.h"

@interface ScanFileController ()
{
    DeviceNet *dnet;
    __block LoadingView *loadview;
    TipView *tip;
}
@end

@implementation ScanFileController
@synthesize navbar;
@synthesize table;
@synthesize mainview;
@synthesize flag;
@synthesize btnscan;
@synthesize IsClose;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    IsClose=NO;
    if (!flag)
        title = [[UINavigationItem alloc] initWithTitle:@"请选择媒体文件所在的文件夹"];
    else
        title = [[UINavigationItem alloc] initWithTitle:@"请选择配置文件所在的文件夹"];
    btnreturn = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(clickreturn)];
    btnUpdir = [[UIBarButtonItem alloc] initWithTitle:@"上一层" style:UIBarButtonItemStylePlain target:self action:@selector(clickupdir)];
    
    UIImage *image1 = [PublicCommon createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:1.00]
                                                    Rect:CGRectMake(0, 0, btnscan.frame.size.width, btnscan.frame.size.height) ];
    
    UIImage *image2 = [PublicCommon createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:.5f]
                                                    Rect:CGRectMake(0, 0, btnscan.frame.size.width, btnscan.frame.size.height)];
    
    [btnscan setBackgroundImage:image1 forState:UIControlStateNormal];
    [btnscan setBackgroundImage:image2 forState:UIControlStateHighlighted];
    btnscan.layer.cornerRadius = 8;
    btnscan.layer.masksToBounds=YES;
    
    [navbar pushNavigationItem:title animated:YES];
    
    [title setLeftBarButtonItem:btnreturn];
    [title setRightBarButtonItem:btnUpdir];
    
    dirlist = [[NSArray alloc] init];
    returndir = [[NSMutableArray alloc] init];

    selectmediaID = [[NSMutableArray alloc] init];
    table.delegate=self;
    table.dataSource=self;
    nowdir = @"";
    [self LoadDir:nowdir];

}


-(void)LoadDir:(NSString *)dir
{
    if (!loadview)
        loadview = [[LoadingView alloc] init];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        
        [dnet getAllSysDir:((MainViewController *)mainview).DeviceIP arg:dir];
    });
}

#pragma mark table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dirlist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FolderCell *cell;
    NSDictionary *d = [dirlist objectAtIndex:indexPath.row];

    cell= (mediaCellEdit *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
    
    if (!cell){
        
        UINib *nib = [UINib nibWithNibName:@"folderCell" bundle:nil];
        [table registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
        cell= (FolderCell *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
        cell.scanview=self;
        cell.foldername.text = [d objectForKey:@"name"];
        cell.folderallname = [d objectForKey:@"path"];
 
        
       
        return cell;
    }
    cell.foldername.text = [d objectForKey:@"name"];
    cell.folderallname = [d objectForKey:@"path"];
    NSLog(@"%@",cell.folderallname);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v= [[UIView alloc] init];
    return v;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *v = [[UIView alloc] init];
    v.frame = cell.contentView.frame;
    v.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.1f];
    cell.selectedBackgroundView = v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *d = [dirlist objectAtIndex:indexPath.row];
    [returndir addObject: nowdir];
    nowdir = [d objectForKey:@"path"];
    [self LoadDir:nowdir];
    
}


#pragma mark -
#pragma mark 通信操作委托
-(void)CommandFinish:(CommandType)commandtype json:(NSDictionary *)json
{
    
    if (loadview){
        [loadview StopAnimation];
        [loadview removeFromSuperview];
        loadview = nil;
    }
    
    if (commandtype == ELoadSysDir )
    {
        NSLog(@"获得数据");
        
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (success){
            dirlist = [json objectForKey:@"data"];
            if (IsClose){
            for (int i = 0 ; i< [dirlist count]; i++) {
                FolderCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                [cell resetchkstate];
            }
            
        }
        else
            IsClose=YES;
            [selectmediaID removeAllObjects];
            [table reloadData];
        }
        else
            [self CommandTimeout];
        return;
    }
    
    if (commandtype == EScanDir || commandtype == EReplaceDB)
    {
        NSLog(@"获得数据");
        
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (success){
            
            tip=[[TipView alloc] init:@"扫描完成"];
            [tip showTip:mainview];
            [self dismissViewControllerAnimated:YES completion:nil];
        }

        else{
            tip=[[TipView alloc] init:@"扫描失败"];
            [tip showTip:self];
        }
        return;
    }
    
    
}
-(void)CommandTimeout
{
    
    if (loadview){
        [loadview StopAnimation];
        [loadview removeFromSuperview];
        loadview = nil;
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误，请重新尝试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


#pragma mark -


-(void)ChangeSelectList:(NSString *)mediaid flag:(BOOL)_flag
{
    if (_flag)
        [selectmediaID addObject:mediaid];
    else{
        [selectmediaID removeObject:mediaid];
     
  
    }
}


-(void)clickupdir
{
    if ([returndir count] == 0)
        return;
    nowdir = [returndir objectAtIndex:[returndir count] -1];
    [returndir removeObjectAtIndex:[returndir count] -1];
    [self LoadDir:nowdir];
}

-(void)clickreturn
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)clickScan:(id)sender {
    if (!loadview)
        loadview = [[LoadingView alloc] init];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        if (!flag){
        NSString *arg = [NSString stringWithFormat:@"%@%%~%%%@",((MainViewController *)mainview).getNowt1Title,[selectmediaID componentsJoinedByString:@","]];
        [dnet ScanSysDir:((MainViewController *)mainview).DeviceIP arg:arg];
        }
        else
        {
            NSString *arg = [NSString stringWithFormat:@"%@",[selectmediaID componentsJoinedByString:@","]];
            [dnet ReplaceDB:((MainViewController *)mainview).DeviceIP arg:arg];
        }
    });
    
    
}
@end
