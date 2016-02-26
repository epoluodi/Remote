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



@class tab1View;
@interface MainViewController : UIViewController<UIScrollViewDelegate,tab1itemClick,clickdelegate>
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
    
    BOOL IsConnected;
    
    
    
    
   
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
- (IBAction)clicksearch:(id)sender;

-(void)ConnectToDeviceInit;
-(void)Loadmedia;


@end
