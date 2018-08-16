//
//  Extensions.swift
//  AnimatedProgressBars
//
//  Created by Ayman Zeine on 8/16/18.
//  Copyright © 2018 Ayman Zeine. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let bgColor = UIColor.rgb(r: 21, g: 22, b: 23)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 11)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
}
