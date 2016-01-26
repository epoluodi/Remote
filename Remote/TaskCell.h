//
//  TaskCell.h
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskname;
@property (weak, nonatomic) IBOutlet UILabel *taskdate;
@property (weak, nonatomic) IBOutlet UILabel *tasktime;
@property (weak, nonatomic) IBOutlet UILabel *taskstate;


@end
