//
//  GalleryViewController.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/19.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout

class GalleryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}


extension GalleryViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:
        UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize.zero
    }
    
    
}


