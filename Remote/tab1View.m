//
//  tab1View.m
//  Remote
//
//  Created by Stereo on 16/1/25.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

//tab1 界面

#import "tab1View.h"

@implementation tab1View
@synthesize delegate;



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



//开始刷新
-(void)changerefreshstate
{
    if (refresh.refreshing)
    {
        sleep(2);
        [refresh endRefreshing];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
