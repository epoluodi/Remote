//
//  MainViewController.m
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "MainViewController.h"
#import <Common/PublicCommon.h>

#define tabwidth [PublicCommon GetALLScreen].size.width /3

#define scrollY 106
#define scrollheight [PublicCommon GetALLScreen].size.height -scrollY-66

@interface MainViewController ()
{
    BOOL iscroll;
}
@end

@implementation MainViewController
@synthesize btnsearch;
@synthesize tabview,controlview;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self inittabview];
    
    // Do any additional setup after loading the view.
    
    [btnlibary setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    
    
    scrollview = [[UIScrollView alloc] init];
    scrollview.frame = CGRectMake(0, scrollY, [PublicCommon GetALLScreen].size.width, scrollheight+20);
    //    scrollview.backgroundColor=[UIColor greenColor];
    [self.view addSubview:scrollview];
    scrollview.delegate = self;
    iscroll =NO;
    [self initscrollview];
    
}

-(void)initscrollview
{
    scrollview.contentSize = CGSizeMake([PublicCommon GetALLScreen].size.width*3 , 0);
    scrollview.bounces=YES;
    scrollview.pagingEnabled=YES;
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.userInteractionEnabled=YES;
    
    
    tab1= [[tab1View alloc] init];
    UITableView *table = [tab1 tableinit:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width, scrollheight+20)];
    
   
    [scrollview addSubview:table];
    
    UIView *v2 = [[UIView alloc] init];
    v2.frame = CGRectMake([PublicCommon GetALLScreen].size.width, 0, [PublicCommon GetALLScreen].size.width, scrollheight+20);
    v2.backgroundColor = [UIColor yellowColor];
    [scrollview addSubview:v2];
    
    UIView *v3 = [[UIView alloc] init];
    v3.frame = CGRectMake([PublicCommon GetALLScreen].size.width *2, 0, [PublicCommon GetALLScreen].size.width, scrollheight+20);
    v3.backgroundColor = [UIColor greenColor];
    [scrollview addSubview:v3];
}


// 线动画
-(void)lineAnimation:(int)x
{
    [UIView beginAnimations:@"line" context:nil];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    _lineview.frame = CGRectMake(x*tabwidth, 40-3, tabwidth, 3);
    [UIView commitAnimations];
    
}


//初始化tabview
-(void)inittabview
{
    btnlibary = [[UIButton alloc] init];
    [btnlibary setTitle:@"曲库" forState:UIControlStateNormal];
    [btnlibary setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    btnlibary.frame = CGRectMake(0, 0, tabwidth, 40);
    [btnlibary addTarget:self action:@selector(clicklibary) forControlEvents:UIControlEventTouchUpInside];
    [tabview addSubview:btnlibary];
    
    btntask = [[UIButton alloc] init];
    [btntask setTitle:@"任务单" forState:UIControlStateNormal];
    [btntask setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    btntask.frame = CGRectMake(tabwidth, 0, tabwidth, 40);
    [btntask addTarget:self action:@selector(clicktask) forControlEvents:UIControlEventTouchUpInside];
    [tabview addSubview:btntask];
    
    btnsetting = [[UIButton alloc] init];
    [btnsetting setTitle:@"设置" forState:UIControlStateNormal];
    [btnsetting setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    btnsetting.frame = CGRectMake(tabwidth*2, 0, tabwidth, 40);
    [btnsetting addTarget:self action:@selector(clicksetting) forControlEvents:UIControlEventTouchUpInside];
    [tabview addSubview:btnsetting];
    
    
    _lineview = [[UIView alloc] init];
    _lineview.frame = CGRectMake(0, 40-3, tabwidth, 3);
    _lineview.backgroundColor = [UIColor yellowColor];
    [tabview addSubview:_lineview];
    
}



-(void)clicklibary
{
    [self lineAnimation:0];
    [btnlibary setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [btntask setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [btnsetting setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    iscroll = YES;
    [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)clicktask
{
    [self lineAnimation:1];
    [btntask setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [btnlibary setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [btnsetting setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    iscroll = YES;
    [scrollview setContentOffset:CGPointMake([PublicCommon GetALLScreen].size.width, 0) animated:YES];
}

-(void)clicksetting
{
    [self lineAnimation:2];
    [btnsetting setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [btnlibary setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    [btntask setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
    iscroll = YES;
    [scrollview setContentOffset:CGPointMake([PublicCommon GetALLScreen].size.width *2, 0) animated:YES];
}



#pragma marker 滚动事件



-(void)scrollViewDidScroll:(UIScrollView *)scrollView   {
    if (iscroll)
        return;
    //正在拖拽
    if (scrollview.contentOffset.x < 0 ||
        scrollView.contentOffset.x>828)
        return;
    _lineview.frame = CGRectMake(scrollView.contentOffset.x /3, 40-3, tabwidth, 3);
    if (scrollview.contentOffset.x==0)
    {
        [btnlibary setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [btntask setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        [btnsetting setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        return;
    }
    if (scrollview.contentOffset.x==414)
    {
        [btntask setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [btnlibary setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        [btnsetting setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        return;
    }
    if (scrollview.contentOffset.x==828)
    {
        [btnsetting setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [btnlibary setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        [btntask setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        return;
    }
    
    
}




-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    iscroll=NO;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    iscroll=NO;
    
    
    
}


#pragma marker -
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

- (IBAction)clicksearch:(id)sender {
    [self performSegueWithIdentifier:@"showsearch" sender:self];
    
}
@end
