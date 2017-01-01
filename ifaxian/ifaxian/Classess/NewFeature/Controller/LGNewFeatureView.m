//
//  LGNewFeatureView.m
//  ifaxian
//
//  Created by ming on 16/12/26.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGNewFeatureView.h"
@interface LGNewFeatureView()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LGNewFeatureView

- (void)awakeFromNib{
    _webView.scrollView.bounces = NO;
    _webView.scrollView.scrollEnabled = NO;
    [super awakeFromNib];
    //获取新特性页面
    NSString *path = [[NSBundle mainBundle] pathForResource:@"NewFeature.html" ofType:nil];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}
- (IBAction)removeView:(id)sender {
    [self removeFromSuperview];
}

@end
