//
//  GalleryView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/26.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class GalleryView: UIView {
    
    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            let waterfallLayout = CHTCollectionViewWaterfallLayout()
            if UIScreen.main.bounds.width < 1024 {
                waterfallLayout.columnCount = 2
            } else {
                waterfallLayout.columnCount = 3
            }
            waterfallLayout.minimumColumnSpacing = 36.0
            waterfallLayout.minimumInteritemSpacing = 60.0
            galleryCollectionView.setCollectionViewLayout(waterfallLayout, animated: false)
            galleryCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: Bundle.main),
                                           forCellWithReuseIdentifier: "galleryCollectionViewCell")
            galleryCollectionView.reloadData()
        }
    }
    
}


extension GalleryView: CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 100
        if UIScreen.main.bounds.width < 1024 {
            width = (collectionView.frame.width - 36) / 2
        } else {
            width = (collectionView.frame.width - 36 * 2) / 3
        }
        return CGSize(width: width, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCollectionViewCell",
                                                      for: indexPath) as! GalleryCollectionViewCell
        return cell
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}
