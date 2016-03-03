//
//  tab2View.m
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "tab2View.h"
#import "LoadingView.h"
#import "MainViewController.h"

@interface tab2View ()
{
    DeviceNet *dnet;
    __block LoadingView *loadview;
}

@end

@implementation tab2View
@synthesize mainView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        [self initview];
    }
    return self;
}



//刷新类型
-(void)LoadTaskAll
{
    
    [tasklist removeAllObjects];
    [refresh beginRefreshing];
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        [dnet getAllTask:((MainViewController *)mainView).DeviceIP];
        
    });
    
    
}


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
    if (commandtype == EloadAllTask)
    {
        NSLog(@"获得数据");
 
        NSArray *list1 = [json objectForKey:@"data"];
        for (int i=0; i<[list1 count]; i++) {
            [tasklist addObject:list1[i]];
        }
        
       
        [table reloadData];
        return;
    }
    
    if (commandtype ==EdelTask)
    {
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (success){
            
            [tasklist removeObjectAtIndex:opindex.row];
            
            [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:opindex] withRowAnimation:UITableViewRowAnimationFade];
            opindex=nil;
        }
        else
            [self CommandTimeout];
        

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


-(void)initview
{
    
    btnAdd = [[UIButton alloc] init];
    btnAdd.frame = CGRectMake(30, 10, [PublicCommon GetALLScreen].size.width - 60, 40);
    [btnAdd setTitle:@"+新建任务" forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(clickaddTask) forControlEvents:UIControlEventTouchUpInside];
    btnAdd.layer.cornerRadius = 8;
    btnAdd.layer.masksToBounds=YES;
    UIImage *image1 = [PublicCommon createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:1.00]
                                            Rect:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width - 60, 40) ];

    UIImage *image2 = [PublicCommon createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:.5f]
                                            Rect:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width - 60, 40) ];

    [btnAdd setBackgroundImage:image1 forState:UIControlStateNormal];
    [btnAdd setBackgroundImage:image2 forState:UIControlStateHighlighted];
    
    
    
    [self addSubview:btnAdd];
    
    tasklist = [[NSMutableArray alloc] init];
    
    table = [[UITableView alloc] init];

    table.backgroundColor=[UIColor clearColor];
    table.separatorColor=[UIColor whiteColor];
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(changerefreshstate) forControlEvents:UIControlEventValueChanged];
    //    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"努力加载中……"];
    
    refresh.tintColor = [UIColor whiteColor];
    [table addSubview:refresh];
    
    table.frame = CGRectMake(0, 55,  [PublicCommon GetALLScreen].size.width, self.frame.size.height -55);
    table.delegate=self;
    table.dataSource=self;
    
    UINib *nib = [UINib nibWithNibName:@"taskcell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"taskcell"];
    [self addSubview:table];
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1;
    [table addGestureRecognizer:longPressGr];

}


-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:table];
        
        NSIndexPath * indexPath = [table indexPathForRowAtPoint:point];
        
        if(indexPath == nil) return ;
        
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"操作提示" message:@"请选择一项操作方式" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"修改任务" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray *nibarry = [[NSBundle mainBundle] loadNibNamed:@"newTaskView" owner:newtaskview options:nil];
            newtaskview = (NewTaskVIew *)nibarry[0];
            newtaskview.frame = mainView.view.frame;
            newtaskview.mainView= mainView;
            newtaskview.delegate=self;
            NSDictionary *d = [tasklist objectAtIndex:indexPath.row];
            [newtaskview SetEditMode:d];
            [mainView.view addSubview:newtaskview];
            
            
        }];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"删除任务" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            opindex =[indexPath copy];
            [self DelTask:(int)indexPath.row];

        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [alert addAction:action3];
        
        [mainView presentViewController:alert animated:YES completion:nil];
        

      
        
        
        
    }
}


-(void)DelTask:(int)index
{
    NSDictionary *d = [tasklist objectAtIndex:index];
   
    if (!loadview)
        loadview = [[LoadingView alloc] init];
    [mainView.view addSubview:loadview];
    [loadview StartAnimation];
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        [dnet DelTask:((MainViewController *)mainView).DeviceIP arg:[d objectForKey:@"billid"]];
        
    });
}

//点击添加任务
-(void)clickaddTask
{
    
    NSArray *nibarry = [[NSBundle mainBundle] loadNibNamed:@"newTaskView" owner:newtaskview options:nil];
    newtaskview = (NewTaskVIew *)nibarry[0];
    newtaskview.frame = mainView.view.frame;
    newtaskview.mainView= mainView;
    newtaskview.delegate=self;
    [mainView.view addSubview:newtaskview];
}

-(void)AddFinsih
{
    [self LoadTaskAll];
}

//开始刷新
-(void)changerefreshstate
{
    if (refresh.refreshing)
        [self LoadTaskAll];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tasklist count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskCell * cell = (TaskCell *)[table dequeueReusableCellWithIdentifier:@"taskcell"];

    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    NSDictionary *d = [tasklist objectAtIndex:indexPath.row];
        cell.taskname.text = [NSString stringWithFormat:@"%@",[d objectForKey:@"billname"]];

    cell.taskdate.text =     [NSString stringWithFormat:@"日期：%@ - %@",[d objectForKey:@"sdate"],[d objectForKey:@"edate"]];
    cell.tasktime.text = [NSString stringWithFormat:@"时间：%@ - %@",[d objectForKey:@"stime"],[d objectForKey:@"etime"]];
    if (((NSNumber *)[d objectForKey:@"isenable"]).intValue == 1)
        cell.taskstate.text = @"已启用";
    else
        cell.taskstate.text = @"未启用";

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
     NSDictionary *d = [tasklist objectAtIndex:indexPath.row];
    [((MainViewController *)mainView) ItemClick:[d objectForKey:@"billid"] taskname:[d objectForKey:@"billname"]];
}

//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
//           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath      //当在Cell上滑动时会调用此函数
//{
//    
//    return  UITableViewCellEditingStyleDelete;  //返回此值时,Cell会做出响应显示Delete按键,点击Delete后会调用下面的函数,别给传递UITableViewCellEditingStyleDelete参数
//    
//    //    else
//    //
//    //        return  UITableViewCellEditingStyleNone;   //返回此值时,Cell上不会出现Delete按键,即Cell不做任何响应
//    
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//  
//        
//     
//        
//       
//        // Delete the row from the data source.
//        [tasklist removeObjectAtIndex:indexPath.row];
//        
//        [table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//    }
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
