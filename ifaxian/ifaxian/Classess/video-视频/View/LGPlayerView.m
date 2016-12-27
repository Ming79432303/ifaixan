
//
//  LGPlayerView.m
//  LGPlayer
//
//  Created by ming on 16/12/2.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "LGPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "SVProgressHUD.h"
#import "LGFullController.h"
@interface LGPlayerView()




//已经播放的时间
@property (weak, nonatomic) IBOutlet UILabel *playingTimeLable;
//总共的时间
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLable;
//视频的进度条
@property (weak, nonatomic) IBOutlet UISlider *videoSlider;
//全屏按钮
@property (weak, nonatomic) IBOutlet UIButton *fullScreen;
//覆盖的背景图
@property (weak, nonatomic) IBOutlet UIView *converView;
//重播按钮
@property (weak, nonatomic) IBOutlet UIView *failView;

@property (weak, nonatomic) IBOutlet UIButton *replayButton;
/** playerLayer */
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
/** player */
@property(nonatomic,strong)AVPlayer *player;
/** playerItem */
@property(nonatomic,strong)AVPlayerItem *playerItem;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

/** 是否显示toolView */
@property(nonatomic,assign)BOOL isShowToolView;

/** toolView显示时间的timer */
@property(nonatomic,strong)NSTimer *showTime;

/** slider和播放时间定时器 */
@property(nonatomic,strong)NSTimer *progressTimer;

@property(assign,nonatomic) CGFloat lastProgress;

/** 全屏播放控制器 */
@property(nonatomic,strong)LGFullController *fullVc;


/** 播放完毕遮盖View */

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *starOrStopVideo;


@end


@implementation LGPlayerView



//创建定时器
-(NSTimer *)progressTimer
{
    if (_progressTimer == nil) {
        _progressTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    }
    return _progressTimer;
}

//加载播放视图
+ (instancetype)videoPlayView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"LGPlayerView" owner:nil options:nil]lastObject];
}

/** 加载xib来到awakeFromNib */
-(void)awakeFromNib
{
    
    
    [super awakeFromNib];
    // 隐藏遮盖版
    self.converView.hidden = YES;
    
    
    
    
    //imageView添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.bacImagView addGestureRecognizer:tap];
    // 初始化player 和playerLayer
    self.player = [[AVPlayer alloc]init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    // imageView上添加playerLayer
    [self.bacImagView.layer addSublayer:self.playerLayer];
    
    // 设置工具栏状态
    self.toolView.alpha = 0;
    
    self.isShowToolView = NO;
    
    // 设置Slider
    [self.videoSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    [self.videoSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.videoSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    // 设置按钮状态
    self.starOrStopVideo.selected = NO;
}


/** layoutSubViews 布局子控件 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    self.playerLayer.frame = self.bacImagView.bounds;
}
/** 需要播放的视频资源set方法 */
-(void)setUrlString:(NSString *)urlString
{
    
    _urlString = urlString;
    NSURL *url = [NSURL URLWithString:urlString];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];

}
//点击中间播放按钮
- (IBAction)starVideo:(UIButton *)sender {
    
    [self.activityView startAnimating];
    //点击播放隐藏按钮
    sender.hidden = YES;
    self.starOrStopVideo.selected = YES;
    //替换界面
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    //播放
    [self.player play];
    //添加定时器
    [self addProgressTimer];
    
    
}

/** imageView的tap手势方法 */
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    if (self.player.status == AVPlayerStatusUnknown) {
        [self starVideo:self.fullStarButton];
        return;
    }
    self.isShowToolView = !self.isShowToolView;
    if (self.isShowToolView){
        [UIView animateWithDuration:0.5 animations:^{
            self.toolView.alpha = 1;
        }];
        if (self.starOrStopVideo.selected) {
            [self addShowTime];
        }
    }else{
        [self removeShowTime];
        [UIView animateWithDuration:0.5 animations:^{
            self.toolView.alpha = 0;
        }];
    }
}
/** 将toolView隐藏 */
-(void)upDateToolView
{
    self.isShowToolView = !self.isShowToolView;
    [UIView animateWithDuration:0.5 animations:^{
        self.toolView.alpha = 0;
    }];

}
-(void)removeShowTime
{
    
    [self.showTime invalidate];
    self.showTime = nil;
}
-(void)dealloc{

    
    
}

/** toolView显示时开始计时，5s后隐藏toolView */
-(void)addShowTime
{
    self.showTime = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(upDateToolView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop]addTimer:self.showTime forMode:NSRunLoopCommonModes];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        //缓存进度－－－－－－－－－－－－
  
        self.progress.progress = timeInterval / totalDuration;
        if (self.lastProgress >= self.progress.progress) {
            [self.activityView startAnimating];
        }else{
            [self.activityView stopAnimating];
            if (self.starOrStopVideo.selected) {
                 [self.player play];
            }
           
        }
        
        
        
    }else if ([keyPath isEqualToString:@"status"]){
        if (playerItem.status == AVPlayerItemStatusReadyToPlay){
           
             [self.activityView stopAnimating];
            self.failView.hidden = YES;
            
        } else{
           
            self.failView.hidden = NO;
            [self.activityView stopAnimating];
           [self removeProgressTimer];
        }
    }
}
- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

