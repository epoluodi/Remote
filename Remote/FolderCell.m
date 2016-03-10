//
//  FolderCell.m
//  Remote
//
//  Created by 程嘉雯 on 16/3/10.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "FolderCell.h"

@implementation FolderCell
@synthesize imgcheck,foldername;
@synthesize scanview;
@synthesize folderallname;
- (void)awakeFromNib {
    // Initialization code
    imgcheck.userInteractionEnabled=YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changemark)];
    [imgcheck addGestureRecognizer:tap];
    
    
}


-(void)resetchkstate
{
    check=NO;
    [imgcheck setImage:[UIImage imageNamed:@"uncheck"]];
}
-(void)changemark
{
    if (check)
    {
        check=NO;
        if (scanview)
            [scanview ChangeSelectList:folderallname flag:NO];
    
        [imgcheck setImage:[UIImage imageNamed:@"uncheck"]];
    }
    else
    {
        check=YES;
        if (scanview)
            [scanview ChangeSelectList:folderallname flag:YES];
       
        [imgcheck setImage:[UIImage imageNamed:@"check"]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
