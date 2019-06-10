/*
String.swift
Created by William Falcon on 2/15/15.

The MIT License (MIT)

Copyright (c) 2015 William Falcon
will@hacstudios.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import Foundation
import UIKit


/*
String for swift provides many of the String API convenience methods from javascript (and some from python).
*/
extension String
{
    /**
    Returns length of the string
    */
    var length: Int
    {
        get
        {
            return self.count
        }
    }
    
    //MARK: Subscripting
    /**
    Returns char at an index
    Example: string[0] == "a"
    */
    subscript (idx: Int) -> Character
    {
        return self[index(startIndex, offsetBy: idx)]
    }
    
    /**
    Returns string at an index
    Example: string[0] == "a"
    */
    subscript (index: Int) -> String
    {
        return String(self[index])
    }

    /**
    Returns string in a range
    Example: string[0...2] == "abc"
    */
    subscript (range: Range<Int>) -> String
    {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(self.startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }
    
    //MARK: - Searching
    /**
    Searches a string for a match against a regular expression, and returns the matches
    */
    func matchesForRegex(_ regex: String) -> [String]
    {
        var results : [String] = []
        let regex = try? NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
        
        if let matches = regex?.matches(in: self, options: [], range: NSMakeRange(0, self.length))
        {
            for m in matches
            {
                let match = self[m.range.location..<m.range.location+m.range.length]
                results.append(match)
            }
        }
        
        return results
    }

    /**
    Returns true if string contains input string
    */
    func contains(_ s: String) -> Bool
    {
        return (self.range(of: s) != nil) ? true : false
    }
    
    /**
    Returns the character at the specified index (position)
    */
    func charAt(_ index:Int?) -> String?
    {
        var result : String?
        
        if let i = index
        {
            result = String(self[i])
        }
        
        return result
    }
    
    //MARK: - Indexing
    /**
    Returns the position of the first found occurrence of a specified value in a string
    */
    func indexOf(_ string: String?) -> Int?
    {
        var result: Int?
        
        if let string = string,
           let range = self.range(of: string)
        {
            result = self.distance(from: self.startIndex, to: range.lowerBound)
        }
        
        return result
    }
    
    func indexOf(_ target: String, startIndex: Int) -> Int
    {
        let startRange = self.index(self.startIndex, offsetBy: startIndex)
        let temp: Range<String.Index> = startRange ..< self.endIndex

        if let range = self.range(of: target, options: NSString.CompareOptions.literal, range: temp)
        {
            return self.distance(from: self.startIndex, to: range.lowerBound)
        }
        else
        {
            return -1
        }
    }
    
    func lastIndexOf(_ target: String) -> Int?
    {
        var index = -1
        var stepIndex = self.indexOf(target)
        
        while let step = stepIndex, step > -1
        {
            index = step
            if step + target.length < self.length
            {
                stepIndex = indexOf(target, startIndex: step + target.length)
            }
            else
            {
                stepIndex = -1
            }
        }
        
        return index
    }
    
    
    //MARK: - Substrings
    /**
    Extracts the characters from a string, after a specified index
    */
    func substringFromIndex(_ index: Int) -> String?
    {
        var subString : String?
        
        if index <= self.length && index >= 0
        {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            subString = String(self[startIndex...])
        }
        
        return subString
    }
    
    /**
    Extracts the characters from a string, before a specified index
    */
    func substringToIndex(_ index: Int) -> String?
    {
        var subString : String?
        
        if index <= self.length && index >= 0
        {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            subString = String(self[...endIndex])
        }
        
        return subString
    }
    
    /**
    Extracts a part of a string and returns a new string
    */
    func substringFromIndex(_ index: Int, toIndex to: Int) -> String
    {
       return self[Range(index...to)]
    }
    
    /**
    Extracts a part of a string and returns a new string starting at an index and
    going for the length requested
    */
    func substringFromIndex(_ index:Int, length:Int) -> String
    {
        return self[Range(index...(index+length - 1))]
    }
    
    /**
    Extracts a part of a string and returns a new string
    */
    func slice(_ start: Int, end: Int) -> String
    {
        return self[Range(start...end)]
    }
    
    /**
    Splits a string into an array of substrings
    */
    func splitOn(_ separator: String) -> [String]
    {
        let results = self.components(separatedBy: separator)
        return results
    }
    //MARK: - Formatting
    
    /**
    Searches a string for a specified value, or a regular expression, and returns a new string where the specified values are replaced. Can take in an regular expression
    */
    func replaceAll(_ target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /**
    Removes whitespace from both ends of a string
    */
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    /**
    Removes the last char of the string
    */
    func trimLastChar() -> String
    {
        if self.length > 0
        {
            return self[0 ..< self.length-1]
        }
        else
        {
            return self
        }
    }
    
    /**
    Removes the first char of the string
    */
    func trimFirstChar() -> String
    {
        if self.length > 0
        {
            return self[1 ..< self.length]
        }
        else
        {
            return self
        }
    }
    
    //MARK: - Arranging
    /**
    Joins two or more strings, and returns a new joined string
    */
    func concat(_ string: String) -> String?
    {
        return self+string
    }
    
    /**
    Reverses the string
    */
    func reverse() -> String
    {
        var reversed = ""
        
        for i in (0 ..< self.length).reversed()
        {
            let char = String(self[i])
            reversed += char
        }
        
        return reversed
    }
    
    /**
    Separates string into an array of characters
    */
    func toCharArray() -> [Character]
    {
        var chars = [Character]()
        
        for i in 0 ..< self.count
        {
            chars.append(self[i])
        }
        
        return chars
    }
    
    /// Localized string
    static func localizedString(_ key:String) -> String
    {
        let localized = NSLocalizedString(key, comment: "")
        return localized
    }
    
    public init(localizedKey: String)
    {
        self = NSLocalizedString(localizedKey, comment: "")
    }
    
    public func localizedString(_ parameters: String...) -> String
    {
        var value = String.localizedString(self)
        
        if parameters.count > 0
        {
            var count = 0
            var temp = String(value)
            
            for para in parameters
            {
                let replace = String(format: "[%d]", count)
                if let index = temp.range(of: replace)
                {
                    temp.replaceSubrange(index, with: para)
                }
                
                count += 1
            }
            
            value = temp
        }
        
        return value
    }
    
    //MARK: - Sizing
    /// returns size of string with a font
    func sizeWithFont(_ font:UIFont) -> CGSize
    {
        let label = UILabel()
        label.text = self
        label.font = font
        label.sizeToFit()
        
        return label.frame.size
    }
    
    //MARK: - Sizing
    /// returns size of string with a font
    func sizeWithFont(_ font:UIFont, maxWidth width:CGFloat) -> CGSize
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let requiredSize = label.sizeThatFits(maxSize)
        
        return requiredSize
    }

    // file path related function
    var pathExtension: String?
    {
        return URL(fileURLWithPath: self).pathExtension
    }
    
    var lastPathComponent: String?
    {
        return URL(fileURLWithPath: self).lastPathComponent
    }
    
    public func stringByAppendingPathComponent(_ pathComponent: String) -> String?
    {
        return URL(fileURLWithPath: self).appendingPathComponent(pathComponent).path
    }
    
    var stringByDeletingLastPathComponent: String?
    {
        return NSURL(fileURLWithPath: self).deletingLastPathComponent?.path
    }
    
    var stringByDeletingPathExtension: String?
    {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.path
    }
    
    public func intValue() -> Int
    {
        if let i = Int(self)
        {
            return i
        }
        else
        {
            // Handle a bad number
            print("Error converting \"" + self + "\" to Int")
            return 0
        }
    }
    
    public func longValue() -> Int64
    {
        if let l = Int64(self)
        {
            return l
        }
        else
        {
            // Handle a bad number
            print("Error converting \"" + self + "\" to Int64")
            return 0
        }
    }
    
    public func floatValue() -> Float
    {
        if let f = Float(self)
        {
            return f
        }
        else
        {
            // Handle a bad number
            print("Error converting \"" + self + "\" to Float")
            return 0.0
        }
    }
    
    public func doubleValue() -> Double
    {
        if let d = Double(self)
        {
            return d
        }
        else
        {
            // Handle a bad number
            print("Error converting \"" + self + "\" to Double")
            return 0.0
        }
    }
}


extension Int
{
    public func toString() -> String
    {
        return String(self)
    }
}


extension Int8
{
    public func toString() -> String
    {
        return String(self)
    }
}


extension Int16
{
    public func toString() -> String
    {
        return String(self)
    }
}


extension Int32
{
    public func toString() -> String
    {
        return String(self)
    }
}

extension Int64
{
    public func toString() -> String
    {
        return String(self)
    }
}


extension Float
{
    public func toString() -> String
    {
        return String(self)
    }
}


extension Double
{
    public func toString() -> String
    {
        return String(self)
    }
}
