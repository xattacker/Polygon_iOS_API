//
//  UIPolygonView.swift
//  UtilToolKit_Swift
//
//  Created by xattacker on 2017/9/28.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import UIKit


public protocol UIPolygonViewDelegate: AnyObject
{
    func onRegionClicked(region: PolygonRegion)
    func onRegionMarkClicked(mark: RegionMark, region: PolygonRegion)
}


@IBDesignable public final class UIPolygonView: UIView
{
    @IBInspectable public var borderColor: UIColor = UIColor.darkGray
    @IBInspectable public var highlightColor: UIColor = UIColor.darkGray.withAlphaComponent(0.5)
    @IBInspectable public var highlightMarkColor: UIColor = UIColor.gray.withAlphaComponent(0.5)
   
    @IBInspectable public var titleColor: UIColor = UIColor.black
    @IBInspectable public var titleFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    public var baseSize: CGSize = CGSize.zero
    {
        didSet
        {
            if !self.baseSize.equalTo(CGSize.zero)
            {
                let rect = self.frame
                var ratio = Float(1)
                let ratio_w = Float(rect.size.width / self.baseSize.width)
                let ratio_h = Float(rect.size.height / self.baseSize.height)
                
                if ratio_w != self.ratioW || ratio_h != self.ratioH
                {
                    self.ratioW = ratio_w
                    self.ratioH = ratio_h
                    ratio = self.getRatio()
                    
                    for region in self.regions
                    {
                        region.scalePoints(ratio)
                    }
                }
            }
        }
    }
    
    @IBInspectable public var fitToCenter: Bool = true
    public weak var delegate: UIPolygonViewDelegate?
    
    private var regions = [PolygonRegion]()
    private weak var clickedRegion: PolygonRegion?
    private weak var clickedMark: RegionMark?
    private var ratioW: Float = 1, ratioH: Float = 1

    public override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews()
    {
        super.layoutSubviews()
        
        self.fitCenter()
    }
    
    public override func draw(_ rect: CGRect)
    {
        super.draw(rect)
 
        if self.regions.count == 0
        {
            return
        }
        
        
        let path = UIBezierPath()
        
        for region in self.regions
        {
            // draw region
            self.drawLine(region, path: path, fill: true, color: region.regionColor)

            
            // draw highlight region
            if let clicked = self.clickedRegion, clicked.regionId == region.regionId
            {
                self.drawLine(clicked, path: path, fill: true, color: self.highlightColor)
            }
            
            
            // draw border line
            self.drawLine(region, path: path, fill: false, color: self.borderColor)
            
            
            // draw title
            if let title = region.titleInfo.title, title.count > 0
            {
                let size = title.sizeWithFont(self.titleFont)
             
                var p = region.titleInfo.position.position
                if p.x < 0 || p.y < 0
                {
                    p = region.getCentral()
                }
                
                let rect = CGRect(x: p.x - size.width/2, y: p.y - size.height/2, width: size.width, height: size.height)

                self.drawString(title, rect: rect, font: self.titleFont, color: self.titleColor)
            }
            
            
            // draw mark
            if region.hasMark
            {
                for mark in region.marks
                {
                    var color: UIColor!
                    
                    if let clicked = self.clickedMark, clicked === mark
                    {
                        color = self.highlightMarkColor
                    }
                    else
                    {
                        color = mark.color
                    }

                    path.removeAllPoints()
                    
                    path.addArc(
                    withCenter: mark.position.position,
                    radius: REGION_MARK_RADIUS,
                    startAngle: 0,
                    endAngle: CGFloat(2 * Double.pi),
                    clockwise: true)

                    path.close()
                    color.setFill()
                    path.fill()
                    
                    
                    if let title = mark.title, title.count > 0
                    {
                        let size = title.sizeWithFont(self.titleFont)
                        let p = mark.position.position
                        let rect = CGRect(x: p.x - size.width/2, y: p.y + REGION_MARK_RADIUS, width: size.width, height: size.height)

                        self.drawString(title, rect: rect, font: self.titleFont, color: color)
                    }
                }
            }
        }
    }

    public func loadMap(_ map: PolygonMap)
    {
        if map.width > 0 && map.height > 0
        {
            self.baseSize = CGSize(width: CGFloat(map.width), height: CGFloat(map.height))
        }
        
        if let color = map.titleColor
        {
            self.titleColor = color
        }
        
        if let color = map.borderColor
        {
            self.borderColor = color
        }
        
        if let color = map.highlightColor
        {
            self.highlightColor = color
        }
        
        if let color = map.highlightMarkColor
        {
            self.highlightMarkColor = color
        }
        
        if map.regions.count > 0
        {
           self.addRegions(map.regions)
        }
    }
    
