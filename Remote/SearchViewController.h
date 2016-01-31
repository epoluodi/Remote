//
//  SearchViewController.h
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Common/PublicCommon.h>
#import "LoadingView.h"
#import "DeviceInfo.h"
#import "DeviceCell.h"
#import "YNet.h"
#import "DeviceNet.h"


@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,GCDAsyncUdpSocketDelegate>
{
    UIBarButtonItem *rightbtnitem;
    UIBarButtonItem *leftbtnitem;
    UIBarButtonItem *emptybtnitem;
    
    NSMutableArray<DeviceInfo *> *devices;
    __block LoadingView *loadview;
    DeviceNet *dnet;
    NSCondition *condtion;
   
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navtitle;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (assign)BOOL IsHidereturn;
@property (weak,nonatomic)UIViewController *mainview;

@end
