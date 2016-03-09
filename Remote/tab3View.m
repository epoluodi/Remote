//
//  tab3View.m
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "tab3View.h"
#import "MainViewController.h"

@implementation tab3View
@synthesize mainview;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark 通信操作委托
-(void)CommandFinish:(CommandType)commandtype json:(NSDictionary *)json
{

    if (commandtype == EupVolume || commandtype ==EdownVolume)
    {
        NSLog(@"获得数据");
        
        NSNumber *result = [json objectForKey:@"success"];
        if ([result intValue] == 1)
        {
            if (tip.ISShowing)
            {
                [tip setTipInfo:[json objectForKey:@"msg"]];
            }
            else
            {
                tip=[[TipView alloc] init:[json objectForKey:@"msg"]];
                [tip showTip:mainview];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:@"音量操作失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }

        
      
       
        return;
    }
    
    if (commandtype==EPublicMedia)
    {
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (!success){
            [self CommandTimeout];
            
        }
    }
}
-(void)CommandTimeout
{

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误，请重新尝试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


#pragma mark -



- (IBAction)clickupvolume:(id)sender {
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        [dnet SetVolume:((MainViewController *)mainview).DeviceIP flag:0];

        
    });

}

- (IBAction)clickdownvolume:(id)sender {
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        [dnet SetVolume:((MainViewController *)mainview).DeviceIP flag:1];
        
        
    });
}

- (IBAction)clickfloder:(id)sender {
      [mainview performSegueWithIdentifier:@"showscanfile" sender:self];
}

- (IBAction)clickpublicmedia:(id)sender {
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        [dnet setPublicMedia:((MainViewController *)mainview).DeviceIP ];
        
        
    });
}

- (IBAction)clickabout:(id)sender {
    [mainview performSegueWithIdentifier:@"showabout" sender:self];
}

- (IBAction)clickclosedevice:(id)sender {
    
    NSArray *nibarry = [[NSBundle mainBundle] loadNibNamed:@"closedeviceview" owner:closedeviceview options:nil];
    closedeviceview = (CloseDeviceView *)nibarry[0];
    closedeviceview.frame = mainview.view.frame;
    closedeviceview.mainView= mainview;
    
    [mainview.view addSubview:closedeviceview];
    [closedeviceview getShutTimeinfo];
}
@end
