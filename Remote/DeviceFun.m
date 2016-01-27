//
//  DeviceFun.m
//  Remote
//
//  Created by Stereo on 16/1/27.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "DeviceFun.h"


@implementation DeviceFun


-(NSArray<MediaData *> *)loadMediaInfo:(NSString *)mediaType
{
    NSMutableArray * arry = [[NSMutableArray alloc] init];
    MediaData *md = [[MediaData alloc] init];
    //测试
    NSString *t;
    if ([mediaType isEqualToString:@"音频"])
        t=@"1";
    else
        t=@"2";
    
    
    md.mediaName=@"江南.wav";
    md.mediaID = @"123";
    md.mediaType = t;
    md.Len = @"12.3M";
    md.source = @"file://1111";
    [arry addObject:md];
    md = [[MediaData alloc] init];
    md.mediaName=@"过年.wav";
    md.mediaID = @"123";
    md.mediaType = t;
    md.Len = @"15.3M";
    md.source = @"file://1111";
    [arry addObject:md];
    md = [[MediaData alloc] init];
    md.mediaName=@"贝多芬.wav";
    md.mediaID = @"123";
    md.mediaType = t;
    md.Len = @"22.3M";
    md.source = @"file://1111";
    [arry addObject:md];
    md = [[MediaData alloc] init];
    md.mediaName=@"我的老家.wav";
    md.mediaID = @"123";
    md.mediaType = t;
    md.Len = @"2.3M";
    md.source = @"file://1111";
    [arry addObject:md];
    md = [[MediaData alloc] init];
    md.mediaName=@"孩子好.wav";
    md.mediaID = @"123";
    md.mediaType = t;
    md.Len = @"11.3M";
    md.source = @"file://1111";
    [arry addObject:md];
    md = [[MediaData alloc] init];
    md.mediaName=@"睡觉.wav";
    md.mediaID = @"123";
    md.mediaType = t;
    md.Len = @"13.3M";
    md.source = @"file://1111";
    [arry addObject:md];
    
    return arry;
}

@end
