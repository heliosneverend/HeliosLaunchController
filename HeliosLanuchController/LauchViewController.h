//
//  LauchViewController.h
//  HeliosLanuchController
//
//  Created by beyo-zhaoyf on 2017/7/31.
//  Copyright © 2017年 beyo-zhaoyf. All rights reserved.
//

#import "ViewController.h"
#import "LauchModel.h"
/*
 ** 依次本地 广告 视频
 */
typedef enum :NSInteger {
    LauchTypeLocal,
    LauchTypeAdvert,
    LauchTypeVideo
}LauchType;
/*
 **视频来源 本地 net
 */
typedef enum :NSInteger {
    VidoTypeLocal,
    VidoTypeNet
}VidoType;
@interface LauchViewController : ViewController
@property (nonatomic, strong)LauchModel *model;
@property (nonatomic, assign)BOOL isAd;
@property (nonatomic, assign)BOOL isRepeat;
@property (nonatomic, assign)float volume;
@property (nonatomic, assign)VidoType videoType;

- (instancetype )initWithRootViewController:(UIViewController *)rootVC andType:(LauchType )type;
@end
