//
//  CloseDeviceView.h
//  Remote
//
//  Created by 程嘉雯 on 16/3/9.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceNet.h"
#import "LoadingView.h"




@interface CloseDeviceView : UIView<FinishCommanddelegate>
{
    UILabel *lab;
    DeviceNet *dnet;
    __block LoadingView *loadview;
}

@property (weak, nonatomic) IBOutlet UIView *displayview;

@property (weak, nonatomic) IBOutlet UILabel *open1;
@property (weak, nonatomic) IBOutlet UILabel *close1;
@property (weak, nonatomic) IBOutlet UILabel *open2;
@property (weak, nonatomic) IBOutlet UILabel *close2;
@property (weak, nonatomic) IBOutlet UILabel *open3;
@property (weak, nonatomic) IBOutlet UILabel *close3;
@property (weak, nonatomic) IBOutlet UIButton *btnok;
@property(weak,nonatomic)UIViewController *mainView;

- (IBAction)clickopen1:(id)sender;
- (IBAction)clickclose1:(id)sender;
- (IBAction)clickopen2:(id)sender;
- (IBAction)clickclose2:(id)sender;
- (IBAction)clickopen3:(id)sender;
- (IBAction)clickclose3:(id)sender;
- (IBAction)clickok:(id)sender;


-(void)getShutTimeinfo;








@end
