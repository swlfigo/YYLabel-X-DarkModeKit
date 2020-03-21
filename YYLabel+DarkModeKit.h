//
//  YYLabel+DarkModeKit.h
//  GTData
//
//  Created by Sylar on 2020/3/21.
//  Copyright © 2020 com.jin10. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FluentDarkModeKit/FluentDarkModeKit.h>

#import <YYKit/YYKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YYLabel (DarkModeKit)<DMTraitEnvironment>

@property (nonatomic, assign) BOOL isUsingDynamicColor;


+(void)dummy;
@end

NS_ASSUME_NONNULL_END
