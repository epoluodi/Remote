//
//  MediaInfoCell.m
//  Remote
//
//  Created by Stereo on 16/1/27.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "MediaInfoCell.h"

@implementation MediaInfoCell
@synthesize medianame,len,imageView;
- (void)awakeFromNib {
    // Initialization code
    medianame.textColor=[UIColor whiteColor];
    len.textColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
