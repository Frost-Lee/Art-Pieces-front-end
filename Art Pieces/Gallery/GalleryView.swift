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
            galleryCollectionView.setCollectionViewLayout(CHTCollectionViewWaterfallLayout(), animated: false)
            galleryCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: Bundle.main),
                                           forCellWithReuseIdentifier: "galleryCollectionViewCell")
            galleryCollectionView.reloadData()
        }
    }
    
}


extension GalleryView: CHTCollectionViewDelegateWaterfallLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) / 3
        return CGSize(width: width, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCollectionViewCell", for: indexPath)
        return cell
    }
}
