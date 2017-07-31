//
//  LauchModel.m
//  HeliosLanuchController
//
//  Created by beyo-zhaoyf on 2017/7/31.
//  Copyright © 2017年 beyo-zhaoyf. All rights reserved.
//

#import "LauchModel.h"

@implementation LauchModel

- (NSUInteger )maxTime {
    if(!_maxTime){
        _maxTime = 3;
    }
    return _maxTime;
}
@end
