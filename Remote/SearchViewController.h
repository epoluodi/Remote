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


@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIBarButtonItem *rightbtnitem;
    UIBarButtonItem *leftbtnitem;
    NSMutableArray<DeviceInfo *> *devices;
    int *rows;
}

@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navtitle;
@property (weak, nonatomic) IBOutlet UITableView *table;


@end
