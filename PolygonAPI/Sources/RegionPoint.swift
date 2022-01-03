//
//  RegionPoint.swift
//  UtilToolKit_Swift
//
//  Created by xattacker on 2017/9/28.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import UIKit
import ObjectMapper


public final class RegionPoint: Mappable
{
    public var x: Float = 0
    public var y: Float = 0
    
    public var position: CGPoint
    {
        return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
    }
    
    public required init()
    {
    }
    
    public required init?(map: Map)
    {
    }
    
    public func mapping(map: Map)
    { 
        self.x      <- map["x"]
        self.y      <- map["y"]
    }
}
