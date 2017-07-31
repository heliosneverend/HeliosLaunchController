//
//  AppDelegate.m
//  HeliosLanuchController
//
//  Created by beyo-zhaoyf on 2017/7/31.
//  Copyright © 2017年 beyo-zhaoyf. All rights reserved.
//

#import "AppDelegate.h"
#import "ADViewController.h"
#import "ViewController.h"
#import "LauchViewController.h"
@interface AppDelegate ()
@property(nonatomic,strong)LauchViewController *launchVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    // 确定rootVC，暂定为VC
    ViewController *vc =[[ViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
    
    // 初始化要传递的参数Model
    LauchModel *model =[[LauchModel alloc]init];
    
    // 第1种：加载本地图片
    //  [self initLocalPhotoNormal:itemModel andNav:nav];
    
    //    // 第2.1种：加载网络图片（非广告）
    // [self initNetPhotoNormal:itemModel andNav:nav];
    
    // 第2.2种：加载广告图片
    // [self initADVPhotoNormal:itemModel andNav:nav];
    
    //    // 第3.1种：加载本地视频
    [self initLocalVideoNormal:model andNav:nav];
    
    //    // 第3.2种：加载网络视频
    // [self initNetVideoNormal:itemModel andNav:nav];
    
    // 赋值
    _launchVC.model =model;
    
    self.window.rootViewController =_launchVC;
    return YES;
}
// 第1种：加载本地图片
-(void)initLocalPhotoNormal:(LauchModel *)itemModel andNav:(UINavigationController *)nav {
    _launchVC =[[LauchViewController alloc]initWithRootViewController:nav andType:LauchTypeLocal];
    itemModel.launchUrl =@"LaunchImg@2x.png";
    // 这个参数可以不传，用默认的
    itemModel.maxTime =5;
}

//第2.1种：加载网络图片（非广告）
-(void)initNetPhotoNormal:(LauchModel *)itemModel andNav:(UINavigationController *)nav {
     _launchVC =[[LauchViewController alloc]initWithRootViewController:nav andType:LauchTypeAdvert];
    itemModel.launchUrl =@"http://img1.gamedog.cn/2013/06/03/43-130603140F30.gif";
    // 这2个参数可以不传，用默认的
    itemModel.maxTime =5;
    _launchVC.isAd =NO;
}
//第2.2种：加载广告图片
-(void)initADVPhotoNormal:(LauchModel *)itemModel andNav:(UINavigationController *)nav {
   _launchVC =[[LauchViewController alloc]initWithRootViewController:nav andType:LauchTypeAdvert];
    itemModel.launchUrl =@"http://img1.gamedog.cn/2013/06/03/43-130603140F30.gif";
    // 这2个参数可以不传，用默认的
    itemModel.maxTime =5;
    itemModel.adUrl =@"https://github.com/zxwIsCode";
    // 这个参数必须传，而且必须是yes
    _launchVC.isAd =YES;
}
// 第3.1种：加载本地视频
-(void)initLocalVideoNormal:(LauchModel *)itemModel andNav:(UINavigationController *)nav {
     _launchVC =[[LauchViewController alloc]initWithRootViewController:nav andType:LauchTypeVideo];
    itemModel.launchUrl = [[NSBundle mainBundle] pathForResource:@"BridgeLoop-640p" ofType:@"mp4"];
    _launchVC.videoType =VidoTypeLocal;
    _launchVC.isRepeat =YES;
    _launchVC.volume =0.7;
}
// 第3.2种：加载网络视频
-(void)initNetVideoNormal:(LauchModel *)itemModel andNav:(UINavigationController *)nav {
    _launchVC =[[LauchViewController alloc]initWithRootViewController:nav andType:LauchTypeVideo];
    // 本地文件路径地址
    itemModel.launchUrl = @"http://v1.mukewang.com/57de8272-38a2-4cae-b734-ac55ab528aa8/L.mp4";
    // 这个参数必填，而且必须是Video_Net
    _launchVC.videoType =VidoTypeNet;
    // 播放完毕，是否重复播放还是直接跳到主界面
    _launchVC.isRepeat =NO;
    _launchVC.volume =0.7;
}


// 跳到广告详情页
-(void)tapInAdvDetail:(id)vc andModel:(LauchModel *)itemModel {
    LauchViewController *launchVC =(LauchViewController *)vc;
    
    ADViewController *webVC =[[ADViewController alloc]init];
    webVC.model =itemModel;
    [launchVC presentViewController:webVC animated:YES completion:nil];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
