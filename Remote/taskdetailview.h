//
//  taskdetailview.h
//  Remote
//
//  Created by 程嘉雯 on 16/3/3.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DelegateHead.h"
#import "DeviceNet.h"
#import "mediaCellEdit.h"

@interface taskdetailview : UIView<UITableViewDataSource,UITableViewDelegate,FinishCommanddelegate>
{
    UIRefreshControl *refresh;
    DeviceNet *dnet;
    NSMutableArray<NSString *> *selectmediaID;
    NSArray* detaillist;
}

@property (weak, nonatomic) IBOutlet UIButton *btnreturn;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *btnadd;
@property (weak, nonatomic) IBOutlet UIButton *btndel;
@property (weak, nonatomic) IBOutlet UIButton *btncheck;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak,nonatomic)NSString *taskid;

@property (weak,nonatomic)NSObject<clickdelegate> *delegate;
@property (weak,nonatomic) UIViewController *mainview;
@property (nonatomic) BOOL IsAllSelect;
@property (nonatomic) BOOL IsClose;

- (IBAction)clickreturn:(id)sender;
- (IBAction)clickadd:(id)sender;
- (IBAction)clickdel:(id)sender;
- (IBAction)clickselectall:(id)sender;


-(void)ChangeSelectList:(NSString *)mediaid flag:(BOOL)flag;
-(void)loadtaskdetailinfo;



@end
