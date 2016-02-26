//
//  PLViewController.h
//  Remote
//
//  Created by 程嘉雯 on 16/2/22.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceNet.h"

@interface PLViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,FinishCommanddelegate>
{
    UIButton *btnmove;
    UIButton *btndel;
    NSMutableArray<NSString *> *selectmediaID;
}

@property (weak, nonatomic) IBOutlet UIView *footview;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *btnmarkall;
@property (weak,nonatomic) UIViewController *mainview;
@property (nonatomic) BOOL IsAllSelect;
@property (nonatomic) BOOL IsClose;

- (IBAction)clickmarkall:(id)sender;
- (IBAction)clickreturn:(id)sender;

-(void)ChangeSelectList:(NSString *)mediaid flag:(BOOL)flag;


@end
