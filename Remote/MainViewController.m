//
//  MainViewController.m
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "MainViewController.h"
#import <Common/PublicCommon.h>
#import "PLViewController.h"
#import "ScanFileController.h"
#import "AppDelegate.h"
#import "TaskAddVIewController.h"

#define tabwidth [PublicCommon GetALLScreen].size.width /3

#define scrollY 106
#define scrollheight [PublicCommon GetALLScreen].size.height -scrollY-66

@interface MainViewController ()
{
    BOOL iscroll;
    AppDelegate *app;
}
@end

@implementation MainViewController
@synthesize btnsearch;
@synthesize tabview,controlview;
@synthesize headview;
@synthesize DeviceIP,DeviceName;
@synthesize MediaList,ContentType;
@synthesize btnnext,btnplay,btnup;
@synthesize mediamode,medianame,mediatime;
@synthesize playmode,progressview;




- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (iPhone6){
        x1=375;
        x2=750;
    }
    if (iPhone6plus){
        x1 = 414;
        x2= 828;
    }
    
    app= (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [app addObserver:self forKeyPath:@"IsRun" options:NSKeyValueObservingOptionNew context:NULL];
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
    
    IsConnected = NO;
    
    
    //开始后，首先运行搜索
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self clicksearch:nil];
    });
    
    IsPlay = NO;
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(progressPanGesture:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(progresstap:)];
    [progressview addGestureRecognizer:pangesture];
    [progressview addGestureRecognizer:tap];
    progressview.userInteractionEnabled=YES;
    //增加监听 音量按键
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                            selector:@selector(changeVolumeKey:)
//                    name:@"AVSystemController_AudioVolumeNotificationParameter"
//                                               object:nil];
    
}

-(void)progresstap:(UITapGestureRecognizer *)sender
{
    if (!IsPlay)
        return;
    CGPoint pt = [sender  locationInView:progressview];
    float p = (pt.x / x1) * 100;
    
    if (sender.state ==UIGestureRecognizerStateEnded)
    {
        [self setPlaySkip:(int)p];
    }
   
}
- (void)progressPanGesture:(UIPanGestureRecognizer *)sender
{
    
    if (!IsPlay)
        return;
    CGPoint pt = [sender locationInView:progressview];
    float p = (pt.x / x1) * 100;
     NSLog(@"%f",p);
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        progressview.progress = p /100;
    }

    if (sender.state ==UIGestureRecognizerStateEnded)
    {
        [self setPlaySkip:(int)p];
    }
   
    

    

}

//-(void)dealloc
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"AVSystemController_AudioVolumeNotificationParameter"];
//}


-(void)initscrollview
{
    scrollview.contentSize = CGSizeMake([PublicCommon GetALLScreen].size.width*3 , 0);
    scrollview.bounces=YES;
    scrollview.pagingEnabled=YES;
    scrollview.showsHorizontalScrollIndicator=NO;
    scrollview.showsVerticalScrollIndicator=NO;
    scrollview.userInteractionEnabled=YES;
    
    //tab1
    tab1= [[tab1View alloc] init];
    UITableView *table = [tab1 tableinit:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width, scrollheight+20)];
    tab1.delegate = self;
    tab1.mainview=self;
    [scrollview addSubview:table];
    
    
    //tab2
    tab2 = [[tab2View alloc] initWithFrame:CGRectMake([PublicCommon GetALLScreen].size.width , 0, [PublicCommon GetALLScreen].size.width, scrollheight+20)];
    tab2.mainView=self;
    [scrollview addSubview:tab2];
    
    
    NSArray *nibarry = [[NSBundle mainBundle] loadNibNamed:@"tab3View" owner:tab3 options:nil];
    tab3 = (tab3View *)nibarry[0];
    tab3.frame =CGRectMake([PublicCommon GetALLScreen].size.width*2 , 0, [PublicCommon GetALLScreen].size.width, scrollheight+20);
    tab3.mainview=self;
    
    [scrollview addSubview:tab3];
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

#pragma mark tab1itemclick

-(void)ItemClick:(NSString *)itemname
{
    [self HideView];
    NSArray *nibarry = [[NSBundle mainBundle] loadNibNamed:@"tab1viewchild" owner:t1viewchild options:nil];
    t1viewchild = (tab1Viewchild *)nibarry[0];
    t1viewchild.frame =CGRectMake(0 , 0, [PublicCommon GetALLScreen].size.width, [PublicCommon GetALLScreen].size.height-66 +20);
    t1viewchild.delegate = self;
    t1viewchild.title.text= itemname;
    t1viewchild.mainview=self;
    [t1viewchild loadmedia];
    
    [self.view addSubview:t1viewchild];
    
}

