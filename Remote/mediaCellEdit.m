//
//  mediaCellEdit.m
//  Remote
//
//  Created by 程嘉雯 on 16/2/23.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "mediaCellEdit.h"

@implementation mediaCellEdit
@synthesize medianame,size,mark,mediaid;
@synthesize plv;
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    medianame.textColor=[UIColor whiteColor];
    size.textColor=[UIColor whiteColor];
    [plv addObserver:self forKeyPath:@"IsAllSelect" options:NSKeyValueObservingOptionNew context:NULL];
    check = NO;
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"IsAllSelect"]) {
        [mark setImage:[UIImage imageNamed:@"check"]];
        [plv ChangeSelectList:mediaid flag:YES];
        check=YES;
    }
     [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

-(void)changemark
{
    if (check)
    {
        check=NO;
        [plv ChangeSelectList:mediaid flag:NO];
        [mark setImage:[UIImage imageNamed:@"uncheck"]];
    }
    else
    {
        check=YES;
        [plv ChangeSelectList:mediaid flag:YES];
        [mark setImage:[UIImage imageNamed:@"check"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//释放
-(void)dealloc
{
    [plv removeObserver:self forKeyPath:@"IsAllSelect"];
}
@end
