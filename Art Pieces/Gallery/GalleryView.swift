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
    func galleryItemDidSelected(preview: ArtworkPreview, keyPhoto: UIImage?, portrait: UIImage?)
}

class GalleryView: UIView {
    
    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            setupRefreshProperties()
            setupFlowLayoutProperties()
            loadCachedData()
            reloadCollectionViewData()
            galleryCollectionView.mj_header.beginRefreshing()
        }
    }
    
    weak var delegate: GalleryDelegate?
    
    let webManager = APWebService.defaultManager
    let dataManager = DataManager.defaultManager
    
    let keyPhotoPlaceHolder = UIImage(named: "GalleryPlaceHolderImage")
    
    private var previews: [ArtworkPreview] = []
    private var keyPhotoDictionary: [UUID : String?] = [:] {
        didSet {
            var indicesToUpdate: [IndexPath] = []
            for key in keyPhotoDictionary.keys {
                if oldValue[key] == nil {
                    for i in 0 ..< previews.count {
                        if previews[i].uuid == key {
                            indicesToUpdate.append(IndexPath(row: i, section: 0))
                            break
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadItems(at: indicesToUpdate)
            }
        }
    }
    private var portraitDictionary: [UUID : String?] = [:] {
        didSet {
            var indicesToUpdate: [IndexPath] = []
            for key in portraitDictionary.keys {
                if oldValue[key] == nil {
                    for i in 0 ..< previews.count {
                        if previews[i].uuid == key {
                            indicesToUpdate.append(IndexPath(row: i, section: 0))
                            break
                        }
                    }
                }
            }
            DispatchQueue.main.async {
                self.galleryCollectionView.reloadItems(at: indicesToUpdate)
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
                if !self.previews.isEmpty && previews.last!.timestamp > self.previews.first!.timestamp {
                    self.keyPhotoDictionary.removeAll()
                    self.portraitDictionary.removeAll()
                    self.previews = filteredPreviews
                    self.dataManager.cleanRepoPreviewCache()
                } else {
                    self.previews = filteredPreviews + self.previews
                }
                self.registerImageLoad(previews: filteredPreviews)
                self.cachePreviewData(previews: filteredPreviews)
                DispatchQueue.main.async {
                    if filteredPreviews.count != 0 {
                        self.galleryCollectionView.reloadData()
                    }
                    self.galleryCollectionView.mj_header.endRefreshing()
                }
        }
    }
    
    private func keepLoadCollectionViewData() {
        guard previews.count != 0 else {galleryCollectionView.mj_footer.endRefreshing();return}
        webManager.extendRepoPreviewFeed(timestamp:
            previews.last!.timestamp, email: AccountManager.defaultManager.currentUser?.email) {
            previews in
                let filteredPreviews = self.getFilteredPreviews(from: previews, baseLine:
                    self.previews.last, isBefore: true)
                self.previews += filteredPreviews
                self.registerImageLoad(previews: filteredPreviews)
                self.cachePreviewData(previews: filteredPreviews)
                DispatchQueue.main.async {
                    if filteredPreviews.count != 0 {
                        self.galleryCollectionView.reloadData()
                    }
                    self.galleryCollectionView.mj_footer.endRefreshing()
                }
        }
    }
    
    private func registerImageLoad(previews: [ArtworkPreview]) {
        for preview in previews {
            webManager.fetchPhoto(url: URL(string: preview.keyPhotoPath)!) { image in
                if let image = image {
                    self.keyPhotoDictionary.updateValue(self.dataManager.saveImage(photo:
                        image, isCachedPhoto: true), forKey: preview.uuid)
                }
            }
            if let portraitPath = preview.creatorPortraitPath {
                webManager.fetchPhoto(url: URL(string: portraitPath)!) { image in
                    if let image = image {
                        self.portraitDictionary.updateValue(self.dataManager.saveImage(photo:
                            image, isCachedPhoto: true), forKey: preview.uuid)
                    }
                }
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
        let imagePath = keyPhotoDictionary[previews[indexPath.row].uuid]
        var ratio: CGFloat
        if imagePath == nil {
            ratio = 4.0 / 3.0
        } else {
            let image = dataManager.getImage(path: imagePath!!)
            ratio = image.size.width / image.size.height
        }
        return CGSize(width: width, height: width / ratio + 85)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return previews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt
        indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "artworkPreviewCollectionViewCell",
                                                      for: indexPath) as! ArtworkPreviewCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay
        cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ArtworkPreviewCollectionViewCell
        cell.delegate = self
        cell.preview = previews[indexPath.row]
        if keyPhotoDictionary[previews[indexPath.row].uuid] != nil {
            let image = dataManager.getImage(path: keyPhotoDictionary[previews[indexPath.row].uuid]!!)
            cell.keyPhoto = image
        } else {
            cell.keyPhoto = keyPhotoPlaceHolder
        }
        if portraitDictionary[previews[indexPath.row].uuid] != nil {
            let image = dataManager.getImage(path: portraitDictionary[previews[indexPath.row].uuid]!!)
            cell.portraitPhoto = image
        }
    }
    
    func collectionView (_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex
        section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let preview = previews[indexPath.row]
        var keyPhoto: UIImage?
        var portrait: UIImage?
        let keyPhotoPath = keyPhotoDictionary[preview.uuid]
        let portraitPath = portraitDictionary[preview.uuid]
        if keyPhotoPath != nil {
            keyPhoto = dataManager.getImage(path: keyPhotoPath!!)
        }
        if portraitPath != nil {
            portrait = dataManager.getImage(path: portraitPath!!)
        }
        delegate?.galleryItemDidSelected(preview: preview, keyPhoto: keyPhoto, portrait: portrait)
    }
}


extension GalleryView: ArtworkPreviewDelegate {
    func moreButtonDidTapped(index: Int) {
        
    }
    
    func relayoutCollectionView() {
        galleryCollectionView.collectionViewLayout.invalidateLayout()
    }
}