/** slider定时器添加 */
-(void)addProgressTimer
{
    //    self.progressTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    //    [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    
    [self progressTimer];
}
/** 更新slider和timeLabel */
- (void)updateProgressInfo
{
    LGLog(@"定时器");
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval durationTime = CMTimeGetSeconds(self.player.currentItem.duration);
    if (durationTime > 0) {
        
        self.playingTimeLable.text = [self timeToStringWithTimeInterval:currentTime];
        self.totalTimeLable.text = [self timeToStringWithTimeInterval:durationTime];
    }
    if (![self lg_intersectWithView:self.window]) {
      
        [self.superview removeFromSuperview];
        [self removeFromSuperview];
    }
    self.videoSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    if ( self.lastProgress == self.videoSlider.value ) {
        [self.activityView startAnimating];
    }else{
        [self.activityView stopAnimating];
        
    }
    self.lastProgress = self.videoSlider.value ;
    
    
    if (self.videoSlider.value == 1) {
        [self removeProgressTimer];
        self.converView.hidden = NO;
     
    }
    
}
/** 转换播放时间和总时间的方法 */
-(NSString *)timeToStringWithTimeInterval:(NSTimeInterval)interval;
{
    NSInteger Min = interval / 60;
    NSInteger Sec = (NSInteger)interval % 60;
    NSString *intervalString = [NSString stringWithFormat:@"%02ld:%02ld",Min,Sec];
    return intervalString;
}
/** 移除slider定时器 */
-(void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (IBAction)starOrStopBUtton:(UIButton *)sender {
    // 播放状态按钮selected为YES,暂停状态selected为NO。
    sender.selected = !sender.selected;
    if (!sender.selected) {
        self.toolView.alpha = 1;
        [self removeShowTime];
        [self.player pause];
        [self removeProgressTimer];
    }else{
        [self addShowTime];
        [self.player play];
        [self addProgressTimer];
    }

}



- (IBAction)fullScreen:(UIButton *)sender {
    
    
}

- (IBAction)valueChange:(UISlider *)sender {
    // 计算slider拖动的点对应的播放时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * sender.value;
    self.playingTimeLable.text = [self timeToStringWithTimeInterval:currentTime];

    
    
}
/** slider拖动和点击事件 */
- (IBAction)slideTouchDown:(id)sender {
    
    // 按下去 移除监听器
    [self removeProgressTimer];
    [self removeShowTime];

}

- (IBAction)slideTouchInside:(UISlider *)sender {

    [self addProgressTimer];
    //计算当前slider拖动对应的播放时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * sender.value;
    // 播放移动到当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
   
    [self addShowTime];
    if (self.lastProgress < self.progress.progress) {
        //继续播放
        self.starOrStopVideo.selected = NO;
        [self removeShowTime];
      
        [self removeProgressTimer];
        [self starOrStopBUtton:self.starOrStopVideo];
    }

    
}

- (IBAction)replay:(id)sender {
    
    [self starOrStopBUtton:self.starOrStopVideo];
    self.videoSlider.value = 0;
    [self slideTouchInside:self.videoSlider];
    self.converView.hidden = YES;
     [self starOrStopBUtton:self.starOrStopVideo];

}
- (IBAction)failReplayButton:(id)sender {

    // imageView上添加playerLayer
    if (self.delegate) {
        [self.delegate playerFailuretoreplay:self];
        [self replay:nil];
        LGLog(@"重新播放");
    }
   
    
    

}
- (void)removeFromSuperview{
    
    [super removeFromSuperview];
    [self.player.currentItem cancelPendingSeeks];
    [self.player.currentItem.asset cancelLoading];
    [self removeShowTime];
    [self removeProgressTimer];
    self.progressTimer = nil;
  
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.playerItem removeObserver:self forKeyPath:@"status"];

}

- (IBAction)fullViewBtnClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [self videoplayViewSwitchOrientation:sender.selected];
    
}

/** 弹出全屏播放器 */
- (void)videoplayViewSwitchOrientation:(BOOL)isFull
{
 
    if (isFull) {
        [self.contrainerViewController presentViewController:self.fullVc animated:NO completion:^{
            [self.fullVc.view addSubview:self];
            self.center = self.fullVc.view.center;
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = self.fullVc.view.bounds;
            } completion:nil];
        }];
    } else {
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            [self.contrainerView addSubview:self];
            
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = self.contrainerView.bounds;
            } completion:nil];
        }];
    }
}


#pragma mark - 懒加载代码

- (LGFullController *)fullVc{
    
    if (_fullVc == nil) {
        _fullVc = [[LGFullController alloc] init];
    }
    return _fullVc;
    
}


@end
