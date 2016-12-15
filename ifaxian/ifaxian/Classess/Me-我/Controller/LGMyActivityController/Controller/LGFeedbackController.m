//
//  LGFeedbackController.m
//  ifaxian
//
//  Created by ming on 16/12/14.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGFeedbackController.h"

@interface LGFeedbackController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navItem;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation LGFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
    _textView.layer.backgroundColor = [[UIColor clearColor] CGColor];
    
    
    _textView.layer.borderColor = [[UIColor blackColor]CGColor];
    
    
    _textView.layer.borderWidth = 1.0;
    
    
    _textView.layer.cornerRadius = 8.0f;
    
    
    [_textView.layer setMasksToBounds:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)send:(id)sender {
    
    
}



@end
