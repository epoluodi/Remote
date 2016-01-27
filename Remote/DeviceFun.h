//
//  DeviceFun.h
//  Remote
//
//  Created by Stereo on 16/1/27.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MediaData.h"
@interface DeviceFun : NSObject

-(NSArray<MediaData *> *)loadMediaInfo:(NSString *)mediaType;


@end
