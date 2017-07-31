//
//  LauchModel.h
//  HeliosLanuchController
//
//  Created by beyo-zhaoyf on 2017/7/31.
//  Copyright © 2017年 beyo-zhaoyf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LauchModel : NSObject
@property (nonatomic,copy)NSString *launchUrl;
//默认最长时间为3s
@property (nonatomic,assign) NSUInteger maxTime;
@property (nonatomic,copy) NSString *adUrl;
@end
