//
//  SSListViewController.swift
//  SCScreenshot
//
//  Created by Aevit on 15/9/16.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

import UIKit
import Photos
import ScreenShotManagerKit

class SSListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SSImageBrowserDelegate {
    
    var photoCollectionView: UICollectionView?
    let assetCellId: String = "assetCellId"
    var assets: Array<PHAsset> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "screenshots"
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.translucent = false
        
        self.addCollectionView()
        
        ScreenshotManager.go(4, completeBlock: { (changedAssets, allAssets, willShowAssets) -> Void in
            self.assets = allAssets
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                photoCollectionView?.reloadData()
            })
        })
    }
    
    func addCollectionView() {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.blackColor()
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.registerClass(SSPhotoCell.classForCoder(), forCellWithReuseIdentifier: assetCellId)
        photoCollectionView = collectionView
        self.view.addSubview(collectionView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: SSImageBrowserDelegate
    func ssImageBrowserDidDeleteAsset(deletedAsset: PHAsset) {
//        assets()
        assets.removeAtIndex(assets.indexOf(deletedAsset)!)
        photoCollectionView?.reloadData()
    }
    
    // MARK: collectionview
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: SSPhotoCell = collectionView.dequeueReusableCellWithReuseIdentifier(assetCellId, forIndexPath: indexPath) as! SSPhotoCell
        cell.backgroundColor = UIColor.blackColor()
        cell.fillData(assets[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((self.view.frame.size.width - 5) / 4, (self.view.frame.size.width - 5) / 4)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        SCPhotoTool.requestAImage(assets[indexPath.row], size: CGSizeZero, didRequestAImage: { (resultImage, info) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let browser: SSImageBrowser = SSImageBrowser()
                browser.image = resultImage
                browser.screenshotAsset = self.assets[indexPath.row]
                browser.ssDelegate = self
                self.navigationController?.pushViewController(browser, animated: true)
            })
        })
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
