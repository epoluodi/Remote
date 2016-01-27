//
//  tab1Viewchild.m
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "tab1Viewchild.h"

@implementation tab1Viewchild
@synthesize btnback,btnedit,title,table;
@synthesize delegate;


-(void)awakeFromNib
{
    [btnback addTarget:self action:@selector(clickbtnback) forControlEvents:UIControlEventTouchUpInside];
    title.textColor=[UIColor whiteColor];
    
    
}

-(void)loadmedia:(NSArray<MediaData *> *)arry
{
    mediaarray = arry;
    table.backgroundColor = [UIColor clearColor];
    table.delegate=self;
    table.dataSource=self;
    refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self action:@selector(changerefreshstate) forControlEvents:UIControlEventValueChanged];
    UINib *nib = [UINib nibWithNibName:@"mediainfoCell" bundle:nil];
    [table registerNib:nib forCellReuseIdentifier:@"mediainfoCell"];
    
}

//开始刷新
-(void)changerefreshstate
{
    if (refresh.refreshing)
    {
        sleep(2);
        [refresh endRefreshing];
    }
}
#pragma marker table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mediaarray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaInfoCell * cell = [table dequeueReusableCellWithIdentifier:@"mediainfoCell"];
    MediaData *md = [mediaarray objectAtIndex:indexPath.row];
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
