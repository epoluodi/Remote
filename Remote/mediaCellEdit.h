//
//  mediaCellEdit.h
//  Remote
//
//  Created by 程嘉雯 on 16/2/23.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLViewController.h"
#import "taskdetailview.h"
#import "TaskAddVIewController.h"

@class taskdetailview;
@class TaskAddVIewController;
@class HeadVIew;
@interface mediaCellEdit : UITableViewCell
{
    BOOL check;
}

@property (weak, nonatomic) IBOutlet UILabel *medianame;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UIImageView *mark;
@property (weak,nonatomic) NSString *mediaid;
@property (weak,nonatomic) PLViewController *plv;
@property (weak,nonatomic) taskdetailview *tdlv;
@property (weak,nonatomic) HeadVIew *hv;

-(void)changemark;
-(void)initKVO:(BOOL)flag;

@end
