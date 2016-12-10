//
//  LGRefrshView.m
//  下拉刷新oc
//
//  Created by ming on 16/10/31.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGRefreshViewFont.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>
@interface LGRefreshViewFont()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (nonatomic,strong) CALayer *animationLayer;
@property (nonatomic,strong) CAShapeLayer *pathLayer;
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actuvitiView;

@end

@implementation LGRefreshViewFont

- (void)setParentViewHeight:(CGFloat)parentViewHeight{
    CGFloat timeOffset;
    timeOffset = fabs(parentViewHeight)/9.0f;
    
    
    //计算变大系数
        if (timeOffset > 9.0) {
        timeOffset = 9.0;
    }
    self.pathLayer.timeOffset = timeOffset;
}


+ (LGRefreshViewFont *)refrshView{
    
    LGRefreshViewFont *refView = [[[NSBundle mainBundle] loadNibNamed:@"LGRefreshViewFont" owner:self options:nil] firstObject];
    refView.refState = Normal;

    return refView;
}
- (void)setRefState:(LGRefrshType)refState{
    
//    Normal,
//    ///刷新状态
//    PullIng,
//    ///正在刷新状态
//    willRefresh
    _refState = refState;
    switch (refState) {
            //正常状态
        case Normal:{
            [_actuvitiView stopAnimating];
            self.animationLayer.hidden = NO;
             _titleLable.alpha = 0;
            
            break;
            ///刷新状态
        }
        case PullIng:{
         
            break;
        }
            
            ///正在刷新
        case willRefresh:
            self.animationLayer.hidden = YES;
            _titleLable.text = @"正在刷新...";
            _titleLable.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                _titleLable.alpha = 1;
            }];
            
            [_actuvitiView startAnimating];
            
            break;
    }
    
    
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = self.superview.backgroundColor;
    [self setupUI];
    
}
- (void)setupUI{

    //设置动画
    self.animationLayer = [CALayer layer];
    self.animationLayer.frame = CGRectMake(0.0f, 20.0f,CGRectGetWidth(self.layer.bounds),CGRectGetHeight(self.layer.bounds));
    [self.layer addSublayer:self.animationLayer];
    
    
    self.animationLayer.hidden = NO;
    
    
    //开始加载动画
    [self setupTextLayer];
    
    
    [self startAnimation];
    
    
    
    
    
}
- (void) startAnimation
{
    [self.pathLayer removeAllAnimations];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 9.0;
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.removedOnCompletion = NO;
    [self.pathLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
    
}
- (void)dealloc{
    
    NSLog(@"销毁了");
}
#pragma mark ---- 文字效果核心代码
- (void) setupTextLayer
{
    //原 Demo 地址:https://github.com/ole/Animated-Paths
    if (self.pathLayer != nil) {
        [self.pathLayer removeFromSuperlayer];
        self.pathLayer = nil;
    }
    
    // Create path from text
    // See: http://www.codeproject.com/KB/iPhone/Glyph.aspx
    // License: The Code Project Open License (CPOL) 1.02 http://www.codeproject.com/info/cpol10.aspx
    CGMutablePathRef letters = CGPathCreateMutable();
    
    CTFontRef font = CTFontCreateWithName(CFSTR("HelveticaNeue-UltraLight"), 28.0f, NULL);//Helvetica-Bold

    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName, NSForegroundColorAttributeName,[UIColor yellowColor],
                           nil];
    
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"IFAXIAN"
                                                                     attributes:attrs];
    //C'est La Vie
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // Get PATH of outline
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.frame = self.animationLayer.bounds;//设置位置
    pathLayer.bounds = CGPathGetBoundingBox(path.CGPath);//设置位置
    pathLayer.geometryFlipped = YES;
    pathLayer.path = path.CGPath;
    pathLayer.strokeColor = [UIColor colorWithRed:234.0/255 green:84.0/255 blue:87.0/255 alpha:1].CGColor;
    pathLayer.fillColor = nil;
    pathLayer.lineWidth = 1.0f;
    pathLayer.lineJoin = kCALineJoinBevel; //TODO 好像没啥用?
    
    pathLayer.speed = 0;
    pathLayer.timeOffset = 0;
   
    [self.animationLayer addSublayer:pathLayer];
    
    self.pathLayer = pathLayer;
}

@end
