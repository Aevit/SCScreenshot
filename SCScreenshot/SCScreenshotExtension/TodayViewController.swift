//
//  TodayViewController.swift
//  SCScreenshotExtension
//
//  Created by Aevit on 15/8/19.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

import UIKit
import NotificationCenter
import ScreenShotManagerKit
import Photos

class TodayViewController: UIViewController, NCWidgetProviding {
    
    private let imageTag = 100
    @IBOutlet weak private var numLbl: UILabel!
    @IBOutlet weak private var loadingActView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        self.loadingActView.alpha = 1
        loadingActView.startAnimating()
        
        ScreenshotManager.go(4, completeBlock: { (changedAssets, allAssets, willShowAssets) -> Void in
            
            SCTool.log("new: \(changedAssets.count), all: \(changedAssets.count + allAssets.count)")
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.loadingActView.stopAnimating()
                self.loadingActView.alpha = 0
            })
            
            for (var i = 0; i < willShowAssets.count; i++) {
                let imageBtn = self.view.viewWithTag(self.imageTag + i) as! UIButton
                let theAsset = willShowAssets[i]
                SCPhotoTool.requestAImage(theAsset, size: CGSizeMake(100, 176), didRequestAImage: { (aImage, info) -> Void in
                    imageBtn.setBackgroundImage(aImage, forState: UIControlState.Normal)
                    imageBtn.hidden = false
                })
            }
            
            var str:String = "总共: \(changedAssets.count + allAssets.count)张图片"
            if changedAssets.count > 0 {
                str += ", 比上次增加: \(changedAssets.count)张"
            }
            self.numLbl.text = str;
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    @IBAction private func openBtnPressed(sender: AnyObject!) {
        extensionContext?.openURL(NSURL(string: "scscreenshot0413://open")!, completionHandler: { (success) -> Void in
            // opened
        })
    }
}
