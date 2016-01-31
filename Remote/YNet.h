//
//  YNet.h
//  Remote
//
//  Created by 程嘉雯 on 16/1/29.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum :int
{
    WIFI=0,
    Mobile_2G,
    Mobile_3G,
    Mobile_4G,
    NONE,
} NetEnum;

@interface YNet : NSObject

+(NetEnum)GetNetWorkState;
@end
