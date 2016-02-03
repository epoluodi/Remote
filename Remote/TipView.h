//
//  TipView.h
//  Remote
//
//  Created by Stereo on 16/2/2.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipView : UIView
{
    UILabel *labtip;
    NSString *strtipinfo;
}
@property (assign)BOOL ISShowing;
-(instancetype)init:(NSString *)tipinfo;
-(void)setTipInfo:(NSString *)tipinfo;
-(void)showTip:(UIViewController *)VC;
-(void)closeTip;
@end
