//
//  PLViewController.m
//  Remote
//
//  Created by 程嘉雯 on 16/2/22.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "PLViewController.h"
#import "mediaCellEdit.h"
#import "MainViewController.h"
#import <Common/PublicCommon.h>
#import "MediaData.h"

@interface PLViewController ()

@end

@implementation PLViewController
@synthesize table,footview,btnmarkall;
@synthesize mainview;
@synthesize IsAllSelect;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    IsAllSelect  = NO;
    [footview setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.15]];
    btnmove = [[UIButton alloc] init];
    btnmove.frame = CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width/2, footview.frame.size.height);
    [btnmove setImage:[UIImage imageNamed:@"img_edit_send"] forState:UIControlStateNormal];
    [btnmove setTitle:@"转移" forState:UIControlStateNormal];
    [btnmove setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnmove setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    btndel = [[UIButton alloc] init];
    btndel.frame = CGRectMake([PublicCommon GetALLScreen].size.width/2, 0, [PublicCommon GetALLScreen].size.width/2, footview.frame.size.height);
    [btndel setImage:[UIImage imageNamed:@"img_edit_delete"] forState:UIControlStateNormal];
    [btndel setTitle:@"删除" forState:UIControlStateNormal];
    [btndel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btndel setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    
    [btnmove addTarget:self action:@selector(clickmove) forControlEvents:UIControlEventTouchUpInside];
    [btndel addTarget:self action:@selector(clickdel) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:btnmove];
    [footview addSubview:btndel];
    
    
    table.delegate=self;
    table.dataSource = self;
    
    
}

#pragma mark table

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

                            
    return [((MainViewController*)mainview).MediaList count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    mediaCellEdit *me;
    MediaData *m;
    
    me= (mediaCellEdit *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];

    if (!me){

        UINib *nib = [UINib nibWithNibName:@"mediainfoCellEdit" bundle:nil];
        [table registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
        me= (mediaCellEdit *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
    }
    
    m = [((MainViewController *)mainview).MediaList objectAtIndex:indexPath.row];
    me.medianame.text= m.mediaName;
    me.size.text= m.Len;

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

}


#pragma mark -


#pragma mark 按钮操作
-(void)clickmove
{
    
}

-(void)clickdel
{
    
}
#pragma mark -

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

- (IBAction)clickmarkall:(id)sender {
    
    [self willChangeValueForKey:@"IsAllSelect"];
    if (IsAllSelect)
    {
        IsAllSelect=NO;
        [btnmarkall setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
    }
    else
    {
        IsAllSelect=YES;
        [btnmarkall setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    [self didChangeValueForKey:@"IsAllSelect"];
}

- (IBAction)clickreturn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
