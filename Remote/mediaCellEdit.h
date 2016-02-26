//
//  mediaCellEdit.h
//  Remote
//
//  Created by 程嘉雯 on 16/2/23.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLViewController.h"

@interface mediaCellEdit : UITableViewCell
{
    BOOL check;
}

@property (weak, nonatomic) IBOutlet UILabel *medianame;
@property (weak, nonatomic) IBOutlet UILabel *size;
@property (weak, nonatomic) IBOutlet UIImageView *mark;
@property (weak,nonatomic) NSString *mediaid;
@property (weak,nonatomic) PLViewController *plv;


-(void)changemark;
-(void)initKVO:(BOOL)flag;

@end
