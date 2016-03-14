//
//  TaskAddVIewController.h
//  Remote
//
//  Created by 程嘉雯 on 16/3/6.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@class MainViewController;
@interface TaskAddVIewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FinishCommanddelegate>
{
    NSMutableDictionary *dictMediaList;
    NSMutableArray *headlist;
    int mediaindex;
}

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak,nonatomic)MainViewController * mainview;
@property (weak,nonatomic)NSString *taskid;

- (IBAction)clickreturn:(id)sender;
- (IBAction)clickaddok:(id)sender;

-(void)all:(int)section;

@end




@interface HeadVIew : UIView
{
    int itemindex;
    UIButton *btnchk;
    NSMutableArray<NSString *> *selectmediaID;
}
@property (assign)int incount;
@property (weak,nonatomic) UITableView *intable;
@property (nonatomic) BOOL IsAllSelect;
@property (nonatomic) BOOL IsClose;
@property (weak,nonatomic)MainViewController * mainview;
@property (weak,nonatomic)TaskAddVIewController *tavc;
-(void)initUI:(float)width section:(int)section;
-(void)ChangeSelectList:(NSString *)mediaid flag:(BOOL)flag;
-(void)closeview;
-(NSString *)getListForStr;
@end