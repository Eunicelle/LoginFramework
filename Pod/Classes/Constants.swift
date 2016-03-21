//
//  Constants.swift
//  Pods
//
//  Created by 王海晨 on 16/3/21.
//
//

import UIKit

struct Constants {
    struct Color {
        static var prompt: UIColor {
            return UIColor.redColor()
        }
        static var empty: UIColor {
            return UIColor.blueColor()
        }
    }
    
    struct Layout {
        static var onePixel: CGFloat {
            return 1.0 / UIScreen.mainScreen().scale
        }
    }
    
}
