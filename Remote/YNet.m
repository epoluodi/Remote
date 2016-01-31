//
//  YNet.m
//  Remote
//
//  Created by 程嘉雯 on 16/1/29.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "YNet.h"

@implementation YNet


+(NetEnum)GetNetWorkState
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
 
    int netType = 0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
//                    state = @"无网络";
                    //无网模式
                    return NONE;
                case 1:
//                    state = @"2G";
                    return Mobile_2G;
                case 2:
//                    state = @"3G";
                    return Mobile_3G;
                case 3:
//                    state = @"4G";
                    return Mobile_4G;
                case 5:
                    
                    return WIFI;
          
            }
        }
    }
    //根据状态选择
    return  NONE;
}






@end
