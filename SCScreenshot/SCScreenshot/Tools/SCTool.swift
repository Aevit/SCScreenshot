//
//  SCTool.swift
//  SCScreenshot
//
//  Created by Aevit on 15/8/25.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

import UIKit

public class SCTool: NSObject {
    public class func log(message: String, function: String = __FUNCTION__) {
        #if DEBUG
//            print("\(function): \(message)", appendNewline: true)
            println("\(function): \(message)\n")
        #endif
    }
    
    // Create a random dummy image.
    public class func getARandomImageWithColor(size: CGSize, color: UIColor) -> UIImage {
        
        let rect: CGRect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        color.setFill()
        UIRectFillUsingBlendMode(rect, kCGBlendModeNormal)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public class func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
}
