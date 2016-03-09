//
//  CloseDeviceView.m
//  Remote
//
//  Created by 程嘉雯 on 16/3/9.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "CloseDeviceView.h"
#import <Common/PublicCommon.h>
#import "MainViewController.h"

@implementation CloseDeviceView
@synthesize displayview,btnok;
@synthesize open1,open2,open3;
@synthesize close1,close2,close3;
@synthesize mainView;
-(void)awakeFromNib
{
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    displayview.backgroundColor=[UIColor whiteColor];
    UIImage *image1 = [PublicCommon createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:1.00]
                                                    Rect:CGRectMake(0, 0, btnok.frame.size.width, btnok.frame.size.height) ];
    
    UIImage *image2 = [PublicCommon createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:.5f]
                                                    Rect:CGRectMake(0, 0, btnok.frame.size.width, btnok.frame.size.height)];
    
    [btnok setBackgroundImage:image1 forState:UIControlStateNormal];
    [btnok setBackgroundImage:image2 forState:UIControlStateHighlighted];
    btnok.layer.cornerRadius = 8;
    btnok.layer.masksToBounds=YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)getShutTimeinfo
{
    if (!loadview)
        loadview = [[LoadingView alloc] init];
    [mainView.view addSubview:loadview];
    [loadview StartAnimation];
    
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        
        [dnet getShutTimeinfo:((MainViewController *)mainView).DeviceIP];
        
        
    });
}

- (IBAction)clickopen1:(id)sender {
    lab = open1;
    [self showsheetDT:UIDatePickerModeTime];
}

- (IBAction)clickclose1:(id)sender {
    lab = close1;
    [self showsheetDT:UIDatePickerModeTime];
}

- (IBAction)clickopen2:(id)sender {
    lab = open2;
    [self showsheetDT:UIDatePickerModeTime];
}

- (IBAction)clickclose2:(id)sender {
    lab = close2;
    [self showsheetDT:UIDatePickerModeTime];
}

- (IBAction)clickopen3:(id)sender {
    lab = open3;
    [self showsheetDT:UIDatePickerModeTime];
}

- (IBAction)clickclose3:(id)sender {
    lab = close3;
    [self showsheetDT:UIDatePickerModeTime];
}

- (IBAction)clickok:(id)sender {
    
    
    NSString *arg = [NSString stringWithFormat:@"%@%%~%%%@%%~%%%@%%~%%%@%%~%%%@%%~%%%@",open1.text,close1.text,open2.text,close2.text,open3.text,close3.text];
    
    if (!loadview)
        loadview = [[LoadingView alloc] init];
    [mainView.view addSubview:loadview];
    [loadview StartAnimation];
    
    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
   
        [dnet setOnOffTime:((MainViewController *)mainView).DeviceIP arg:arg];
   
        
    });

    
}



#pragma mark 通信操作委托
-(void)CommandFinish:(CommandType)commandtype json:(NSDictionary *)json
{
    if (loadview){
        [loadview StopAnimation];
        [loadview removeFromSuperview];
        loadview = nil;
    }
    
    
    if (commandtype == EOnOffTime  )
    {
        NSLog(@"获得数据");
        
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
//        if (success){
//            
            [self removeFromSuperview];
//        }
//        else
//            [self CommandTimeout];
        return;
    }
    
    if (commandtype == EGetShutTime  )
    {
        NSLog(@"获得数据");
        
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
                if (success){
                    NSArray *shuttimes = [json objectForKey:@"data"];
                    NSDictionary *d = shuttimes[0];
                        open1.text = [d objectForKey:@"starttime"];
                        close1.text = [d objectForKey:@"shuttime"];
                    d=shuttimes[1];
                    open2.text = [d objectForKey:@"starttime"];
                    close2.text = [d objectForKey:@"shuttime"];
                    d=shuttimes[2];
                    open3.text = [d objectForKey:@"starttime"];
                    close3.text = [d objectForKey:@"shuttime"];
                    
                }
                else
                    [self CommandTimeout];
        return;
    }
    
    
}
-(void)CommandTimeout
{
    
    if (loadview){
        [loadview StopAnimation];
        [loadview removeFromSuperview];
        loadview = nil;
    }
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络错误，请重新尝试!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


#pragma mark -


-(void)showsheetDT:(UIDatePickerMode)pickmode
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择日期和时间"
                                                                   message:@"结束时间不能大于开始时间\n\n\n\n\n\n\n\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIDatePicker *dtpicker = [[UIDatePicker alloc] init];
    dtpicker.datePickerMode=pickmode;
    dtpicker.frame = CGRectMake(30, 30, [PublicCommon GetALLScreen].size.width-90, 220);
    [alert.view addSubview:dtpicker];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDateFormatter *dtformat = [[NSDateFormatter alloc] init];
        if (pickmode == UIDatePickerModeDate)
            [dtformat setDateFormat:@"yyyy-MM-dd"];
        if (pickmode == UIDatePickerModeTime)
            [dtformat setDateFormat:@"HH:mm"];
        
        
        lab.text = [dtformat stringFromDate:dtpicker.date];
   
        lab=nil;
        
    }];
    [alert addAction:action2];
    
    
    [mainView presentViewController:alert animated:YES completion:nil];
}



@end
