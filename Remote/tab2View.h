//
//  tab2View.h
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Common/PublicCommon.h>
#import "TaskCell.h"
#import "NewTaskVIew.h"
#import "DeviceNet.h"


@interface tab2View : UIView<UITableViewDataSource,UITableViewDelegate,FinishCommanddelegate,NewTaskDelegate>
{
    UITableView *table;
    UIRefreshControl *refresh;
    UIButton *btnAdd;
    NewTaskVIew *newtaskview;
    NSMutableArray *tasklist;
    __block NSIndexPath *opindex;
}

@property (weak,nonatomic) UIViewController *mainView;

-(void)LoadTaskAll;
@end
