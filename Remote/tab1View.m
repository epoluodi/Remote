//
//  tab1View.m
//  Remote
//
//  Created by Stereo on 16/1/25.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

//tab1 界面

#import "tab1View.h"
#import "MainViewController.h"
#import "LoadingView.h"


@interface tab1View ()
{
    DeviceNet *dnet;
    __block LoadingView *loadview;
}

@end

@implementation tab1View
@synthesize delegate;
@synthesize mainview;


-(UITableView *)tableinit:(CGRect)frame
{
    table = [[UITableView alloc] init];
    
    table.backgroundColor=[UIColor clearColor];
    table.separatorColor=[UIColor whiteColor];
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(changerefreshstate) forControlEvents:UIControlEventValueChanged];
    //    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"努力加载中……"];
    
    refresh.tintColor = [UIColor whiteColor];
    [table addSubview:refresh];
    
    table.frame = frame;
    table.delegate=self;
    table.dataSource=self;
    
    
    
    return table;
}


//刷新类型
-(void)LoadContentType
{
    
    if (!loadview)
        loadview = [[LoadingView alloc] init];
    [mainview.view addSubview:loadview];
    [loadview StartAnimation];
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        [dnet getContentType:((MainViewController *)mainview).DeviceIP];
        
    });
    
    
}

-(void)CommandFinish:(CommandType)commandtype json:(NSDictionary *)json
{
    if (loadview){
        [loadview StopAnimation];
        [loadview removeFromSuperview];
        loadview = nil;
    }
    if (refresh.refreshing)
    {
        [refresh endRefreshing];
    }
    if (commandtype == EloadContentType)
    {
        NSLog(@"获得数据");
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
    if (refresh.refreshing)
    {
        [refresh endRefreshing];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误，请重新尝试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


//开始刷新
-(void)changerefreshstate
{
    if (refresh.refreshing)
    {
        [self LoadContentType];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((MainViewController*)mainview).ContentType)
        return [((MainViewController*)mainview).ContentType count];
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    cell.textLabel.textColor=[UIColor whiteColor];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"音频";
            break;
        case 1:
            cell.textLabel.text=@"视频";
            break;
        case 2:
            cell.textLabel.text=@"个性栏目";
            break;
            
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
    v.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    cell.selectedBackgroundView = v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [table cellForRowAtIndexPath:indexPath];
    [delegate ItemClick:cell.textLabel.text];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
