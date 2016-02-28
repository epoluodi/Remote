//
//  ScanFileController.h
//  Remote
//
//  Created by 程嘉雯 on 16/2/28.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceNet.h"

@interface ScanFileController : UIViewController<UITableViewDataSource,UITableViewDelegate,FinishCommanddelegate>
{
    UINavigationItem *title;
    UIBarButtonItem *btnreturn;
    UIBarButtonItem *btnUpdir;
    NSArray *dirlist;
    NSString *nowdir;
    NSMutableArray *returndir;
}



@property (weak,nonatomic) UIViewController *mainview;
@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;
@property (weak, nonatomic) IBOutlet UITableView *table;

- (IBAction)clickScan:(id)sender;

@end
