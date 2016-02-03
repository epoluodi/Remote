//
//  TipView.m
//  Remote
//
//  Created by Stereo on 16/2/2.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "TipView.h"
#import <Common/PublicCommon.h>

@implementation TipView
@synthesize ISShowing;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)init:(NSString *)tipinfo
{
    self = [super init];
    
    labtip = [[UILabel alloc] init];
    labtip.text = tipinfo;
    labtip.textAlignment = NSTextAlignmentCenter;
    labtip.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    CGSize size = [tipinfo sizeWithFont:labtip.font];
    
    labtip.frame = CGRectMake([PublicCommon GetALLScreen].size.width /2 - (size.width + 15) /2,
                              [PublicCommon GetALLScreen].size.height -66 -15 - size.height, size.width+30, size.height+20);
    labtip.textColor=[UIColor whiteColor];
    labtip.layer.cornerRadius = 4;
    labtip.layer.masksToBounds=YES;
    ISShowing = NO;
    return self;
}
-(void)setTipInfo:(NSString *)tipinfo
{
    CGSize size = [tipinfo sizeWithFont:labtip.font];
    
    labtip.frame = CGRectMake([PublicCommon GetALLScreen].size.width /2 - (size.width + 15) /2,
                              [PublicCommon GetALLScreen].size.height -66 -15 - size.height, size.width+30, size.height+20);
    labtip.text = tipinfo;
    
    
}


-(void)showTip:(UIViewController *)VC
{
    ISShowing =YES;
    labtip.alpha=0;
    [VC.view addSubview:labtip];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    labtip.alpha=1;
    
    [UIView commitAnimations];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        
  
     
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];

   
        [UIView animateWithDuration:0.3 animations:^{
            labtip.alpha=0;
            
            
        } completion:^(BOOL finished) {
            if (finished)
            {
                [self closeTip];
            }
        }];
        [UIView commitAnimations];
        
        
        
    });
}

-(void)closeTip
{
    [labtip removeFromSuperview];
    ISShowing =NO;
    
}
@end
