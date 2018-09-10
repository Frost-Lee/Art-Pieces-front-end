//
//  Lecture.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/7/26.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import MJRefresh

protocol LectureDelegate: class {
    func lectureItemDidSelected(at index: Int)
    func lectureItemShouldDownload(with uuid: UUID, sender: LectureTableViewCell)
}

class LectureView: UIView {
    
    @IBOutlet weak var lectureTableView: UITableView! {
        didSet {
            lectureTableView.register(UINib(nibName: "LectureTableViewCell", bundle: Bundle.main),
                                      forCellReuseIdentifier: "lectureTableViewCell")
            lectureTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
            setupRefreshProperties()
            loadCachedData()
            reloadTableViewData()
            lectureTableView.mj_header.beginRefreshing()
        }
    }
    
    weak var delegate: LectureDelegate?
    
    let webManager = APWebService.defaultManager
    let dataManager = DataManager.defaultManager
    
    let keyPhotoPlaceHolder = UIImage(named: "GalleryPlaceHolderImage")
    
    private var previews: [LecturePreview] = []
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
                self.lectureTableView.reloadRows(at: indicesToUpdate, with: .fade)
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
                self.lectureTableView.reloadRows(at: indicesToUpdate, with: .fade)
            }
        }
    }
    
    private func loadCachedData() {
        previews = dataManager.getCachedLecturePreviews()
        lectureTableView.reloadData()
        registerImageLoad(previews: previews)
    }
    
    private func setupRefreshProperties() {
        let header = MJRefreshNormalHeader() {
            self.reloadTableViewData()
        }
        header?.lastUpdatedTimeLabel.isHidden = true
        header?.setTitle("Pull down to refresh", for: .idle)
        header?.setTitle("Release to refresh", for: .pulling)
        header?.setTitle("Loading", for: .refreshing)
        lectureTableView.mj_header = header
        let footer = MJRefreshAutoNormalFooter() {
            self.keepLoadTableViewData()
        }
        footer?.setTitle("Tap or pull up to load more", for: .idle)
        footer?.setTitle("Release to load more", for: .pulling)
        footer?.setTitle("Loading", for: .refreshing)
        lectureTableView.mj_footer = footer
    }
    
    private func reloadTableViewData() {
        webManager.getLecturePreviewFeed(email: AccountManager.defaultManager
            .currentUser?.email) { previews in
                let filteredPreviews = self.getFilteredPreviews(from: previews, baseLine:
                    self.previews.first, isBefore: false)
                if !self.previews.isEmpty && previews.last!.timestamp > self.previews.first!.timestamp {
                    self.keyPhotoDictionary.removeAll()
                    self.portraitDictionary.removeAll()
                    self.previews = filteredPreviews
                    self.dataManager.cleanLecturePreviewCache()
                } else {
                    self.previews = filteredPreviews + self.previews
                }
                self.registerImageLoad(previews: filteredPreviews)
                self.cachePreviewData(previews: filteredPreviews)
                DispatchQueue.main.async {
                    if filteredPreviews.count != 0 {
                        self.lectureTableView.reloadData()
                    }
                    self.lectureTableView.mj_header.endRefreshing()
                }
        }
    }
    
    private func keepLoadTableViewData() {
        lectureTableView.mj_footer.endRefreshing()
        guard previews.count != 0 else {lectureTableView.mj_footer.endRefreshing();return}
        webManager.extendLecturePreviewFeed(timestamp: previews.last!.timestamp, email: AccountManager
            .defaultManager.currentUser?.email) { previews in
                let filteredPreviews = self.getFilteredPreviews(from: previews, baseLine:
                    self.previews.last, isBefore: true)
                self.previews += filteredPreviews
                self.registerImageLoad(previews: filteredPreviews)
                self.cachePreviewData(previews: filteredPreviews)
                DispatchQueue.main.async {
                    if filteredPreviews.count != 0 {
                        self.lectureTableView.reloadData()
                    }
                    self.lectureTableView.mj_footer.endRefreshing()
                }
        }
    }
    
    private func registerImageLoad(previews: [LecturePreview]) {
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
    
    private func getFilteredPreviews(from previews: [LecturePreview],
                                     baseLine: LecturePreview?, isBefore: Bool) -> [LecturePreview] {
        var result: [LecturePreview] = []
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
    
    private func cachePreviewData(previews: [LecturePreview]) {
        for preview in previews {
            self.dataManager.cacheLecturePreview(preview: preview)
        }
    }
    
}


extension LectureView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return previews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lectureTableViewCell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! LectureTableViewCell
        cell.index = indexPath.row
        cell.delegate = self
        cell.lecturePreview = previews[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // delegate?.lectureItemDidSelected(at: indexPath.row)
    }
}


extension LectureView: LectureTableViewCellDelegate {
    func downloadButtonDidTapped(at index: Int) {
        let sender = lectureTableView.cellForRow(at: IndexPath(row: index, section: 0))
            as! LectureTableViewCell
        delegate?.lectureItemShouldDownload(with: previews[index].uuid, sender: sender)
    }
}
