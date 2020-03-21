//
//  YYLabel+DarkModeKit.m
//  GTData
//
//  Created by Sylar on 2020/3/21.
//  Copyright © 2020 com.jin10. All rights reserved.
//

#import "YYLabel+DarkModeKit.h"

#import <UIKit/UIKit.h>

#import "GTData-Swift.h"

#import <FluentDarkModeKit/FluentDarkModeKit.h>
@implementation YYLabel (DarkModeKit)
static const void *kHasDMColor = @"kHasDMColor";
static void (*dm_original_setTextLayout)(YYLabel *, SEL, YYTextLayout *);

static void dm_setTextLayout(YYLabel *self, SEL _cmd, YYTextLayout *textLayout) {
    
    if (textLayout) {
        NSMutableAttributedString *innerLayoutStr = [textLayout valueForKey:@"text"];
        if (innerLayoutStr) {
            [innerLayoutStr enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, innerLayoutStr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                
                if ([value isKindOfClass:NSClassFromString(@"DMDynamicColor")]) {
                    self.isUsingDynamicColor = YES;
                    *stop = YES;
                }
                
            }];
        }
    }
    
    dm_original_setTextLayout(self, _cmd, textLayout);
}

static void (*dm_original_setAttributedText)(YYLabel *, SEL, NSAttributedString *);

static void dm_setAttributedText(YYLabel *self, SEL _cmd, NSAttributedString *attr) {
    if (attr) {
        [attr enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, attr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            
            if ([value isKindOfClass:NSClassFromString(@"DMDynamicColor")]) {
                self.isUsingDynamicColor = YES;
                *stop = YES;
            }
            
        }];
    }
    dm_original_setAttributedText(self, _cmd, attr);
}

+ (void)dummy{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method setAttriMethod = class_getInstanceMethod(self, @selector(setAttributedText:));
        dm_original_setAttributedText = (void *)method_getImplementation(setAttriMethod);
        method_setImplementation(setAttriMethod, (IMP)dm_setAttributedText);
        
        
        Method setTextLayoutMethod = class_getInstanceMethod(self, @selector(setTextLayout:));
        dm_original_setTextLayout = (void *)method_getImplementation(setTextLayoutMethod);
        method_setImplementation(setTextLayoutMethod, (IMP)dm_setTextLayout);
    });
}

- (BOOL)isUsingDynamicColor{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsUsingDynamicColor:(BOOL)isUsingDynamicColor{
    objc_setAssociatedObject(self,
                             @selector(isUsingDynamicColor),
                             [NSNumber numberWithBool:isUsingDynamicColor],
                             OBJC_ASSOCIATION_ASSIGN);
}

- (void)dmTraitCollectionDidChange:(DMTraitCollection *)previousTraitCollection{
    if (previousTraitCollection.userInterfaceStyle != [DMTraitCollection currentTraitCollection].userInterfaceStyle) {
        [self updateDynamicColorInAttributedText];
    }
    [super dmTraitCollectionDidChange:previousTraitCollection];
}

-(void)updateDynamicColorInAttributedText{
    
    if (self.isUsingDynamicColor) {
        NSMutableAttributedString *innerStr = [self valueForKey:@"_innerText"];
        __block NSMutableAttributedString *tempStr = innerStr.mutableCopy;
        
        [innerStr enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, innerStr.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {

            if ([value isKindOfClass:NSClassFromString(@"DMDynamicColor")]) {

                [tempStr addAttribute:NSForegroundColorAttributeName value:value range:range];

            }
            
        }];
        [self setValue:tempStr forKey:@"_innerText"];

        if ([self respondsToSelector:@selector(_setLayoutNeedUpdate)]) {
            [self performSelector:@selector(_setLayoutNeedUpdate)];
        }

    }
}
@end
