//
//  Screen.swift
//  swiftModules
//
//  Created by Temosan on 10/05/2019.
//  Copyright © 2019 Temosan. All rights reserved.
//

import UIKit

public enum ScreenType {
    case notfound   //
    case sc_04_0    // iPhone SE
    case sc_04_7    // iPhone 8
    case sc_05_5    // iPhone 8 Plus
    case sc_05_8    // iPhone X
    case sc_06_1    // iPhone Xs Max, iPhone XR
    case sc_07_9    // iPad mini
    case sc_09_7    // iPad Pro, iPad
    case sc_10_9    // iPad Pro
    case sc_11_0    // iPad Pro
    case sc_12_9    // iPad Pro 12.9
}

public class TMSScreen {
    
    public class var bounds: CGRect { get { return UIScreen.main.bounds } }
    
    private static var _type: ScreenType?
    public class var type: ScreenType  {
        get {
            guard _type == nil else { return self._type! }
            
            var screenSize = UIScreen.main.bounds.size
            if (screenSize.width > screenSize.height) {
                let height = screenSize.height
                screenSize.height = screenSize.width
                screenSize.width = height
            }
            
            let type: ScreenType
            
            switch screenSize.width {
            case 320: type = .sc_04_0
            case 375:
                switch screenSize.height {
                case 667: type = .sc_04_7
                case 812: type = .sc_05_8
                default: type = .sc_05_5
                }
            case 414:
                switch screenSize.height {
                case 736: type = .sc_05_5
                case 896: type = .sc_06_1
                default: type = .sc_05_5
                }
            case 834: type = .sc_09_7
            default: type = .sc_05_5
            }
            
            self._type = type
            
            return type
        }
    }
}
