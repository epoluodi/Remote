//
//  NewTaskVIew.h
//  Remote
//
//  Created by Stereo on 16/1/27.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Common/PublicCommon.h>

@interface NewTaskVIew : UIView
{
    UIButton *btnok;
    UIButton *btncancel;
    __block UIDatePicker *dtpicker;
    __block UILabel *lab;
}


@property (weak, nonatomic) IBOutlet UITextField *taskname;
@property (weak, nonatomic) IBOutlet UILabel *labstartdt;
@property (weak, nonatomic) IBOutlet UILabel *enddt;
@property (weak, nonatomic) IBOutlet UIButton *btnstartdt;
@property (weak, nonatomic) IBOutlet UIButton *btnenddt;
@property (weak, nonatomic) IBOutlet UIView *displayview;

@property(weak,nonatomic)UIViewController *mainView;

- (IBAction)clickstartdt:(id)sender;
- (IBAction)clickenddt:(id)sender;



@end
