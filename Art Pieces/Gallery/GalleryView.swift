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
            galleryCollectionView.mj_header.beginRefreshing()
            loadCachedData()
            reloadCollectionViewData()
        }
    }
    
    weak var delegate: GalleryDelegate?
    
    let webManager = APWebService.defaultManager
    let dataManager = DataManager.defaultManager
    
    private var previews: [ArtworkPreview] = []
    private var keyPhotoDictionary: [UUID : UIImage?] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
            }
        }
    }
    private var portraitDictionary: [UUID : UIImage?] = [:] {
        didSet {
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadData()
            }
        }
    }
    
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
    
    private func loadCachedData() {
        previews = dataManager.getCachedRepoPreviews()
        galleryCollectionView.reloadData()
        registerImageLoad(previews: previews)
    }
    
    private func reloadCollectionViewData() {
        webManager.getRepoPreviewFeed(email: AccountManager.defaultManager
            .currentUser?.email) { previews in
                let filteredPreviews = self.getFilteredPreviews(from: previews, baseLine:
                    self.previews.first, isBefore: false)
                self.previews = (filteredPreviews + self.previews)
                self.registerImageLoad(previews: filteredPreviews)
                self.cachePreviewData(previews: filteredPreviews)
                DispatchQueue.main.async {
                    self.galleryCollectionView.reloadData()
                    self.galleryCollectionView.mj_header.endRefreshing()
                }
        }
    }
    
    private func keepLoadCollectionViewData() {
        guard previews.count != 0 else {return}
        webManager.extendRepoPreviewFeed(timestamp:
            previews.last!.timestamp, email: AccountManager.defaultManager.currentUser?.email) {
            previews in
                let filteredPreviews = self.getFilteredPreviews(from: previews, baseLine:
                    self.previews.last, isBefore: true)
                self.previews += filteredPreviews
                self.registerImageLoad(previews: filteredPreviews)
                self.cachePreviewData(previews: filteredPreviews)
                DispatchQueue.main.async {
                    self.galleryCollectionView.reloadData()
                    self.galleryCollectionView.mj_footer.endRefreshing()
                }
        }
    }
    
    private func registerImageLoad(previews: [ArtworkPreview]) {
        for preview in previews {
            webManager.fetchPhoto(url: URL(string: preview.keyPhotoPath)!) { image in
                self.keyPhotoDictionary.updateValue(image, forKey: preview.uuid)
            }
            webManager.fetchPhoto(url: URL(string: preview.keyPhotoPath)!) { image in
                self.keyPhotoDictionary.updateValue(image, forKey: preview.uuid)
            }
        }
    }
    
    private func getFilteredPreviews(from previews: [ArtworkPreview],
                                     baseLine: ArtworkPreview?, isBefore: Bool) -> [ArtworkPreview] {
        var result: [ArtworkPreview] = []
        let baseLineDate = baseLine?.timestamp
        guard baseLineDate != nil else {
            if isBefore {
                return []
            } else {
                return previews
            }
        }
        for preview in previews {
            if isBefore && preview.timestamp < baseLineDate! {
                result.append(preview)
            } else if !isBefore && preview.timestamp > baseLineDate! {
                result.append(preview)
            }
        }
        return result
    }
    
    private func cachePreviewData(previews: [ArtworkPreview]) {
        for preview in previews {
            self.dataManager.cacheRepoPreview(preview: preview)
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
        let cell = galleryCollectionView.cellForItem(at: indexPath) as? ArtworkPreviewCollectionViewCell
        let size = cell?.repositoryTitleImageView.image?.size
        let ratio = (size?.width ?? 4.0) / (size?.height ?? 3.0)
        return CGSize(width: width, height: width / ratio + 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artworkPreviewCollectionViewCell",
                                                      for: indexPath) as! ArtworkPreviewCollectionViewCell
        cell.preview = previews[indexPath.row]
        cell.keyPhoto = keyPhotoDictionary[previews[indexPath.row].uuid] as? UIImage
        cell.portraitPhoto = portraitDictionary[previews[indexPath.row].uuid] as? UIImage
        cell.repositoryTitleImageView.image = UIImage(named: "GalleryPlaceHolderImage")
        cell.delegate = self
        return cell
    }
    
    func collectionView (_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex
        section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.galleryItemDidSelected(at: indexPath.row)
    }
}


extension GalleryView: ArtworkPreviewDelegate {
    func moreButtonDidTapped(index: Int) {
        
    }
    
    func relayoutCollectionView() {
        galleryCollectionView.collectionViewLayout.invalidateLayout()
    }
}
