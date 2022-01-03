//
//  UIColor.swift
//  UtilToolKit
//
//  Created by tao on 2016/7/19.
//  Copyright © 2016年 xattacker. All rights reserved.
//

import UIKit


internal extension UIColor
{
    convenience init(decimalRed: Int, green: Int, blue: Int, alpha: CGFloat = 1)
    {
        self.init(red:
        CGFloat(decimalRed) / CGFloat(255),
        green: CGFloat(green) / CGFloat(255),
        blue: CGFloat(blue) / CGFloat(255),
        alpha: alpha)
    }
    
    convenience init(hexString: String)
    {
        let str = hexString.replacingOccurrences(of: "#", with: "")
        
        var int = UInt32()
        if Scanner(string: str).scanHexInt32(&int)
        {
            let a, r, g, b: UInt32
            
            switch str.length
            {
                case 3: // RGB (12-bit)
                    (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
                    break
                
                case 6: // RGB (24-bit)
                    (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
                    break
                
                case 8: // ARGB (32-bit)
                    (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
                    break
                
                default:
                    (a, r, g, b) = (1, 1, 1, 0)
                    break
            }
            
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
        else
        {
            self.init(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }
    
    func getRGBValue(_ red: inout CGFloat, green: inout CGFloat, blue: inout CGFloat, alpha: inout CGFloat)
    {
        let rgb = self.cgColor.components
        let size = self.cgColor.numberOfComponents
        
        if size == 2
        {
            // white
            red = (rgb?[0])!
            green = (rgb?[0])!
            blue = (rgb?[0])!
            
            alpha = (rgb?[1])!
        }
        else
        {
            red = (rgb?[0])!
            green = (rgb?[1])!
            blue = (rgb?[2])!
            
            alpha = (rgb?[3])!
        }
    }
    
    func getRGBValue(_ red: inout CGFloat, green: inout CGFloat, blue: inout CGFloat)
    {
        var alpha = CGFloat(0) // inout parameter could not set default value for nil
        self.getRGBValue(&red, green: &green, blue: &blue, alpha: &alpha)
    }
    
    func getAlphaValue(_ alpha: inout CGFloat)
    {
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        self.getRGBValue(&r, green: &g, blue: &b, alpha: &alpha)
    }
    
    var hexString: String
    {
        get
        {
            var r = CGFloat(0)
            var g = CGFloat(0)
            var b = CGFloat(0)
            var alpha = CGFloat(0)
            self.getRGBValue(&r, green: &g, blue: &b, alpha: &alpha)
            
            return String(format: "#%02X%02X%02X%02X", Int(alpha*255), Int(r*255), Int(g*255), Int(b*255))
        }
    }
}
