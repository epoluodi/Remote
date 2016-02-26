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

    check = NO;
    
}

-(void)initKVO:(BOOL)flag
{
    if (flag)
    {
        [mark setImage:[UIImage imageNamed:@"check"]];
        [plv ChangeSelectList:mediaid flag:YES];
        check=YES;
    }
    else
    {
        [mark setImage:[UIImage imageNamed:@"uncheck"]];
        [plv ChangeSelectList:mediaid flag:NO];
        check=NO;
    }
        [plv addObserver:self forKeyPath:@"IsAllSelect" options:NSKeyValueObservingOptionNew context:NULL];
          [plv addObserver:self forKeyPath:@"IsClose" options:NSKeyValueObservingOptionNew context:NULL];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"IsAllSelect"]) {
    
        if (((NSNumber *)[change objectForKey:@"new"]).intValue==0)
        {
            [mark setImage:[UIImage imageNamed:@"uncheck"]];
            [plv ChangeSelectList:mediaid flag:NO];
            check=NO;
        }
        else
        {
        [mark setImage:[UIImage imageNamed:@"check"]];
        [plv ChangeSelectList:mediaid flag:YES];
        check=YES;
        }
    }else if  ([keyPath isEqualToString:@"IsClose"])
    {
        [plv removeObserver:self forKeyPath:@"IsAllSelect"];
        [plv removeObserver:self forKeyPath:@"IsClose"];
    }
    else
    {
     [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
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


@end
