//
//  FolderCell.h
//  Remote
//
//  Created by 程嘉雯 on 16/3/10.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanFileController.h"

@class ScanFileController;
@interface FolderCell : UITableViewCell
{
    BOOL check;
}
@property (weak, nonatomic) IBOutlet UIImageView *imgcheck;
@property (weak, nonatomic) IBOutlet UILabel *foldername;
@property (weak,nonatomic)ScanFileController *scanview;
@property (weak,nonatomic)NSString *folderallname;

-(void)resetchkstate;

@end
