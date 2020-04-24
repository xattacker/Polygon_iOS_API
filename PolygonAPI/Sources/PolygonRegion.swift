//
//  PolygonRegion.swift
//  UtilToolKit_Swift
//
//  Created by xattacker on 2017/9/28.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import UIKit
import ObjectMapper


public final class PolygonRegion: MappableObj
{
    public var regionId: String?
    public var regionColor: UIColor = UIColor.clear
    
    public var titleInfo: RegionTitleInfo = RegionTitleInfo()
    
    public var points: [RegionPoint] = [RegionPoint]()
    public var marks: [RegionMark] = [RegionMark]()
    
    public func addPoint(_ point: CGPoint)
    {
        let rp = RegionPoint()
        rp.x = Float(point.x)
        rp.y = Float(point.y)
        
        self.points.append(rp)
    }
    
    public func clearPoints()
    {
        self.points.removeAll()
    }
    
    public func isPointInRegion(_ point: CGPoint) -> Bool
    {
        var hit = false
        let size = self.points.count
        var p = self.points[0].position
        var minX = Float(p.x), maxX = Float(p.x), minY = Float(p.y), maxY = Float(p.y)
        
        for i in 1 ..< size
        {
            p = self.points[i].position
            minX = fminf(Float(p.x), minX)
            maxX = fmaxf(Float(p.x), maxX)
            minY = fminf(Float(p.y), minY)
            maxY = fmaxf(Float(p.y), maxY)
        }
        
        if Float(point.x) < minX || Float(point.x) > maxX || Float(point.y) < minY || Float(point.y) > maxY
        {
            return false
        }
        
        
        // http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
        var j = size - 1
        for i in 0 ..< size
        {
            let p1 = self.points[i]
            let p2 = self.points[j]
            
            if (p1.y > Float(point.y)) != (p2.y > Float(point.y)) &&
               Float(point.x) < (p2.x - p1.x) * (Float(point.y) - p1.y) / (p2.y - p1.y) + p1.x
            {
                hit = !hit
            }
            
            j = i
        }
        
        return hit
    }

    public func getCentral() -> CGPoint
    {
        let size = self.points.count
        var central_x = Float(0), central_y = Float(0)
        
        for point in self.points
        {
            central_x += point.x
            central_y += point.y
        }
        
        return CGPoint(x: CGFloat(central_x/Float(size)), y: CGFloat(central_y/Float(size)))
    }
    
    public func hasMark() -> Bool
    {
        return self.marks.count > 0
    }
    
    public func scalePoints(_ ratio: Float)
    {
        autoreleasepool
        {
            var points = [RegionPoint]()
            points.append(contentsOf: self.points)
            
            self.clearPoints()
            
            for rp in points
            {
                rp.x *= ratio
                rp.y *= ratio
                
                self.points.append(rp)
            }
            
            if self.hasMark()
            {
                for mark in self.marks
                {
                    mark.position.x *= ratio
                    mark.position.y *= ratio
                }
            }
            
            if self.titleInfo.position.x >= 0 && self.titleInfo.position.y >= 0
            {
                self.titleInfo.position.x *= ratio
                self.titleInfo.position.y *= ratio
            }
        }
    }

    public override func mapping(map: Map)
    {
        super.mapping(map: map)
        
        self.regionId      <- map["id"]
        self.regionColor   <- (map["color"], PolygonColorTransform())
        
        self.titleInfo     <- map["title_info"]
        
        self.points        <- map["points"]
        self.marks         <- map["marks"]
    }
}


public final class RegionTitleInfo: MappableObj
{
    public var title: String?
    public var position: RegionPoint = RegionPoint()

    public override func mapping(map: Map)
    {
        super.mapping(map: map)
        
        self.title      <- map["title"]
        self.position   <- map["position"]
    }
}
