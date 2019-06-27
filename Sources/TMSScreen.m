//
//  TMSScreen.m
//  swiftModules
//
//  Created by Temosan on 10/05/2019.
//  Copyright © 2019 Temosan. All rights reserved.
//

#import "TMSScreen.h"



@implementation TMSScreen

+ (CGRect)bounds { return [[UIScreen mainScreen] bounds]; }

+ (ScreenType)type {
    
    CGSize screenSize = [[self class] bounds].size;
    if (screenSize.width > screenSize.height) {
        CGFloat height = screenSize.height;
        screenSize.height = screenSize.width;
        screenSize.width = height;
    }
    
    ScreenType type = ScreenType_notfound;
    switch ((int)screenSize.width) {
        case 320: type = ScreenType_04_0; break;
        case 375:
            switch ((int)screenSize.height) {
                case 667: type = ScreenType_04_7; break;
                case 812: type = ScreenType_05_8; break;
                default: type = ScreenType_05_5; break;
            } break;
        case 414:
            switch ((int)screenSize.height) {
                case 736: type = ScreenType_05_5; break;
                case 896: type = ScreenType_06_1; break;
                default: type = ScreenType_05_5; break;
            } break;
        case 834: type = ScreenType_09_7; break;
        default: type = ScreenType_05_5; break;
    }
    
    return type;
}

+ (BOOL)isNotiScreen {
    
    ScreenType type = [[self class] type];
    switch (type) {
        case ScreenType_05_8:
        case ScreenType_06_1:
            return YES;
            
        default:
            return NO;
    }
}

@end
