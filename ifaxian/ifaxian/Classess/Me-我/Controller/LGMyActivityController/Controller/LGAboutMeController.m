//
//  LGAboutController.m
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGAboutMeController.h"

@interface LGAboutMeController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LGAboutMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlStr = [NSString requestBasiPathAppend:@"/123.html"];
    NSURL *url = [NSURL URLWithString:urlStr];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}




@end
