//
//  ViewController.swift
//  SCScreenshot
//
//  Created by Aevit on 15/8/19.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

import UIKit
import ScreenShotManagerKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ScreenshotManager.go(4, completeBlock: { (changedAssets, allAssets, willShowAssets) -> Void in
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

