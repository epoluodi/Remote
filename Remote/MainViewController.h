//
//  MainViewController.h
//  Remote
//
//  Created by 程嘉雯 on 16/1/24.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tab1View.h"
#import "tab2View.h"
#import "tab3View.h"
#import "tab1Viewchild.h"
#import "DeviceFun.h"
@interface MainViewController : UIViewController<UIScrollViewDelegate,tab1itemClick,clickdelegate>
{
    UIButton *btnlibary;
    UIButton *btntask;
    UIButton *btnsetting;
    UIView *_lineview;
    UIScrollView *scrollview;
    
    tab1View *tab1;
    tab2View *tab2;
    tab3View *tab3;
    
    tab1Viewchild *t1viewchild;
}

@property (weak, nonatomic) IBOutlet UIButton *btnsearch;
@property (weak, nonatomic) IBOutlet UIView *tabview;
@property (weak, nonatomic) IBOutlet UIView *controlview;
@property (weak, nonatomic) IBOutlet UIView *headview;



- (IBAction)clicksearch:(id)sender;


@end
