//
//  PolygonMap.swift
//  PolygonAPI
//
//  Created by xattacker on 2017/9/28.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import UIKit
import ObjectMapper


public final class PolygonMap: Mappable
{
    public var width: Float = 0
    public var height: Float = 0
    
    public var titleColor: UIColor?
    public var borderColor: UIColor?
    public var highlightColor: UIColor?
    public var highlightMarkColor: UIColor?
    
    public var regions: [PolygonRegion] = [PolygonRegion]()
    
    public required init()
    {
    }
    
    public required init?(map: Map)
    {
    }
    
    public func mapping(map: Map)
    {
        self.width                  <- map["width"]
        self.height                 <- map["height"]
        
        let transform = PolygonColorTransform()
        self.titleColor             <- (map["title_color"], transform)
        self.borderColor            <- (map["border_color"], transform)
        self.highlightColor         <- (map["highlight_color"], transform)
        self.highlightMarkColor     <- (map["highlight_mark_color"], transform)
        
        self.regions                <- map["regions"]
    }
}
