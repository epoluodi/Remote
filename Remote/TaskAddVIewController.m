//
//  TaskAddVIewController.m
//  Remote
//
//  Created by 程嘉雯 on 16/3/6.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "TaskAddVIewController.h"
#import "LoadingView.h"
#import "mediaCellEdit.h"
#import <Common/PublicCommon.h>

@interface TaskAddVIewController ()
{
    DeviceNet *dnet;
    __block LoadingView *loadview;
}

@end

@implementation TaskAddVIewController
@synthesize mainview;
@synthesize taskid;
@synthesize table;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    dictMediaList = [[NSMutableDictionary alloc] init];
    headlist= [[NSMutableArray alloc] init];
    table.backgroundColor=[UIColor clearColor];
 
    
    for (int i=0; i<[((MainViewController *)mainview).ContentType count]; i++) {
        HeadVIew *v = [[HeadVIew alloc] init];
        v.mainview=mainview;
        v.tavc=self;
        v.intable=table;
        [v initUI:[PublicCommon GetALLScreen].size.width section:i];
        [headlist  addObject:v];
    }
    mediaindex=0;
    if (!loadview)
        loadview = [[LoadingView alloc] init];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    [self LoadMediaAll];
    // Do any additional setup after loading the view.
}


-(void)all:(int)section
{
        NSArray *a = [dictMediaList objectForKey:[mainview.ContentType objectAtIndex:section ]];
    HeadVIew *h=[headlist objectAtIndex:section];
    for (MediaData*m in a) {
        [h ChangeSelectList:m.mediaID flag:YES];
    }
    
}
-(void)LoadMediaAll
{

    
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        
   
           
        [dnet getMediaByType:((MainViewController *)mainview).DeviceIP arg:((MainViewController *)mainview).ContentType[mediaindex]];

     
        
    });
    
}



#pragma mark table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [mainview.ContentType count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *a = [dictMediaList objectForKey:[mainview.ContentType objectAtIndex:section ]];
    
    ((HeadVIew *)[headlist objectAtIndex:section]).incount = [a count];
    
    return [a count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{



    return [headlist objectAtIndex:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mediaCellEdit *me;
    NSArray *a = [dictMediaList objectForKey:[mainview.ContentType objectAtIndex:indexPath.section ]];
    
    
    MediaData *m = [a objectAtIndex:indexPath.row];
    
    
    
    me= (mediaCellEdit *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d%d_m",indexPath.row,indexPath.section]];
    
    if (!me){
        
        UINib *nib = [UINib nibWithNibName:@"mediainfoCellEdit" bundle:nil];
        [table registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%d%d_m",indexPath.row,indexPath.section]];
        me= (mediaCellEdit *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d%d_m",indexPath.row,indexPath.section]];
        
        
        me.medianame.text= m.mediaName;
        me.size.text= m.Len;
        me.mediaid=m.mediaID;
        HeadVIew *v = headlist[indexPath.section];
        me.hv=v;
        [me initKVO:v.IsAllSelect];
        return me;
    }
    me.medianame.text= m.mediaName;
    me.size.text= m.Len;
    me.mediaid=m.mediaID;
    
    
    return me;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
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
    
 
    if (commandtype == EloadMediaByType)
    {
        dnet.Commanddelegate=nil;
        dnet=nil;
        NSLog(@"获得数据");
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (!success){
            [self CommandTimeout];
            return;
        }
        
        NSMutableArray *contentstr = [[NSMutableArray alloc] init];
        NSArray *list1 = [json objectForKey:@"data"];
        NSDictionary *d;
        for (int i=0; i<[list1 count]; i++) {
            d = list1[i];
            MediaData *md = [[MediaData alloc] init];
            md.mediaName = [d objectForKey:@"medianame"];
            md.mediaID = [d objectForKey:@"mediaid"];
            md.mediaType =[d objectForKey:@"mediatype"];
            md.Len =[d objectForKey:@"length"];
            md.source =[d objectForKey:@"source"];
            [contentstr addObject:md];
        }
        
        [dictMediaList setObject:contentstr forKey:(d)?[d objectForKey:@"contenttype"]:@""];
        mediaindex++;
        if (mediaindex < [((MainViewController *)mainview).ContentType count])
        {
            [self LoadMediaAll];
            
        }
        else
        {
            if (loadview){
                [loadview StopAnimation];
                [loadview removeFromSuperview];
                loadview = nil;
            }
            table.delegate=self;
            table.dataSource=self;
            [table reloadData];
        }
       
        return;
    }
    if (commandtype == EAddtoTask)
    {
        NSLog(@"获得数据");
        if (loadview){
            [loadview StopAnimation];
            [loadview removeFromSuperview];
            loadview = nil;
        }
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (success){
            
            [mainview reloadTaskdetail];
            [self clickreturn:nil];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误，请重新尝试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


#pragma mark -



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

- (IBAction)clickreturn:(id)sender {
    
    for (HeadVIew *v in headlist) {
        [v closeview];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickaddok:(id)sender {
    
    NSMutableString *mstr = [[NSMutableString alloc] init];
    for (HeadVIew *v in headlist) {
        [mstr appendString:[v getListForStr]];
        [mstr appendString:@","];
        
    }
    NSString * arg = [NSString stringWithFormat:@"%@%%~%%%@",mstr,taskid];
    
    
    if (!loadview)
        loadview = [[LoadingView alloc] init];
    [self.view addSubview:loadview];
    [loadview StartAnimation];
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{

        [dnet AddTaskwithMedia:((MainViewController *)mainview).DeviceIP arg:arg];

    });
    
}
@end


@implementation HeadVIew
@synthesize IsAllSelect,IsClose;
@synthesize mainview;
@synthesize intable,incount;

-(void)initUI:(float)width section:(int)section
{
    itemindex = section;

    self.frame = CGRectMake(0, 0, width, 50);
    UILabel *lab = [[UILabel alloc] init];
    lab.textColor=[[UIColor whiteColor] colorWithAlphaComponent:0.5];
    lab.text =[mainview.ContentType objectAtIndex:section ];
    
    CGSize size= [lab.text sizeWithFont:lab.font];
    lab.frame = CGRectMake(10, (50- size.height) /2, size.width, size.height);
    
    
    btnchk = [[UIButton alloc] init];
    [btnchk setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    
    btnchk.frame = CGRectMake(width -10-30, (50 -30 ) /2, 30, 30);
    [btnchk addTarget:self action:@selector(clickmarkall:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnchk];
    
    [self addSubview:lab];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    selectmediaID = [[NSMutableArray alloc] init];
    return;
}


- (IBAction)clickmarkall:(id)sender {

    [self willChangeValueForKey:@"IsAllSelect"];
    if (IsAllSelect)
    {
        IsAllSelect=NO;
        [btnchk setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    else
    {
        if (incount ==0)
            return;
        [intable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:incount -1 inSection:itemindex] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [_tavc all:itemindex];
        
        IsAllSelect=YES;
        [btnchk setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    [self didChangeValueForKey:@"IsAllSelect"];
}

-(void)ChangeSelectList:(NSString *)mediaid flag:(BOOL)flag
{
    if (flag){
        if (![selectmediaID containsObject:mediaid])
            [selectmediaID addObject:mediaid];
}
    else{
        [selectmediaID removeObject:mediaid];
        IsAllSelect=NO;
        [btnchk setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
}
-(void)closeview
{
    [self willChangeValueForKey:@"IsClose"];
    IsClose=YES;
    [self didChangeValueForKey:@"IsClose"];
}

-(NSString *)getListForStr
{
    return [selectmediaID componentsJoinedByString:@","];
}
@end