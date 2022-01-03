//
//  RegionMark.swift
//  UtilToolKit_Swift
//
//  Created by xattacker on 2017/9/28.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import UIKit
import ObjectMapper


public let REGION_MARK_RADIUS = CGFloat(12.5)


public final class RegionMark: Mappable
{
    public var markId: String?
    public var title: String?
    public var color: UIColor = UIColor.darkGray
    public var position: RegionPoint = RegionPoint()
    
    public weak var belongRegion: PolygonRegion?
    
    public required init()
    {
    }
    
    public required init?(map: Map)
    {
    }
    
    public func isPointInRegion(_ point: CGPoint) -> Bool
    {
        var hit = false
        let size = REGION_MARK_RADIUS*2
        let p = self.position.position
        let tl = CGPoint(x: p.x - size, y: p.y - size)
        let br = CGPoint(x: p.x + size, y: p.y + size)
    
        if point.x >= tl.x && point.x <= br.x &&
           point.y >= tl.y && point.y <= br.y
        {
            hit = true
        }
        
        return hit
    }
    
    public func mapping(map: Map)
    {
        self.markId      <- map["id"]
        self.title       <- map["title"]
        self.color       <- (map["color"], PolygonColorTransform())
        self.position    <- map["position"]
    }
}
