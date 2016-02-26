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
#import "LoadingView.h"

@interface PLViewController ()
{
    DeviceNet *dnet;
    __block LoadingView *loadview;
}
@end

@implementation PLViewController
@synthesize table,footview,btnmarkall;
@synthesize mainview;
@synthesize IsAllSelect,IsClose;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    IsAllSelect  = NO;
    IsClose = NO;
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
    [btndel setTitle:@"移除" forState:UIControlStateNormal];
    [btndel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btndel setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    
    [btnmove addTarget:self action:@selector(clickmove) forControlEvents:UIControlEventTouchUpInside];
    [btndel addTarget:self action:@selector(clickdel) forControlEvents:UIControlEventTouchUpInside];
    
    [footview addSubview:btnmove];
    [footview addSubview:btndel];
    

    selectmediaID= [[NSMutableArray alloc] init];
    
    
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
    MediaData *m = [((MainViewController *)mainview).MediaList objectAtIndex:indexPath.row];
    me= (mediaCellEdit *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];

    if (!me){

        UINib *nib = [UINib nibWithNibName:@"mediainfoCellEdit" bundle:nil];
        [table registerNib:nib forCellReuseIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
        me= (mediaCellEdit *)[table dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%d_m",indexPath.row]];
        me.plv=self;
        
        me.medianame.text= m.mediaName;
        me.size.text= m.Len;
        me.mediaid=m.mediaID;
        [me initKVO:IsAllSelect];
        return me;
    }
    me.medianame.text= m.mediaName;
    me.size.text= m.Len;
    me.mediaid=m.mediaID;
    
    
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


-(void)ChangeSelectList:(NSString *)mediaid flag:(BOOL)flag
{
    if (flag)
        [selectmediaID addObject:mediaid];
    else
        [selectmediaID removeObject:mediaid];
}

#pragma mark 按钮操作
-(void)clickmove
{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"选择一个项目",(int)selectmediaID.count] preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (__block int i=0; i<((MainViewController *)mainview).ContentType.count; i++) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:((MainViewController *)mainview).ContentType[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *arg  = [selectmediaID componentsJoinedByString:@","];
            NSString *str = [NSString stringWithFormat:@"%@%%~%%%@",arg,action.title];
            if (!loadview)
                loadview = [[LoadingView alloc] init];
            [self.view addSubview:loadview];
            [loadview StartAnimation];
            
            dnet = [[DeviceNet alloc] init];
            dnet.Commanddelegate=self;
            dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(globalQ , ^{
                
                [dnet ConvertType:((MainViewController *)mainview).DeviceIP arg:str];
                
                
            });

        }];
        [alert addAction:action];
    }
       UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:nil];
}

-(void)clickdel
{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确认移除 %d条文件",(int)selectmediaID.count] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *arg  = [selectmediaID componentsJoinedByString:@","];
        if (!loadview)
            loadview = [[LoadingView alloc] init];
        [self.view addSubview:loadview];
        [loadview StartAnimation];
        
        dnet = [[DeviceNet alloc] init];
        dnet.Commanddelegate=self;
        dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQ , ^{
            
            [dnet DelMedia:((MainViewController *)mainview).DeviceIP arg:arg];
            
            
        });

    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}





#pragma mark -



#pragma mark 通信操作委托
-(void)CommandFinish:(CommandType)commandtype json:(NSDictionary *)json
{

    
    
    if (commandtype == EDelMedia || commandtype == EConvertType)
    {
        NSLog(@"获得数据");
        
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (success){
            [((MainViewController *)mainview) Loadmedia];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (loadview){
                    [loadview StopAnimation];
                    [loadview removeFromSuperview];
                    loadview = nil;
                }
                [self willChangeValueForKey:@"IsClose"];
                IsClose=YES;
                [self didChangeValueForKey:@"IsClose"];
                [table reloadData];
            });
            
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
    
    
    [self willChangeValueForKey:@"IsClose"];
    IsClose=YES;
    [self didChangeValueForKey:@"IsClose"];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
