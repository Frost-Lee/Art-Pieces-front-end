//
//  DataManager.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/29.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataManager {
    
    static let cachedFileHomeDirectory = NSHomeDirectory() + "/Documents/CachedFiles"
    static let localFileHomeDirectory = NSHomeDirectory() + "/Documents/LocalFiles"
    
    static let defaultManager = DataManager()
    
    func storeArtwork(title: String, description: String?, keyPhoto: UIImage) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyArtwork", in: context)
        let newArtwork = MyArtwork(entity: entity!, insertInto: context)
        newArtwork.title = title
        newArtwork.artworkDescription = description
        newArtwork.timestamp = Date() as NSDate
        newArtwork.keyPhotoPath = savePhoto(photo: keyPhoto, isCachedPhoto: false)
        try! context.save()
    }
    
    func storeLecture(title: String, description: String?, content: Data, stepPreviewPhotos: [UIImage]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyLecture", in: context)
        let newLecture = MyLecture(entity: entity!, insertInto: context)
        newLecture.title = title
        newLecture.lectureDescription = description
        newLecture.content = content as NSData
        
    }
    
    func savePhoto(photo: UIImage, isCachedPhoto: Bool) -> String {
        initializeDirectory()
        let photoIdentifier = UUID().uuidString + ".png"
        let photoData = photo.pngData()!
        let urlPath = isCachedPhoto ? DataManager.cachedFileHomeDirectory + photoIdentifier :
            DataManager.localFileHomeDirectory + photoIdentifier
        try! photoData.write(to: URL(fileURLWithPath: urlPath))
        return urlPath
    }
    
    func removeItem(path: String?) {
        try? FileManager.default.removeItem(atPath: path ?? "")
    }
    
    private func initializeDirectory() {
        if !FileManager.default.fileExists(atPath: DataManager.localFileHomeDirectory) {
            try! FileManager.default.createDirectory(atPath: DataManager.localFileHomeDirectory,
                                                     withIntermediateDirectories: true, attributes: nil)
        }
        if !FileManager.default.fileExists(atPath: DataManager.cachedFileHomeDirectory) {
            try! FileManager.default.createDirectory(atPath: DataManager.cachedFileHomeDirectory,
                                                     withIntermediateDirectories: true, attributes: nil)
        }
    }
    
}

