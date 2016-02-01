//
//  tab1Viewchild.m
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "tab1Viewchild.h"
#import "MainViewController.h"

@implementation tab1Viewchild
@synthesize btnback,btnedit,title,table;
@synthesize delegate;
@synthesize mainview;


-(void)awakeFromNib
{
    [btnback addTarget:self action:@selector(clickbtnback) forControlEvents:UIControlEventTouchUpInside];
    title.textColor=[UIColor whiteColor];
    
    table.backgroundColor = [UIColor clearColor];
    table.delegate=self;
    table.dataSource=self;
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(changerefreshstate) forControlEvents:UIControlEventValueChanged];
    UINib *nib = [UINib nibWithNibName:@"mediainfoCell" bundle:nil];
    [table addSubview:refresh];
    [table registerNib:nib forCellReuseIdentifier:@"mediainfoCell"];
}

-(void)loadmedia
{
    [refresh beginRefreshing];
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        [dnet getMediaByType:((MainViewController *)mainview).DeviceIP arg:title.text];
        
    });
    
    

    
}


#pragma mark 通信操作委托
-(void)CommandFinish:(CommandType)commandtype json:(NSDictionary *)json
{

    if (refresh.refreshing)
    {
        [refresh endRefreshing];
    }
    if (commandtype == EloadMediaByType)
    {
        NSLog(@"获得数据");
        NSMutableArray *contentstr = [[NSMutableArray alloc] init];
        NSArray *list1 = [json objectForKey:@"data"];
        for (int i=0; i<[list1 count]; i++) {
            NSDictionary *d = list1[i];
            MediaData *md = [[MediaData alloc] init];
            md.mediaName = [d objectForKey:@"medianame"];
            md.mediaID = [d objectForKey:@"mediaid"];
            md.mediaType =[d objectForKey:@"mediatype"];
            md.Len =[d objectForKey:@"length"];
            md.source =[d objectForKey:@"source"];
            [contentstr addObject:md];
        }
        
        ((MainViewController *)mainview).MediaList = [contentstr copy];
        [table reloadData];
        return;
    }
}
-(void)CommandTimeout
{

    if (refresh.refreshing)
    {
        [refresh endRefreshing];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误，请重新尝试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


#pragma mark -

//开始刷新
-(void)changerefreshstate
{
    if (refresh.refreshing)
        [self loadmedia];
}
#pragma marker table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (((MainViewController*)mainview).MediaList)
        return [((MainViewController*)mainview).MediaList count];
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaInfoCell * cell = [table dequeueReusableCellWithIdentifier:@"mediainfoCell"];
    MediaData *md = [((MainViewController*)mainview).MediaList objectAtIndex:indexPath.row];
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    cell.medianame.text= md.mediaName;
    cell.len.text = md.Len;
    if ([md.mediaType isEqualToString:@"1"])
        cell.imgtype.image = [UIImage imageNamed:@"img_yy"];
    else
        cell.imgtype.image = [UIImage imageNamed:@"img_sp"];
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
    v.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    cell.selectedBackgroundView = v;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
#pragma marker -

-(void)clickbtnback
{
    [delegate Clickback];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
