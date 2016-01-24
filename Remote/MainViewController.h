//
//  MainViewController.h
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UIScrollViewDelegate>
{
    UIButton *btnlibary;
    UIButton *btntask;
    UIButton *btnsetting;
    UIView *_lineview;
    UIScrollView *scrollview;
}

@property (weak, nonatomic) IBOutlet UIButton *btnsearch;
@property (weak, nonatomic) IBOutlet UIView *tabview;
@property (weak, nonatomic) IBOutlet UIView *controlview;

- (IBAction)clicksearch:(id)sender;


@end
