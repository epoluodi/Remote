//
//  MediaInfoCell.h
//  Remote
//
//  Created by Stereo on 16/1/27.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MediaInfoCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *medianame;
@property (weak, nonatomic) IBOutlet UILabel *len;
@property (weak, nonatomic) IBOutlet UIImageView *imgtype;


@end
