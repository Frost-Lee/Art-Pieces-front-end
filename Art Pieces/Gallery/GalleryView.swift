//
//  GalleryView.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/26.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import MJRefresh

protocol GalleryDelegate: class {
    func galleryItemDidSelected(at index: Int)
}

class GalleryView: UIView {
    
    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            setupRefreshProperties()
            setupFlowLayoutProperties()
        }
    }
    
    weak var delegate: GalleryDelegate?
    
    private func setupFlowLayoutProperties() {
        let waterfallLayout = CHTCollectionViewWaterfallLayout()
        if UIScreen.main.bounds.width < 1024 {
            waterfallLayout.columnCount = 2
        } else {
            waterfallLayout.columnCount = 3
        }
        waterfallLayout.minimumColumnSpacing = 36.0
        waterfallLayout.minimumInteritemSpacing = 60.0
        galleryCollectionView.setCollectionViewLayout(waterfallLayout, animated: false)
        galleryCollectionView.register(UINib(nibName: "ArtworkPreviewCollectionViewCell", bundle: Bundle.main),
                                       forCellWithReuseIdentifier: "artworkPreviewCollectionViewCell")
        galleryCollectionView.reloadData()
    }
    
    private func setupRefreshProperties() {
        let header = MJRefreshNormalHeader() {
            self.reloadCollectionViewData()
        }
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setTitle("Pull down to refresh", for: .idle)
        header?.setTitle("Release to refresh", for: .pulling)
        header?.setTitle("Loading", for: .refreshing)
        galleryCollectionView.mj_header = header
        let footer = MJRefreshAutoNormalFooter() {
            self.keepLoadCollectionViewData()
        }
        footer?.setTitle("Tap or pull up to load more", for: .idle)
        footer?.setTitle("Release to load more", for: .pulling)
        footer?.setTitle("Loading", for: .refreshing)
        galleryCollectionView.mj_footer = footer
    }
    
    private func reloadCollectionViewData() {
        galleryCollectionView.mj_header.endRefreshing()
    }
    
    private func keepLoadCollectionViewData() {
        galleryCollectionView.mj_footer.endRefreshing()
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
        return CGSize(width: width, height: width / 0.967)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artworkPreviewCollectionViewCell",
                                                      for: indexPath) as! ArtworkPreviewCollectionViewCell
        return cell
    }
    
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                         insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.galleryItemDidSelected(at: indexPath.row)
    }
}
