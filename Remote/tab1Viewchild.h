//
//  tab1Viewchild.h
//  Remote
//
//  Created by Stereo on 16/1/26.
//  Copyright © 2016年 com.cl.remote. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickdelegate

-(void)Clickback;

@end


@interface tab1Viewchild : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnback;
@property (weak, nonatomic) IBOutlet UIButton *btnedit;



@property (weak,nonatomic)NSObject<clickdelegate> *delegate;

@end
