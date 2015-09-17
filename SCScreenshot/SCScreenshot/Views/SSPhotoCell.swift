//
//  SSPhotoCell.swift
//  SCScreenshot
//
//  Created by Aevit on 15/9/16.
//  Copyright (c) 2015年 Aevit. All rights reserved.
//

import UIKit
import ScreenShotManagerKit
import Photos

class SSPhotoCell: UICollectionViewCell {
    
    internal var picBtn: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        if (picBtn != nil) {
            picBtn?.setImage(nil, forState: UIControlState.Normal)
        }
        super.prepareForReuse()
    }
    
    func commonInit() {
        if picBtn != nil {
            return
        }
        let aBtn: UIButton = UIButton(type: UIButtonType.Custom)
        aBtn.frame = self.bounds
        aBtn.userInteractionEnabled = false
        aBtn.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
        self.addSubview(aBtn)
        picBtn = aBtn
    }
    
    func fillData(info: AnyObject) {
        if let asset: PHAsset = info as? PHAsset {
            let imageWidth = UIScreen.mainScreen().scale * picBtn!.frame.size.width
            SCPhotoTool.requestAImage(asset, size: CGSizeMake(imageWidth, imageWidth), didRequestAImage: { (resultImage, info) -> Void in
                self.picBtn!.setImage(resultImage, forState: UIControlState.Normal)
            })
        }
    }
    
}