    public func addRegion(_ region: PolygonRegion)
    {
        if self.ratioW != 1 || self.ratioH != 1
        {
            let ratio = self.getRatio()
            region.scalePoints(ratio)
        }
        
        self.regions.append(region)
        
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
    public func addRegions(_ regions: [PolygonRegion])
    {
        let ratio = self.getRatio()
        
        for region in regions
        {
            if self.ratioW != 1 || self.ratioH != 1
            {
                region.scalePoints(ratio)
            }
            
            self.regions.append(region)
        }
        
        self.setNeedsDisplay()
        self.setNeedsLayout()
    }
    
    public func clearRegions()
    {
        self.regions.removeAll()
        self.setNeedsDisplay()
    }
    
    deinit
    {
        self.regions.removeAll()
    }
}


// Touch Event Handling
extension UIPolygonView
{
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        guard let touch = touches.first else
        {
            return
        }
       
        
        let point = touch.location(in: self)
        
        for region in self.regions
        {
            if region.hasMark
            {
                var hit = false
                
                for mark in region.marks
                {
                    if mark.isPointInRegion(point)
                    {
                        self.clickedMark = mark
                        self.clickedMark?.belongRegion = region
                        hit = true
                        
                        break
                    }
                }
                
                if hit
                {
                    self.setNeedsDisplay()
                    
                    break
                }
            }
            else if region.isPointInRegion(point)
            {
                self.clickedRegion = region
                self.setNeedsDisplay()
                
                break
            }
        }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if let delegate = self.delegate
        {
            if let mark = self.clickedMark
            {
                delegate.onRegionMarkClicked(mark: mark, region: mark.belongRegion!)
            }
            else if let region = self.clickedRegion
            {
                delegate.onRegionClicked(region: region)
            }
        }

        self.resetTouch()
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.resetTouch()
    }
}


internal extension UIPolygonView
{
    private func drawLine(
    _ region: PolygonRegion,
    path: UIBezierPath,
    fill: Bool, // false = stroke
    color: UIColor)
    {
        path.removeAllPoints()
        
        var point = region.points[0].position
        path.move(to: point)
        
        for i in 1 ..< region.points.count
        {
            point = region.points[i].position
            path.addLine(to: point)
        }
        
        path.close()

        if fill
        {
            color.setFill()
            path.fill()
        }
        else
        {
            color.setStroke()
            path.stroke()
        }
    }
    
    private func drawString(_ str: String, rect: CGRect, font: UIFont, color: UIColor)
    {
        let attrs = [
                    NSAttributedString.Key.font: font,
                    NSAttributedString.Key.foregroundColor: color
                    ] as [NSAttributedString.Key : Any]
        
        str.draw(
            with: rect,
            options: .usesLineFragmentOrigin,
            attributes: attrs,
            context: nil)
    }
    
    private func resetTouch()
    {
        self.clickedRegion = nil
        self.clickedMark = nil
        
        self.setNeedsDisplay()
    }
    
    private func getRatio() -> Float
    {
        return self.ratioW > self.ratioH ? self.ratioH : self.ratioW
    }
    
    private func fitCenter()
    {
        if !self.fitToCenter || self.regions.count == 0
        {
            return
        }
        
        
        let offset = self.getCenterOffset()
        if offset.x != 0 || offset.y != 0
        {
            for region in self.regions
            {
                if region.points.count > 0
                {
                    autoreleasepool
                    {
                        var points = [RegionPoint]()
                        points.append(contentsOf: region.points)
                        
                        region.clearPoints()

                        for rp in points
                        {
                            rp.x += offset.x
                            rp.y += offset.y
                            
                            region.points.append(rp)
                        }
                        
                        if region.hasMark
                        {
                            for mark in region.marks
                            {
                                mark.position.x += offset.x
                                mark.position.y += offset.y
                            }
                        }
                    }
                }
                
                if region.titleInfo.position.x >= 0 && region.titleInfo.position.y >= 0
                {
                    region.titleInfo.position.x += offset.x
                    region.titleInfo.position.y += offset.y
                }
            }
        }
    }
    
    private func getCenterOffset() -> (x: Float, y: Float)
    {
        let size = self.frame.size
        var minX = Float(size.width), maxX = Float(0), minY = Float(size.height), maxY = Float(0)
        
        for region in self.regions
        {
            for point in region.points
            {
                if minX > point.x
                {
                    minX = point.x
                }
                else if maxX < point.x
                {
                    maxX = point.x
                }

                if minY > point.y
                {
                    minY = point.y
                }
                else if maxY < point.y
                {
                    maxY = point.y
                }
            }
        }
        
        let offset_x = Float(size.width/2) - ((maxX + minX)/2)
        let offset_y = Float(size.height/2) - ((maxY + minY)/2)
        
        return (offset_x, offset_y)
    }
}
