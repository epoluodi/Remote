//
//  NewTaskVIew.m
//  Remote
//
//  Created by Stereo on 16/1/27.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "NewTaskVIew.h"
#import "LoadingView.h"
#import "MainViewController.h"

@interface NewTaskVIew ()
{
    DeviceNet *dnet;
    __block LoadingView *loadview;
}
@end

@implementation NewTaskVIew
@synthesize taskname,btnenddt,btnstartdt;
@synthesize labstartdt,enddt;
@synthesize displayview;
@synthesize mainView;
@synthesize starttime,endtime;
@synthesize btnendtime,btnstarttime;
@synthesize delegate;


-(void)awakeFromNib
{
    IsAdd =YES;
    labstartdt.text=@"";
    enddt.text=@"";
    starttime.text=@"";
    endtime.text =@"";
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    displayview.layer.cornerRadius=6;
    displayview.layer.masksToBounds=YES;
    
  
    btnok = [[UIButton alloc] init];
    btnok.frame = CGRectMake(15, btnstarttime.frame.origin.y + btnenddt.frame.size.height + 15,
                             [PublicCommon GetALLScreen].size.width /2 -50, 40);
    
    [btnok setTitle:@"确定" forState:UIControlStateNormal];
    [btnok addTarget:self action:@selector(btnclickOK) forControlEvents:UIControlEventTouchUpInside];
    btnok.layer.cornerRadius = 8;
    btnok.layer.masksToBounds=YES;
    UIImage *image1 = [PublicCommon createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:1.00]
                                            Rect:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width /2- 50, 40) ];
    
    UIImage *image2 = [PublicCommon createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:.5f]
                                            Rect:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width  /2- 50, 40)];
    
    [btnok setBackgroundImage:image1 forState:UIControlStateNormal];
    [btnok setBackgroundImage:image2 forState:UIControlStateHighlighted];

    [displayview addSubview:btnok];
    
    btncancel = [[UIButton alloc] init];
    btncancel.frame = CGRectMake(btnok.frame.size.width +45, btnstarttime.frame.origin.y + btnenddt.frame.size.height + 15,
                             [PublicCommon GetALLScreen].size.width /2 -50, 40);
    [btncancel setTitle:@"取消" forState:UIControlStateNormal];
    [btncancel addTarget:self action:@selector(btnclickcancel) forControlEvents:UIControlEventTouchUpInside];
    btncancel.layer.cornerRadius = 8;
    btncancel.layer.masksToBounds=YES;

    
    [btncancel setBackgroundImage:image1 forState:UIControlStateNormal];
    [btncancel setBackgroundImage:image2 forState:UIControlStateHighlighted];
  
    [displayview addSubview:btncancel];
    
    taskname.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
    

    labstartdt.tag=1;
    enddt.tag=2;
    starttime.tag =3;
    endtime.tag=4;
    
    taskname.placeholder = [NSString stringWithFormat:@"新建任务%@",[PublicCommon getDateStringWithFormat:@"HH:mm"]];
}


