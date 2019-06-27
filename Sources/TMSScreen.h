//
//  TMSScreen.h
//  swiftModules
//
//  Created by Temosan on 10/05/2019.
//  Copyright © 2019 Temosan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ScreenType_notfound,   //
    ScreenType_04_0,    // iPhone SE
    ScreenType_04_7,    // iPhone 8
    ScreenType_05_5,    // iPhone 8 Plus
    ScreenType_05_8,    // iPhone X
    ScreenType_06_1,    // iPhone Xs Max, iPhone XR
    ScreenType_07_9,    // iPad mini
    ScreenType_09_7,    // iPad Pro, iPad
    ScreenType_10_9,    // iPad Pro
    ScreenType_11_0,    // iPad Pro
    ScreenType_12_9,    // iPad Pro 12.9
} ScreenType;

@interface TMSScreen: NSObject

+ (CGRect)bounds;
+ (ScreenType)type;

@end
