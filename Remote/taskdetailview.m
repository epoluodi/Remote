//
//  taskdetailview.m
//  Remote
//
//  Created by 程嘉雯 on 16/3/3.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "taskdetailview.h"
#import "MainViewController.h"
#import "LoadingView.h"

@interface taskdetailview ()
{
    __block LoadingView *loadview;
}

@end

@implementation taskdetailview
@synthesize title,btnadd,btncheck,btndel,btnreturn,table;
@synthesize mainview,delegate;
@synthesize IsAllSelect,IsClose;
@synthesize taskid;
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)awakeFromNib
{
    [self setBackgroundColor:[UIColor clearColor]];
    title.textColor=[UIColor whiteColor];
    table.backgroundColor=[UIColor clearColor];
    selectmediaID = [[NSMutableArray alloc] init];
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(changerefreshstate) forControlEvents:UIControlEventValueChanged];
    [table addSubview:refresh];
    table.delegate=self;
    table.dataSource=self;
    detaillist = nil;
}

//开始刷新
-(void)changerefreshstate
{
    if (refresh.refreshing){
        [self willChangeValueForKey:@"IsAllSelect"];
        
        IsAllSelect=NO;
        [btncheck setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        
        [self didChangeValueForKey:@"IsAllSelect"];
        [self willChangeValueForKey:@"IsClose"];
        IsClose=YES;
        [self didChangeValueForKey:@"IsClose"];
        [self loadtaskdetailinfo];
    }
}
-(void)ChangeSelectList:(NSString *)mediaid flag:(BOOL)flag
{
    if (flag)
        [selectmediaID addObject:mediaid];
    else{
        [selectmediaID removeObject:mediaid];
        IsAllSelect=NO;
        [btncheck setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
}

//读取任务中的详细信息
-(void)loadtaskdetailinfo
{
    [refresh beginRefreshing];
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        [dnet GetTaskDetailInfo:((MainViewController *)mainview).DeviceIP arg:taskid];
        
    });
}
- (IBAction)clickreturn:(id)sender {
    [self willChangeValueForKey:@"IsClose"];
    IsClose=YES;
    [self didChangeValueForKey:@"IsClose"];
    [delegate Clickbackfortaskdetail];
}

- (IBAction)clickadd:(id)sender {
    
}

- (IBAction)clickdel:(id)sender {
    
    if ([selectmediaID count]==0)
        return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确认移除 %d条文件",(int)selectmediaID.count] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *arg  = [selectmediaID componentsJoinedByString:@","];
        
        if (!loadview)
            loadview = [[LoadingView alloc] init];
        [mainview.view addSubview:loadview];
        [loadview StartAnimation];
        
        dnet = [[DeviceNet alloc] init];
        dnet.Commanddelegate=self;
        dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQ , ^{
            
            [dnet DelItemDetailInfo:((MainViewController *)mainview).DeviceIP arg:[NSString stringWithFormat:@"%@%%~%%%@",arg,taskid]];
            
            
        });
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [mainview presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)clickselectall:(id)sender {
    [self willChangeValueForKey:@"IsAllSelect"];
    if (IsAllSelect)
    {
        IsAllSelect=NO;
        [btncheck setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    else
    {
        IsAllSelect=YES;
        [btncheck setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    [self didChangeValueForKey:@"IsAllSelect"];
}


#pragma mark table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!detaillist)
        return 0;
    return [detaillist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mediaCellEdit *me;
    NSDictionary *d = [detaillist objectAtIndex:indexPath.row];
    me= (mediaCellEdit *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
    
    if (!me){
        
        UINib *nib = [UINib nibWithNibName:@"mediainfoCellEdit" bundle:nil];
        [table registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
        me= (mediaCellEdit *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
        
        me.tdlv=self;
        me.medianame.text= [d objectForKey:@"medianame"];
        me.size.text= [d objectForKey:@"length"];
        me.mediaid=[d objectForKey:@"numseq"];
        [me initKVO:IsAllSelect];
        return me;
    }
    me.medianame.text= [d objectForKey:@"medianame"];
    me.size.text= [d objectForKey:@"length"];
    me.mediaid=[d objectForKey:@"numseq"];
    
    
    return me;
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
    v.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2f];
    cell.selectedBackgroundView = v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    mediaCellEdit *me;
    me = (mediaCellEdit *)[table cellForRowAtIndexPath:indexPath];
    [me changemark];
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
    if (refresh.refreshing)
    {
        [refresh endRefreshing];
    }
    if (commandtype == EGetAllItemByTask)
    {
        NSLog(@"获得数据");
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (success){
            detaillist = [json objectForKey:@"data"];
            [table reloadData];
        }
        else
            [self CommandTimeout];
        return;
    }
    if (commandtype==EDelTaskItem)
    {
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (success){
            [self willChangeValueForKey:@"IsAllSelect"];
            
            IsAllSelect=NO;
            [btncheck setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
            
            [self didChangeValueForKey:@"IsAllSelect"];
            [self willChangeValueForKey:@"IsClose"];
            IsClose=YES;
            [self didChangeValueForKey:@"IsClose"];
            
            [self loadtaskdetailinfo];
        }
        else
            [self CommandTimeout];
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


#pragma mark -


@end