//点击确定
-(void)btnclickOK
{
    
    if ([taskname.text isEqualToString:@""])
        temptaskname = taskname.placeholder;
    else
        temptaskname=taskname.text;
    
    if ([starttime.text isEqualToString:@""] ||
        [endtime.text isEqualToString:@""] ||
        [enddt.text isEqualToString:@""] ||
        [labstartdt.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入日期和时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
//    addTask!~!3%~%2016-02-20%~%2016-02-23%~%16:14%~%18:14
    NSString *arg = [NSString stringWithFormat:@"%@%%~%%%@%%~%%%@%%~%%%@%%~%%%@",temptaskname,labstartdt.text,enddt.text,starttime.text,endtime.text];
    
    if (!loadview)
        loadview = [[LoadingView alloc] init];
    [mainView.view addSubview:loadview];
    [loadview StartAnimation];

    dnet = [[DeviceNet alloc] init];
    dnet.Commanddelegate=self;
    dispatch_queue_t globalQ = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQ , ^{
        if (IsAdd)
            [dnet AddTask:((MainViewController *)mainView).DeviceIP arg:arg];
        else
            [dnet EditTask:((MainViewController *)mainView).DeviceIP arg:arg];
        
    });
    [self removeFromSuperview];
}


#pragma mark 通信操作委托
-(void)CommandFinish:(CommandType)commandtype json:(NSDictionary *)json
{
    if (loadview){
        [loadview StopAnimation];
        [loadview removeFromSuperview];
        loadview = nil;
    }
 

    if (commandtype == EaddTask || commandtype == EEditTask)
    {
        NSLog(@"获得数据");
    
        BOOL success = ((NSNumber *)[json objectForKey:@"success"]).boolValue;
        if (success){
            
            [delegate AddFinsih:[json objectForKey:@"msg"] taskname: temptaskname];
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



//点击取消
-(void)btnclickcancel
{
    [self removeFromSuperview];
}


-(void)closeinput
{
    [taskname resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (IBAction)clickstartdt:(id)sender {
    
    [self showsheetDT:UIDatePickerModeDate];
    lab =labstartdt;

}

- (IBAction)clickenddt:(id)sender {
    [self showsheetDT:UIDatePickerModeDate];
    lab = enddt;

}

- (IBAction)clickstarttime:(id)sender {
    [self showsheetDT:UIDatePickerModeTime];
    lab = starttime;
}

- (IBAction)clickendtime:(id)sender {
    [self showsheetDT:UIDatePickerModeTime];
    lab = endtime;
}

//显示sheet 日期选择
-(void)showsheetDT:(UIDatePickerMode)pickmode
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择日期和时间"
                                                                   message:@"结束时间不能大于开始时间\n\n\n\n\n\n\n\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    dtpicker = [[UIDatePicker alloc] init];
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
        NSDateFormatter *df;
        NSTimeZone *zone;
        NSInteger interval;
        switch (lab.tag) {
            case 1:
                df = [[NSDateFormatter alloc] init];
                df.dateFormat=@"yyyy-MM-dd";
                sdt= [df dateFromString:lab.text];
                zone = [NSTimeZone systemTimeZone];
                interval = [zone secondsFromGMTForDate: sdt];
                sdt = [sdt  dateByAddingTimeInterval: interval];
                break;
            case 2:
                df = [[NSDateFormatter alloc] init];
                df.dateFormat=@"yyyy-MM-dd";
                edt= [df dateFromString:lab.text];
                zone = [NSTimeZone systemTimeZone];
                interval = [zone secondsFromGMTForDate: edt];
                edt = [edt  dateByAddingTimeInterval: interval];
                if ([sdt compare:edt] == 1)
                {
                    lab.text=@"";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"结束日期不能小于开始日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
                break;
            case 3:
                df = [[NSDateFormatter alloc] init];
                df.dateFormat=@"HH:mm";
                st = [df dateFromString:lab.text];
                zone = [NSTimeZone systemTimeZone];
                interval = [zone secondsFromGMTForDate: st];
                st = [st  dateByAddingTimeInterval: interval];
                break;
            case 4:
                df = [[NSDateFormatter alloc] init];
                df.dateFormat=@"HH:mm";
                et= [df dateFromString:lab.text];
                zone = [NSTimeZone systemTimeZone];
                interval = [zone secondsFromGMTForDate: et];
                et = [et  dateByAddingTimeInterval: interval];
                if ([st compare:et] == 1)
                {
                    lab.text=@"";
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"结束时间不能小于开始时间" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
                break;

        }
        lab=nil;
        
    }];
    [alert addAction:action2];
    
    
    [mainView presentViewController:alert animated:YES completion:nil];
}

-(void)SetEditMode:(NSDictionary *)d
{
    IsAdd = NO;
    taskname.text = [d objectForKey:@"billname"];
    labstartdt.text = [d objectForKey:@"sdate"];
    enddt.text= [d objectForKey:@"edate"];
    starttime.text=  [d objectForKey:@"stime"];
    endtime.text = [d objectForKey:@"etime"];
    taskid = [d objectForKey:@"billid"];
}

@end
