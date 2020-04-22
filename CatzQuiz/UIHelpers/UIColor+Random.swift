//
//  UIColor+Random.swift
//  CatzQuiz
//
//  Created by pelikandr on 23.04.2020.
//  Copyright © 2020 pelikandr. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func random() -> UIColor {
        return UIColor.init(red: CGFloat.random(in: 0...0.9), green: CGFloat.random(in: 0...0.9), blue: CGFloat.random(in: 0...0.9), alpha: CGFloat.random(in: 0.5...1))
    }
    
    class func randomLight() -> UIColor {
        let bottom: CGFloat = 0.7
        return UIColor.init(red: CGFloat.random(in: bottom...1), green: CGFloat.random(in: bottom...1), blue: CGFloat.random(in: bottom...1), alpha: 1)
    }
    
    func inverse() -> UIColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: 1)
        }
        return .black
    }
}
