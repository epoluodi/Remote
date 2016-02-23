//
//  mediaCellEdit.m
//  Remote
//
//  Created by 程嘉雯 on 16/2/23.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "mediaCellEdit.h"

@implementation mediaCellEdit
@synthesize medianame,size,mark;
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    medianame.textColor=[UIColor whiteColor];
    size.textColor=[UIColor whiteColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