-(void)ItemClick:(NSString *)taskid taskname:(NSString *)taskname
{
    [self HideView];
    NSArray *nibarry = [[NSBundle mainBundle] loadNibNamed:@"taskview" owner:taskdetail options:nil];
    taskdetail = (taskdetailview *)nibarry[0];
    taskdetail.frame =CGRectMake(0 , 0, [PublicCommon GetALLScreen].size.width, [PublicCommon GetALLScreen].size.height-66 +20);
    taskdetail.delegate = self;
    taskdetail.title.text= taskname;
    taskdetail.mainview=self;
    taskdetail.taskid =taskid;
    [taskdetail loadtaskdetailinfo];
    
    [self.view addSubview:taskdetail];
}



-(NSString *)getNowt1Title
{
    return  t1viewchild.title.text;
}
-(void)Loadmedia
{
    [t1viewchild loadmedia];
}

-(void)reloadTaskdetail
{
    [taskdetail loadtaskdetailinfo];
}
#pragma mark -





#pragma mark clickdelegate

-(void)Clickback
{
    t1viewchild.delegate=nil;
    [t1viewchild removeFromSuperview];
    t1viewchild=nil;
    [self ShowView];
}

-(void)Clickbackfortaskdetail
{
    taskdetail.delegate=nil;
    [taskdetail removeFromSuperview];
    taskdetail=nil;
    [self ShowView];
}

-(void)itemclickplay:(NSString *)mediaId
{
    controlnet = [[DeviceNet alloc] init];
    controlnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        
        [dnet setPlayMedia:self.DeviceIP arg:mediaId];
        
        
    });
}

#pragma mark -



#pragma mark 切换view

-(void)HideView
{
    headview.hidden=YES;
    tabview.hidden=YES;
    scrollview.hidden=YES;
}

-(void)ShowView
{
    headview.hidden=NO;
    tabview.hidden=NO;
    scrollview.hidden=NO;
}

#pragma mark -


#pragma mark 滚动事件



-(void)scrollViewDidScroll:(UIScrollView *)scrollView   {
    if (iscroll)
        return;
    //正在拖拽
    if (scrollview.contentOffset.x < 0 ||
        scrollView.contentOffset.x>828)
        return;
    _lineview.frame = CGRectMake(scrollView.contentOffset.x /3, 40-3, tabwidth, 3);
    NSLog(@"x:%f",scrollView.contentOffset.x);
    
   

    
    if (scrollview.contentOffset.x==0)
    {
        [btnlibary setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [btntask setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        [btnsetting setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        return;
    }
    
    if (scrollview.contentOffset.x==x1)//375 750
    {
        [btntask setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
        [btnlibary setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        [btnsetting setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        return;
    }
    if (scrollview.contentOffset.x==x2)
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


#pragma mark -




-(void)changeVolumeKey:(NSNotification *)not
{
    
    float volume =
    [[[not userInfo]
      objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
     floatValue];
    NSLog(@"volumn is %f", volume);
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     if ([segue.identifier isEqualToString:@"showPL"])
//     {
//         
//     }
// }


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showsearch"])
    {
        SearchViewController *s = (SearchViewController*)segue.destinationViewController;
        s.IsHidereturn=IsConnected;
        s.mainview = self;
        return;
    }
    if ([segue.identifier isEqualToString:@"showPL"])
    {
        PLViewController *pl = (PLViewController*)segue.destinationViewController;
      
        pl.mainview = self;
        return;
    }
    if ([segue.identifier isEqualToString:@"showscanfile"])
    {
        ScanFileController *sf = (ScanFileController*)segue.destinationViewController;
        
        sf.mainview = self;
        
        if (scrollview.contentOffset.x == x2)
            sf.flag=YES;
        else
            sf.flag=NO;
        
        return;
    }
    if ([segue.identifier isEqualToString:@"showtaskadd"])
    {
        TaskAddVIewController *tdvc = (TaskAddVIewController*)segue.destinationViewController;
        
        tdvc.mainview = self;
        tdvc.taskid = taskdetail.taskid;

        
        return;
    }
    
    
}


- (IBAction)clickmediamode:(id)sender {
    controlnet = [[DeviceNet alloc] init];
    controlnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        
        [dnet setPlayMode:self.DeviceIP];
        
        
    });
}

- (IBAction)clickplaymode:(id)sender {
    controlnet = [[DeviceNet alloc] init];
    controlnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        
        [dnet setPlayOrder:self.DeviceIP];
        
        
    });
}

- (IBAction)clickplay:(id)sender {
    controlnet = [[DeviceNet alloc] init];
    controlnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        
        [dnet setPlayOrStop:self.DeviceIP];
        
        
    });
    
}

- (IBAction)clickprev:(id)sender {
    controlnet = [[DeviceNet alloc] init];
    controlnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        
        [dnet setPlaypro:self.DeviceIP];
        
        
    });
}

- (IBAction)clicknext:(id)sender {
    controlnet = [[DeviceNet alloc] init];
    controlnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        
        [dnet setPlaynext:self.DeviceIP];
        
        
    });
}

