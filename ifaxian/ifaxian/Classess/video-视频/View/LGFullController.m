//
//  LGFullController.m
//  ifaxian
//
//  Created by ming on 16/12/8.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGFullController.h"

@interface LGFullController ()

@end

@implementation LGFullController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


@end
