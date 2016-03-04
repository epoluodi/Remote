//
//  MainViewController.h
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tab1View.h"
#import "tab2View.h"
#import "tab3View.h"
#import "tab1Viewchild.h"
#import "SearchViewController.h"
#import "TipView.h"
#import <Common/PublicCommon.h>
#import "taskdetailview.h"


//播放模式
typedef enum:int{
    TASKMODE=1,//任务模式
    SELECTMODE,//选择模式
    PUBLICMODE,//宣传模式
    
} MediaModeEnum;


typedef enum:int{
    ORDER = 1,//顺序播放
    LOOP = 2, //列表循环播放
    REPEAT = 3,//单曲循环
    RANDOM = 4, //随机播放
} PlayModeEnum;

@class tab1View;
@interface MainViewController : UIViewController<UIScrollViewDelegate,tab1itemClick,clickdelegate,GCDAsyncUdpSocketDelegate,FinishCommanddelegate>
{
    UIButton *btnlibary;
    UIButton *btntask;
    UIButton *btnsetting;
    UIView *_lineview;
    UIScrollView *scrollview;
    
    tab1View *tab1;
    tab2View *tab2;
    tab3View *tab3;
    
    tab1Viewchild *t1viewchild;
    taskdetailview *taskdetail;
    
    BOOL IsConnected;
    CGFloat x1,x2;
    
    DeviceNet *dnet;
    DeviceNet *controlnet;
   
}





@property (weak, nonatomic) IBOutlet UIButton *btnsearch;
@property (weak, nonatomic) IBOutlet UIView *tabview;
@property (weak, nonatomic) IBOutlet UIView *controlview;
@property (weak, nonatomic) IBOutlet UIView *headview;


//设备信息
@property (strong,nonatomic)NSString *DeviceIP;
@property (strong,nonatomic)NSString *DeviceName;

//设备数据暂存
@property (copy,nonatomic)NSArray<NSString *> *ContentType;
@property (copy,nonatomic)NSArray<MediaData *> *MediaList;
@property (copy,nonatomic)NSMutableDictionary *dictMediaList;



//设备状态
@property (weak, nonatomic) IBOutlet UIProgressView *progressview;
@property (weak, nonatomic) IBOutlet UILabel *medianame;
@property (weak, nonatomic) IBOutlet UILabel *mediatime;
@property (weak, nonatomic) IBOutlet UIButton *mediamode;
@property (weak, nonatomic) IBOutlet UIButton *playmode;
@property (weak, nonatomic) IBOutlet UIButton *btnplay;
@property (weak, nonatomic) IBOutlet UIButton *btnup;
@property (weak, nonatomic) IBOutlet UIButton *btnnext;



- (IBAction)clickmediamode:(id)sender;
- (IBAction)clickplaymode:(id)sender;
- (IBAction)clickplay:(id)sender;
- (IBAction)clickprev:(id)sender;
- (IBAction)clicknext:(id)sender;






- (IBAction)clicksearch:(id)sender;

-(void)ConnectToDeviceInit;
-(void)Loadmedia;
-(NSString *)getNowt1Title;
-(void)ItemClick:(NSString *)taskid taskname:(NSString *)taskname;
@end
