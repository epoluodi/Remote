//
//  tab1Viewchild.m
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "tab1Viewchild.h"

@implementation tab1Viewchild
@synthesize btnback,btnedit;
@synthesize delegate;


-(void)awakeFromNib
{
    [btnback addTarget:self action:@selector(clickbtnback) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickbtnback
{
    [delegate Clickback];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
