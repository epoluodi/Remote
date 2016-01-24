//
//  LoadingView.m
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView



-(instancetype)init
{
    self = [super init];
    images = @[
               [UIImage imageNamed:@"progress_1"],
               [UIImage imageNamed:@"progress_2"],
               [UIImage imageNamed:@"progress_3"],
               [UIImage imageNamed:@"progress_4"],
               [UIImage imageNamed:@"progress_5"],
               [UIImage imageNamed:@"progress_6"],
               [UIImage imageNamed:@"progress_7"],
               [UIImage imageNamed:@"progress_8"]
               ];
    
    self.frame = CGRectMake(0, 0, [PublicCommon GetALLScreen].size.width, [PublicCommon GetALLScreen].size.height+20);
    
    image = [[UIImageView alloc] init];
    image.animationImages = images;
    image.animationDuration = 0.8f;
    image.animationRepeatCount=0;
    image.contentMode=UIViewContentModeScaleAspectFit;
    
    image.frame = CGRectMake([PublicCommon GetALLScreen].size.width /2 -45, [PublicCommon GetALLScreen].size.height /2 -45, 90, 90);
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8f];
    [self addSubview: image];
    
    
    return self;
}

-(void)StartAnimation
{
    [image startAnimating];
}
-(void)StopAnimation
{
    [image stopAnimating];
}
-(void)dealloc
{
    [image stopAnimating];
    [image removeFromSuperview];
    image = nil;
    images= nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
