//
//  MappableObj.swift
//  UtilToolKit
//
//  Created by xattacker on 2016/5/7.
//  Copyright © 2016年 xattacker. All rights reserved.
//

import ObjectMapper


open class MappableObj: Mappable
{
    public required init()
    {
    }
    
    public required init?(map: Map)
    {
    }
    
    // implement from Mappable, to define json column mapping
    open func mapping(map: Map)
    {
    }
}
