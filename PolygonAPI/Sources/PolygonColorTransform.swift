//
//  PolygonColorTransform.swift
//  UtilToolKit_Swift
//
//  Created by xattacker on 2017/10/1.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import UIKit
import ObjectMapper


internal final class PolygonColorTransform: TransformType
{
    public typealias Object = UIColor
    public typealias JSON = String
    
    public func transformFromJSON(_ value: Any?) -> UIColor?
    {
        guard let string = value as? String else
        {
            return nil
        }
        
        return UIColor(hexString: string)
    }
    
    public func transformToJSON(_ value: UIColor?) -> String?
    {
        return value?.hexString
    }
}
