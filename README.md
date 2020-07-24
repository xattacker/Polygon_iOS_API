# Polygon_iOS_API
an iOS swift Polygon UI View component 
<br><br>
Development Target: iOS 10
<br><br>
Android version API: https://github.com/xattacker/Polygon_Android_API<br>

present a custom defined polygon view: <br>
<img src="/rm_res/cut1.png" alt="screen cut" width="50%" height="50%" align="bottom" /><br><br>

The API could load data from code for json file(json parsing by ObjectMapper https://github.com/Hearst-DD/ObjectMapper)
<br>and supports event callback



# Installation

### Cocoapods
PolygonAPI can be added to your project using CocoaPods 0.36 or later by adding the following line to your Podfile:
```
pod 'ObjectMapper'
pod 'PolygonAPI'
```


### How to use:

```
import PolygonAPI

var polygonView: UIPolygonView!

// load region map from json 
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
```
