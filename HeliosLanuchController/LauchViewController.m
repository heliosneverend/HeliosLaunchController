//
//  LauchViewController.m
//  HeliosLanuchController
//
//  Created by beyo-zhaoyf on 2017/7/31.
//  Copyright © 2017年 beyo-zhaoyf. All rights reserved.
//

#import "LauchViewController.h"
#import "ADViewController.h"

#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
@interface LauchViewController ()
@property (nonatomic,assign)LauchType type;
@property (nonatomic,strong)UIViewController *rootVC;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)NSInteger lastTime;
/*
 **关闭定时器 点击跳过  时间结束 点击广告
 */
@property (nonatomic,assign)BOOL isCloseTimer;
@property (nonatomic,strong)UIImageView *imageView;
//跳过
@property (nonatomic,strong)UIButton *skitBtn;
@property (nonatomic,strong)MPMoviePlayerController *player;
//进入应用
@property (nonatomic,strong)UIButton *enterBtn;
@end


@implementation LauchViewController
- (instancetype )initWithRootViewController:(UIViewController *)rootVC andType:(LauchType )type {
    if(self = [super init]){
        self.rootVC = rootVC;
        self.type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor whiteColor];
    // 设置的倒计时的值赋值
    self.lastTime =self.model.maxTime;
    
    self.imageView.frame =[UIScreen mainScreen].bounds;
    self.skitBtn.frame =CGRectMake(self.view.frame.size.width - 90, 20, 80, 30);
    [self loadLauchImageView];
}

- (void)loadLauchImageView {
    switch (self.type) {
        case LauchTypeLocal:
            // 加载本地图片
            [self creatLocalImages];
            break;
        case LauchTypeAdvert:
            // 加载广告或者网络启动页
            [self creatAdImages];
            break;
            // 加载本地视频
        case LauchTypeVideo:
            [self creatLocalVideos];
            break;
            
        default:
            NSLog(@"未知方式加载");
            break;
    }

}
- (void)creatLocalImages {
    if (self.model.launchUrl.length) {
        self.imageView.image =[UIImage imageNamed:self.model.launchUrl];
        self.timer =[NSTimer scheduledTimerWithTimeInterval:self.model.maxTime target:self selector:@selector(removeTimer:) userInfo:nil repeats:NO];
        [self.view addSubview:self.imageView];
        
    }
}
- (void)creatAdImages {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.model.launchUrl] placeholderImage:[UIImage imageNamed:@"LaunchImg@2x.png"]];
    [self.view addSubview:self.imageView];
    
    if (self.isAd) {// 广告
        self.imageView.userInteractionEnabled =YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(comeInAdvertDetail:)];
        [self.imageView addGestureRecognizer:tap];
        
        // 广告的倒计时标志的Button
        [self.imageView addSubview:self.skitBtn];
        
        if (!self.isCloseTimer) { // 未关闭定时器
            self.timer =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(continueTimer:) userInfo:nil repeats:YES];
        }
        
    }else { //非广告为网络图片
        self.imageView.userInteractionEnabled =NO;
        self.timer =[NSTimer scheduledTimerWithTimeInterval:self.model.maxTime target:self selector:@selector(removeTimer:) userInfo:nil repeats:NO];
    }

}
- (void)creatLocalVideos {
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.model.launchUrl.length) {
        
        // 本地视频播放用 fileURLWithPath转换url切记，就爬了这个坑
        self.player = [[MPMoviePlayerController alloc] initWithContentURL:[self giveUserUrl]];
        [self.view addSubview:self.player.view];
        self.player.shouldAutoplay = YES;
        [self.player setControlStyle:MPMovieControlStyleNone];
        self.player.repeatMode = MPMovieRepeatModeNone;
        
        self.player.view.frame =[UIScreen mainScreen].bounds;
        
        self.player.view.alpha = 0;
        // 视频的转换
        [UIView animateWithDuration:3 animations:^{
            self.player.view.alpha = 1;
            [self.player prepareToPlay];
        }];
        
        // 添加播放完毕之后的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayFinish) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        
        [self.player.view addSubview:self.enterBtn];
        [UIView animateWithDuration:3.0 animations:^{
            self.enterBtn.alpha = 1.0;
        }];
        
    }

}
#pragma mark - NSNotificationCenter
- (void)videoPlayFinish
{
    MPMoviePlaybackState playbackState = [self.player playbackState];
    if (playbackState == MPMoviePlaybackStateStopped || playbackState == MPMoviePlaybackStatePaused) {
        if (self.isRepeat) { // 重复播放
            [self.player play];
            
        }else { // 播放完毕跳入主界面
            [self enterButtonClick:nil];
        }
    }
}

-(NSURL *)giveUserUrl {
    return self.videoType == VidoTypeNet ? [NSURL URLWithString:self.model.launchUrl] : [NSURL fileURLWithPath:self.model.launchUrl];
}
// 定时器的运行
-(void)continueTimer:(NSTimer *)timer {
    
    self.lastTime --;
    if(self.lastTime < 0 || self.isCloseTimer){
        [self removeTimer:timer];
        self.isCloseTimer =YES;
    }
    [self.skitBtn setTitle:[NSString stringWithFormat:@"跳过 %ld",self.lastTime] forState:UIControlStateNormal];
    
}

-(void)removeTimer:(NSTimer *)timer {
    
    [self.timer invalidate];
    self.timer =nil;
    
    [self settingRootVC];
}
- (void)settingRootVC{
    self.view.window.rootViewController =self.rootVC;
}
-(void)comeInAdvertDetail:(UITapGestureRecognizer *)gesture {
    
    self.isCloseTimer = YES;

     AppDelegate *delegate =[UIApplication sharedApplication].delegate;
    // 跳到广告详情页
    [delegate tapInAdvDetail:self andModel:self.model];
    
    
}
- (void)enterButtonClick:(UIButton *)btn {
    NSLog(@"进入应用");
    // 停止播放，清除通知
    [self.player stop];
    self.player =nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self settingRootVC];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)skipBtnClick:(UIButton *)button {
    [self removeTimer:nil];
}
#pragma mark - Setter & Getter

-(LauchModel *)model {
    
    if (!_model) {
        _model =[[LauchModel alloc]init];
    }
    return _model;
}
-(UIImageView *)imageView {
    if (!_imageView) {
        _imageView =[[UIImageView alloc]init];
    }
    return _imageView;
    
}
-(UIButton *)skitBtn {
    if (!_skitBtn) {
        _skitBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        _skitBtn.layer.masksToBounds = YES;
        _skitBtn.layer.cornerRadius = 5;
        _skitBtn.backgroundColor = [UIColor colorWithRed:125/256.0 green:125/256.0  blue:125/256.0  alpha:0.5];
        [_skitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skitBtn addTarget:self action:@selector(skipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_skitBtn setTitle:[NSString stringWithFormat:@"跳过 %ld",self.lastTime] forState:UIControlStateNormal];
        
    }
    return _skitBtn;
}

-(UIButton *)enterBtn {
    if (!_enterBtn) {
        //进入按钮
        _enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _enterBtn.frame = CGRectMake(24, [UIScreen mainScreen].bounds.size.height - 32 - 48, [UIScreen mainScreen].bounds.size.width - 48, 48);
        _enterBtn.layer.borderWidth = 1;
        _enterBtn.layer.cornerRadius = 24;
        _enterBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        [_enterBtn setTitle:@"进入应用" forState:UIControlStateNormal];
        _enterBtn.alpha = 0;
        [_enterBtn addTarget:self action:@selector(enterButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enterBtn;
    
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
