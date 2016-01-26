//
//  tab1View.h
//  Remote
//
//  Created by Stereo on 16/1/25.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol tab1itemClick
-(void)ItemClick:(NSString *)itemname;

@end

@interface tab1View : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    UIRefreshControl *refresh;
}
@property (weak,nonatomic) NSObject<tab1itemClick> *delegate;

-(UITableView *)tableinit:(CGRect)frame;


@end
