//
//  tab3View.h
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceNet.h"
#import "TipView.h"
#import "CloseDeviceView.h"
@interface tab3View : UIView<FinishCommanddelegate>
{
    DeviceNet *dnet;
    TipView *tip;
    CloseDeviceView *closedeviceview;
}

@property (weak,nonatomic) UIViewController *mainview;



- (IBAction)clickupvolume:(id)sender;
- (IBAction)clickdownvolume:(id)sender;
- (IBAction)clickfloder:(id)sender;
- (IBAction)clickpublicmedia:(id)sender;
- (IBAction)clickabout:(id)sender;
- (IBAction)clickclosedevice:(id)sender;





@end
