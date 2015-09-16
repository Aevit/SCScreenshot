//
//  ScreenshotManager.swift
//  SCScreenshot
//
//  Created by Aevit on 15/8/31.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

import UIKit
import Photos

public class ScreenshotManager: NSObject, PHPhotoLibraryChangeObserver {
    
    public func photoLibraryDidChange(changeInstance: PHChange!) {
        
    }
    
    deinit {
//        PHPhotoLibrary.sharedPhotoLibrary().unregisterChangeObserver(self)
    }
    
    public class func go(willShowAssetNum: Int, completeBlock: ((changedAssets: Array<PHAsset>, allAssets: Array<PHAsset>, willShowAssets: Array<PHAsset>) -> Void)?) {
        let screenshotCollectionTitle = "screenshots"
        
        // 通过title获取collection，为nil则获取camera roll
//        var results = SCPhotoTool.fetchResultWithAssetCollectionTitle(nil, fetchOptions: nil)
//        SCTool.log("count: \(results?.count)")
        
        // 获取UIImage对象
//        if let lastAsset: PHAsset = results?.lastObject as? PHAsset {
//            PHImageManager.defaultManager().requestImageForAsset(lastAsset, targetSize: CGSizeMake(1024, 1024), contentMode: PHImageContentMode.AspectFill, options: nil,
//                resultHandler: { (aImage, info) -> Void in
//                    let imgView: UIImageView = UIImageView(image: aImage)
//                    imgView.center = self.view.center
//                    self.view.addSubview(imgView)
//            })
//        }
        
        // 往相册时添加图片，coolection为空时则只添加到camera roll
//        let collection = SCPhotoTool.getAssetCollectionWithTitle("not_exist_album")
//        let color = UIColor(red: (CGFloat)(arc4random() % 255) / 255.0, green: (CGFloat)(arc4random() % 255) / 255.0, blue: (CGFloat)(arc4random() % 255) / 255.0, alpha: 1.0)
//        SCPhotoTool.addImage(SCTool.getARandomImageWithColor(CGSizeMake(500, 500), color: color), aAssetCollection: collection, aFetchResult: nil) { (success, error) -> Void in
//            SCTool.log("success")
//        }
        
        
        SCPhotoTool.createCollectionWithTitle(screenshotCollectionTitle, didGetCollectionBlock: { (assetCollection) -> Void in
            SCTool.log("screenshots collection id: \(assetCollection.localIdentifier)")
            self.addAssetToScreenshotCollection(assetCollection, willShowAssetNum: willShowAssetNum, completeBlock: completeBlock)
        })
    }
    
    public class func addAssetToScreenshotCollection(assetCollection: PHAssetCollection, willShowAssetNum: Int, completeBlock: ((changedAssets: Array<PHAsset>, allAssets: Array<PHAsset>, willShowAssets: Array<PHAsset>) -> Void)?) {
        
        let lengthArr: [Int] = [320, 640, 750, 1080, 1242, 480, 960, 1136, 1334, 1920, 2208, 810, 1440]
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "pixelWidth IN %@ && pixelHeight IN %@", lengthArr, lengthArr)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)] // asscending's default value is true
        let results = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        
        // 1. get assetIds which has in the screenshots collection
        let inScreenshotCollectionResult = PHAsset.fetchAssetsInAssetCollection(assetCollection, options: fetchOptions)
        var inScreenshotCollectionAssetIds: [String] = []
        var allScreenshotAssets: [PHAsset] = []
        inScreenshotCollectionResult.enumerateObjectsUsingBlock { (obj, idx, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let aAsset: PHAsset = obj as! PHAsset
            allScreenshotAssets.append(aAsset)
            inScreenshotCollectionAssetIds.append(aAsset.localIdentifier)
        }
        
        // 2. get assets which has not in the screenshots collection
        var shouldChangedAssets: [PHAsset] = []
        var willShowAssets: [PHAsset] = []
        results.enumerateObjectsUsingBlock({(obj: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            let aAsset: PHAsset = obj as! PHAsset
            if ((contains(inScreenshotCollectionAssetIds, aAsset.localIdentifier)) == false) {
                SCTool.log("assetId: \(aAsset.localIdentifier),\n w: \(aAsset.pixelWidth), h: \(aAsset.pixelHeight)\n")
                shouldChangedAssets.append(aAsset)
            }
            if idx < willShowAssetNum {
                willShowAssets.append(aAsset)
            }
        })
        
        SCTool.log("all: \(results.count), screenshots: \(inScreenshotCollectionResult.count), new: \(shouldChangedAssets.count)")
        
        // 3. save new photos to screenshots
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            let collectionChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: assetCollection, assets: nil)
            
//            collectionChangeRequest.removeAssets(results) // for test, only remove from the collection
            collectionChangeRequest.addAssets(shouldChangedAssets)
            
            }, completionHandler: { (success, error) -> Void in
                SCTool.log("finished add: \(success ? shouldChangedAssets.count: error) photos")
                if let block = completeBlock {
                    block(changedAssets: shouldChangedAssets, allAssets: allScreenshotAssets, willShowAssets: willShowAssets)
//                    block(changedAssets: shouldChangedAssets, allNum: inScreenshotCollectionResult.count + shouldChangedAssets.count, willShowAssets: willShowAssets)
                }
        })
    }
}
