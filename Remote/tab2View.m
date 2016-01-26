//
//  tab2View.m
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "tab2View.h"

@implementation tab2View


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame=frame;
        [self initview];
    }
    return self;
}

- (UIImage*) createImageWithColor: (UIColor*) color Rect:(CGRect) rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
-(void)initview
{
    
    btnAdd = [[UIButton alloc] init];
    btnAdd.frame = CGRectMake(30, 10, [PublicCommon GetALLScreen].size.width - 60, 40);
    [btnAdd setTitle:@"+新建任务" forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(clickaddTask) forControlEvents:UIControlEventTouchUpInside];
    btnAdd.layer.cornerRadius = 8;
    btnAdd.layer.masksToBounds=YES;
    UIImage *image1 = [self createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:1.00]
                                            Rect:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width - 60, 40) ];

    UIImage *image2 = [self createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:.5f]
                                            Rect:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width - 60, 40) ];

    [btnAdd setBackgroundImage:image1 forState:UIControlStateNormal];
    [btnAdd setBackgroundImage:image2 forState:UIControlStateHighlighted];
    
    
    
    [self addSubview:btnAdd];
    
    
    
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
}



//点击添加任务
-(void)clickaddTask
{
    
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
    TaskCell * cell = (TaskCell *)[table dequeueReusableCellWithIdentifier:@"taskcell"];
    cell.taskname.text = [NSString stringWithFormat:@"编号：00%ld",(long)indexPath.row];
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4f];
    cell.taskdate.text = @"日期：2016年1月20日 - 2016年3月30日";
    cell.tasktime.text = @"时间：14:00 - 16:00";
    cell.taskstate.text = @"已启用";

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
    v.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3f];
    cell.selectedBackgroundView = v;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
