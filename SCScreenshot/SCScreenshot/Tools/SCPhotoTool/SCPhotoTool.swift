//
//  SCPhotoTool.swift
//  SCScreenshot
//
//  Created by Aevit on 15/8/31.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

import UIKit
import Photos

public class SCPhotoTool: NSObject {
    
    public class func createCollectionWithTitle(collectionTitle: String!, didGetCollectionBlock: ((assetCollection: PHAssetCollection) -> Void)?) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", collectionTitle)
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
//        var collectionFound = false
        
        if let _: AnyObject = collection.firstObject {
//            collectionFound = true
            let aAssetCollection = collection.firstObject as! PHAssetCollection
            if let block = didGetCollectionBlock {
                block(assetCollection: aAssetCollection)
            }
        } else {
            var assetCollectionPlaceholder: PHObjectPlaceholder!
            //            PHPhotoLibrary.sharedPhotoLibrary().registerChangeObserver(self)
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                let createAlbumRequest: PHAssetCollectionChangeRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(collectionTitle)
                assetCollectionPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
                }, completionHandler: { (success, error) -> Void in
                    if (success) {
//                        collectionFound = true
                        let collectionFetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([assetCollectionPlaceholder.localIdentifier], options: nil)
                        let aAssetCollection = collectionFetchResult.firstObject as! PHAssetCollection
                        if let block = didGetCollectionBlock {
                            block(assetCollection: aAssetCollection)
                        }
                    }
            })
        }
    }
    
    /**
    fetch results from photos
    
    - parameter aAssetCollectionTitle: collection title, if it is nil, then will fetch from the camera roll, or will fetch from the collection
    - parameter fetchOptions:          fetchOption
    
    - returns: fetchResults or nil
    */
    public class func fetchResultWithAssetCollectionTitle(aAssetCollectionTitle: String!, fetchOptions: PHFetchOptions?) -> PHFetchResult? {
//        // what predicate can add, you can see the class: PHAsset, here is just the example
//        let fetchOptions = PHFetchOptions()
//        fetchOptions.predicate = NSPredicate(format: "favorite == %@", false)
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if (aAssetCollectionTitle == nil) {
            // get from the camera roll
            return PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        }
        
        let collection: PHAssetCollection? = getAssetCollectionWithTitle(aAssetCollectionTitle)
        if (collection == nil) {
            return nil
        }
        // get from the collection
        return PHAsset.fetchAssetsInAssetCollection(collection!, options: fetchOptions)
    }
    
    public class func requestAImage(aAsset: PHAsset?, size: CGSize, didRequestAImage: ((UIImage!, [NSObject : AnyObject]!) -> Void)?) {
        
        if aAsset == nil {
            return
        }
        
        var imgSize = size
        if CGSizeEqualToSize(imgSize, CGSizeZero) {
            imgSize = PHImageManagerMaximumSize
        }
        PHImageManager.defaultManager().requestImageForAsset(aAsset!, targetSize: imgSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (rsImage, rsInfo) -> Void in
            // do with the aImage: UIImage, and you can get more information about "info"
            if let block = didRequestAImage {
                block(rsImage, rsInfo)
            }
        })
    }
    

    public class func addImage(aImage: UIImage!, aAssetCollection: PHAssetCollection?, aFetchResult: PHFetchResult?, didAddImageBlock: (((Bool, NSError!) -> Void)!)) {
        
        if (aImage == nil) {
            return
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            
            // if aAssetCollection == nil, only save to camera roll
            let createAssetRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(aImage)
            
            if (aAssetCollection != nil) {
                let assetPlaceholder = createAssetRequest.placeholderForCreatedAsset
                let collectionChangeRequest = PHAssetCollectionChangeRequest(forAssetCollection: aAssetCollection!, assets: aFetchResult!)
                collectionChangeRequest!.addAssets([assetPlaceholder!])
            }
            
            }, completionHandler: { (success, error) -> Void in
                if (didAddImageBlock != nil) {
                    didAddImageBlock(success, error)
                }
        })
    }
    
    public class func getAssetCollectionWithTitle(assetCollectionTitle: String!) -> PHAssetCollection? {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", assetCollectionTitle)
        let collection : PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: fetchOptions)
        
        if let _: AnyObject = collection.firstObject {
            let aAssetCollection = collection.firstObject as? PHAssetCollection
            return aAssetCollection
        }
        return nil
        
        
//        let collectionRs: PHFetchResult = PHCollection.fetchTopLevelUserCollectionsWithOptions(nil)
//        
//        var albumId: String = ""
//        collectionRs.enumerateObjectsUsingBlock({(obj: AnyObject!, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
//            let aCollection: PHAssetCollection = obj as! PHAssetCollection
//            if aCollection.localizedTitle == self.screenshotAlbumName {
//                albumId = aCollection.localIdentifier
//                NSUserDefaults.standardUserDefaults().setObject(albumId, forKey: self.screenshotAlbumIdKey)
//                stop.initialize(true)
//            }
//        })
//        
//        return albumId
    }
}
