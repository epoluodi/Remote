//
//  DeviceCell.m
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "DeviceCell.h"

@implementation DeviceCell

- (void)awakeFromNib {
    // Initialization code
    self.layer.cornerRadius=6;
    self.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
