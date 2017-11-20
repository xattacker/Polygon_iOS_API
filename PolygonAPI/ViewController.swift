//
//  ViewController.swift
//  PolygonAPI
//
//  Created by xattacker on 2017/11/20.
//  Copyright © 2017年 xattacker. All rights reserved.
//

import UIKit


class ViewController: UIViewController
{
    @IBOutlet private weak var polygonView: UIPolygonView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.polygonView.delegate = self
        
        if let path = Bundle.main.path(forResource: "region", ofType: "json")
        {
            do
            {
                // load map resource from json file
                let json = try String(contentsOfFile: path)
                
                if !json.isEmpty,
                    let map = PolygonMap(JSONString: json)
                {
                    self.polygonView.loadMap(map)
                }
            }
            catch
            {
            }
        }
    }
    
    @IBAction func onButtonAction(sender: Any)
    {
        self.polygonView.clearRegions()
        
        // you could also add map region by code:
        let region = PolygonRegion()
        region.regionColor = UIColor.brown
        region.regionId = "north"
        region.titleInfo.title = "北部"
        region.addPoint(CGPoint(x: 167, y: 103))
        region.addPoint(CGPoint(x: 194, y: 142))
        region.addPoint(CGPoint(x: 251, y: 170))
        region.addPoint(CGPoint(x: 306, y: 173))
        region.addPoint(CGPoint(x: 322, y: 162))
        region.addPoint(CGPoint(x: 314, y: 81))
        region.addPoint(CGPoint(x: 338, y: 56))
        region.addPoint(CGPoint(x: 330, y: 32))
        region.addPoint(CGPoint(x: 291, y: 19))
        region.addPoint(CGPoint(x: 269, y: 2))
        region.addPoint(CGPoint(x: 254, y: 30))
        region.addPoint(CGPoint(x: 192, y: 49))
        
        self.polygonView.addRegion(region)
    }
}


extension ViewController: UIPolygonViewDelegate
{
    func onRegionClicked(region: PolygonRegion)
    {
        print("onRegionClicked")
    }
    
    func onRegionMarkClicked(mark: RegionMark, region: PolygonRegion)
    {
        print("onRegionMarkClicked")
    }
}
