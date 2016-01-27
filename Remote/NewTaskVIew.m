//
//  NewTaskVIew.m
//  Remote
//
//  Created by Stereo on 16/1/27.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "NewTaskVIew.h"

@implementation NewTaskVIew
@synthesize taskname,btnenddt,btnstartdt;
@synthesize labstartdt,enddt;
@synthesize displayview;
@synthesize mainView;

-(void)awakeFromNib
{
    labstartdt.text=@"";
    enddt.text=@"";
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    displayview.layer.cornerRadius=6;
    displayview.layer.masksToBounds=YES;
    
  
    btnok = [[UIButton alloc] init];
    btnok.frame = CGRectMake(15, btnenddt.frame.origin.y + btnenddt.frame.size.height + 15,
                             [PublicCommon GetALLScreen].size.width /2 -50, 40);
    
    [btnok setTitle:@"确定" forState:UIControlStateNormal];
    [btnok addTarget:self action:@selector(btnclickOK) forControlEvents:UIControlEventTouchUpInside];
    btnok.layer.cornerRadius = 8;
    btnok.layer.masksToBounds=YES;
    UIImage *image1 = [self createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:1.00]
                                            Rect:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width /2- 50, 40) ];
    
    UIImage *image2 = [self createImageWithColor:[UIColor colorWithRed:0.231 green:0.718 blue:0.898 alpha:.5f]
                                            Rect:CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width  /2- 50, 40)];
    
    [btnok setBackgroundImage:image1 forState:UIControlStateNormal];
    [btnok setBackgroundImage:image2 forState:UIControlStateHighlighted];

    [displayview addSubview:btnok];
    
    btncancel = [[UIButton alloc] init];
    btncancel.frame = CGRectMake(btnok.frame.size.width +45, btnenddt.frame.origin.y + btnenddt.frame.size.height + 15,
                             [PublicCommon GetALLScreen].size.width /2 -50, 40);
    [btncancel setTitle:@"取消" forState:UIControlStateNormal];
    [btncancel addTarget:self action:@selector(btnclickcancel) forControlEvents:UIControlEventTouchUpInside];
    btncancel.layer.cornerRadius = 8;
    btncancel.layer.masksToBounds=YES;

    
    [btncancel setBackgroundImage:image1 forState:UIControlStateNormal];
    [btncancel setBackgroundImage:image2 forState:UIControlStateHighlighted];
  
    [displayview addSubview:btncancel];
    
    taskname.inputAccessoryView = [PublicCommon getInputToolbar:self sel:@selector(closeinput)];
}


//点击确定
-(void)btnclickOK
{
    [self removeFromSuperview];
}


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
- (UIImage*) createImageWithColor: (UIColor*) color Rect:(CGRect) rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (IBAction)clickstartdt:(id)sender {
    
    [self showsheetDT];
    lab =labstartdt;
}

- (IBAction)clickenddt:(id)sender {
    [self showsheetDT];
    lab = enddt;
}

//显示sheet 日期选择
-(void)showsheetDT
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择日期和时间"
                                                                   message:@"结束时间不能大于开始时间\n\n\n\n\n\n\n\n\n\n"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    
    dtpicker = [[UIDatePicker alloc] init];
    dtpicker.frame = CGRectMake(30, 30, [PublicCommon GetALLScreen].size.width-90, 220);
    [alert.view addSubview:dtpicker];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSDateFormatter *dtformat = [[NSDateFormatter alloc] init];
        [dtformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        lab.text = [dtformat stringFromDate:dtpicker.date];
        lab=nil;
        
    }];
    [alert addAction:action2];
    
    
    
    
    
    
    
    
    
    
    [mainView presentViewController:alert animated:YES completion:nil];
}
@end
