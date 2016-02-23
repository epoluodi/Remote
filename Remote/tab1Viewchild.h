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
#import "DeviceNet.h"

@protocol clickdelegate

-(void)Clickback;

@end


@interface tab1Viewchild : UIView<UITableViewDataSource,UITableViewDelegate,FinishCommanddelegate>
{
    
    UIRefreshControl *refresh;
    DeviceNet *dnet;

    
}


@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UIButton *btnedit;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITableView *table;



@property (weak,nonatomic)NSObject<clickdelegate> *delegate;
@property (weak,nonatomic) UIViewController *mainview;
- (IBAction)clickedit:(id)sender;



-(void)loadmedia;



@end
