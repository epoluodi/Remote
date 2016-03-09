//
//  aboutViewController.m
//  Remote
//
//  Created by 程嘉雯 on 16/3/9.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import "aboutViewController.h"

@interface aboutViewController ()

@end

@implementation aboutViewController
@synthesize img;
- (void)viewDidLoad {
    [super viewDidLoad];
    img.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeview)];
    tap.numberOfTapsRequired=1;
    tap.numberOfTouchesRequired=1;
    [img addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view.
}

-(void)closeview
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
