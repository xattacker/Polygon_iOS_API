//
//  RegionPoint.swift
//  UtilToolKit_Swift
//
//  Created by xattacker on 2017/9/28.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import UIKit


public class RegionPoint: MappableObj
{
    public var x: Float = 0
    public var y: Float = 0
    
    public var position: CGPoint
    {
        get
        {
            return CGPoint(x: CGFloat(self.x), y: CGFloat(self.y))
        }
    }
    
    public override func mapping(map: Map)
    {
        super.mapping(map: map)
        
        self.x      <- map["x"]
        self.y      <- map["y"]
    }
}
