//
//  tab1Viewchild.h
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaData.h"
#import "MediaInfoCell.h"
@protocol clickdelegate

-(void)Clickback;

@end


@interface tab1Viewchild : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSArray<MediaData *> *mediaarray;
    UIRefreshControl *refresh;
}


@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UIButton *btnedit;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITableView *table;



@property (weak,nonatomic)NSObject<clickdelegate> *delegate;


-(void)loadmedia:(NSArray<MediaData *> *)arry;
@end
