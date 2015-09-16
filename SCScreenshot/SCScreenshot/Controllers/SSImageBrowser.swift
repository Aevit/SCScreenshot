//
//  SSImageBrowser.swift
//  SCScreenshot
//
//  Created by Aevit on 15/9/16.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

import UIKit
import Photos

protocol SSImageBrowserDelegate {
    func ssImageBrowserDidDeleteAsset(deletedAsset: PHAsset)
}

class SSImageBrowser: SCImageBrowser {
    
    var screenshotCollection: PHAssetCollection!
    var screenshotAsset: PHAsset!
    var ssDelegate: SSImageBrowserDelegate?

    
    override  func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "删除", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("deleteBtnPressed:"))
    }

    override  func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteBtnPressed(sender: UIBarButtonItem) {
        
        if let ssCollection = screenshotCollection {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                let request = PHAssetCollectionChangeRequest(forAssetCollection: self.screenshotCollection)
                request.removeAssets([self.screenshotAsset])
            }, completionHandler: { (success, error) -> Void in
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.ssDelegate?.ssImageBrowserDidDeleteAsset(self.screenshotAsset)
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
            })
        } else {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                PHAssetChangeRequest.deleteAssets([self.screenshotAsset])
            }, completionHandler: { (success, error) -> Void in
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.ssDelegate?.ssImageBrowserDidDeleteAsset(self.screenshotAsset)
                        self.navigationController?.popViewControllerAnimated(true)
                    })
                }
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
