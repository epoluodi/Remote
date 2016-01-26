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

@interface tab2View : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    UIRefreshControl *refresh;
    UIButton *btnAdd;
}


@end
