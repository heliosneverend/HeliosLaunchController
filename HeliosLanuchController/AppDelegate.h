//
//  AppDelegate.h
//  HeliosLanuchController
//
//  Created by beyo-zhaoyf on 2017/7/31.
//  Copyright © 2017年 beyo-zhaoyf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LauchModel.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)tapInAdvDetail:(id)vc andModel:(LauchModel *)itemModel ;

@end