-(void)setPlaySkip:(int)time
{
        controlnet = [[DeviceNet alloc] init];
        controlnet.Commanddelegate=self;
        dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(globalQ , ^{
    
            [dnet setSkipTime:self.DeviceIP arg:[NSString stringWithFormat:@"%d",time]];
    
    
        });
}

- (IBAction)clicksearch:(id)sender {
    [dnet stoptListenserver];
    dnet=nil;
    
    [self performSegueWithIdentifier:@"showsearch" sender:self];
    
}


#pragma mark 通信操作委托
-(void)CommandFinish:(CommandType)commandtype json:(NSDictionary *)json
{
    
    
    
    if (commandtype == EPlayMode ||
        commandtype == EPlayOrder ||
        commandtype ==EPlayMedia ||
        commandtype ==EPlayOrStop ||
        commandtype ==EPlaypro ||
        commandtype ==EPlaynext ||
        commandtype == ESkipTime
        )
    {
        NSLog(@"获得数据");
        
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (!success){
            [self CommandTimeout];
            
        }

        return;
    }
    
    
    
    
}
-(void)CommandTimeout
{
    

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误，请重新尝试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


#pragma mark -




#pragma mark 连接设备获取信息

-(void)ConnectToDeviceInit
{
    //连接到设备
    IsConnected=YES;
    [self clicklibary];
    
    NSLog(@"设备IP %@",DeviceIP);
    NSLog(@"设备名称 %@",DeviceName);
    
    [tab1 LoadContentType];
    [tab2 LoadTaskAll];
    
    //启动监听状态
    
    dnet = [[DeviceNet alloc] init];
    [dnet initdelegate:self];
    [dnet startListenserver];
    
}

#pragma mark -



#pragma mark 处理监控信息

-(void)DoDeviceState:(NSString *)msg
{
    NSArray<NSString *> *strlist = [msg componentsSeparatedByString:@","];

    NSString *_length= strlist[0];
    NSString *_time = strlist[1];
    NSString *_percent = strlist[2];
    NSString *_medianame = strlist[3];
    NSString *_playorder = strlist[4];
    NSString *_playstate = strlist[5];
    NSString *_playmode = strlist[6];
    
    mediatime.text=_medianame;
    progressview.progress = [_percent floatValue] / 100;
    mediatime.text =[NSString stringWithFormat:@"%@/%@",_time,_length];
    medianame.text=_medianame;
    switch ([_playmode intValue]) {
        case TASKMODE:
            [mediamode setTitle:@"任务模式" forState:UIControlStateNormal];
            break;
        case SELECTMODE:
            [mediamode setTitle:@"自择模式" forState:UIControlStateNormal];
            break;
        case PUBLICMODE:
            [mediamode setTitle:@"宣传模式" forState:UIControlStateNormal];
            break;
    }
    
    
    switch ([_playorder intValue]) {
        case ORDER:
            [playmode setImage:[UIImage imageNamed:@"img_playmode_normal"] forState:UIControlStateNormal];
            break;
        case LOOP:
            [playmode setImage:[UIImage imageNamed:@"img_playmode_repeat_all"] forState:UIControlStateNormal];
            break;
        case REPEAT:
            [playmode setImage:[UIImage imageNamed:@"img_playmode_repeat_current"] forState:UIControlStateNormal];
            break;
        case RANDOM:
            [playmode setImage:[UIImage imageNamed:@"img_playmode_shuffle"] forState:UIControlStateNormal];
            break;
    }
    
    
    if ([_playstate isEqualToString:@"true"]){
        IsPlay=YES;
        [btnplay setImage:[UIImage imageNamed:@"img_pause_normal"] forState:UIControlStateNormal];
        [btnplay setImage:[UIImage imageNamed:@"img_pause_pressed"] forState:UIControlStateHighlighted];
    }
    else{
        IsPlay=NO;
        [btnplay setImage:[UIImage imageNamed:@"img_play_normal"] forState:UIControlStateNormal];
        [btnplay setImage:[UIImage imageNamed:@"img_play_pressed"] forState:UIControlStateHighlighted];
    }

    
}


#pragma mark -


#pragma mark UDP



-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{

//    NSLog(@"来自数据--%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    [self DoDeviceState:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]];
    
    

}



#pragma mark -


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"IsRun"])
    {
        if (((NSNumber *)[change objectForKey:@"new"]).intValue==0)
        {
            [dnet stoptListenserver];
            dnet = nil;
            return;
        }
        if (((NSNumber *)[change objectForKey:@"new"]).intValue==1)
        {
            dnet = [[DeviceNet alloc] init];
            [dnet initdelegate:self];
            [dnet startListenserver];
            return;
        }
    }
}
-(void)dealloc
{
    [app removeObserver:self forKeyPath:@"IsRun"];
    [dnet stoptListenserver];
    dnet = nil;
}
@end
