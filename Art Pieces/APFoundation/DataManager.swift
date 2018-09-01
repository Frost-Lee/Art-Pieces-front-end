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
    
    func saveArtwork(title: String, description: String?, keyPhoto: UIImage) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyArtwork", in: context)
        let newArtwork = MyArtwork(entity: entity!, insertInto: context)
        newArtwork.title = title
        newArtwork.artworkDescription = description
        newArtwork.timestamp = Date() as NSDate
        newArtwork.keyPhotoPath = saveImage(photo: keyPhoto, isCachedPhoto: false)
        try! context.save()
    }
    
    func saveLecture(title: String, description: String?, content: Data,
                     previewPhoto: UIImage, stepPreviewPhotos: [UIImage]) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyLecture", in: context)
        let newLecture = MyLecture(entity: entity!, insertInto: context)
        newLecture.title = title
        newLecture.lectureDescription = description ?? ""
        newLecture.content = content as NSData
        newLecture.numberOfSteps = Int32(stepPreviewPhotos.count)
        newLecture.uuid = UUID()
        newLecture.timestamp = Date() as NSDate
        newLecture.previewPhotoPath = saveImage(photo: previewPhoto, isCachedPhoto: false)
        var stepPreviewPhotoPath: String = ""
        for photo in stepPreviewPhotos {
            stepPreviewPhotoPath += saveImage(photo: photo, isCachedPhoto: false) + ";"
        }
        newLecture.stepPreviewPhotoPathArray = stepPreviewPhotoPath
        try! context.save()
    }
    
    func getAllArtworks() -> [MyArtwork] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyArtwork")
        let fetchedArtworks = try! context.fetch(fetchRequest) as! [MyArtwork]
        return fetchedArtworks
    }
    
    func getAllLectures() -> [MyLecture] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyLecture")
        let fetchedLectures = try! context.fetch(fetchRequest) as! [MyLecture]
        return fetchedLectures
    }
    
    func getArtwork(uuid: UUID) -> MyArtwork? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyArtwork")
        fetchRequest.predicate = NSPredicate(format: "uuid=\(uuid)")
        let fetchedArtworks = try! context.fetch(fetchRequest) as! [MyArtwork]
        return fetchedArtworks.first
    }
    
    func getLecture(uuid: UUID) -> MyLecture? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchedRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyLecture")
        fetchedRequest.predicate = NSPredicate(format: "uuid=\(uuid)")
        let fetchedLectures = try! context.fetch(fetchedRequest) as! [MyLecture]
        return fetchedLectures.first
    }
    
    func saveImage(photo: UIImage, isCachedPhoto: Bool) -> String {
        initializeDirectory()
        let photoIdentifier = UUID().uuidString + ".png"
        let photoData = photo.pngData()!
        let urlPath = isCachedPhoto ? DataManager.cachedFileHomeDirectory + photoIdentifier :
            DataManager.localFileHomeDirectory + photoIdentifier
        try! photoData.write(to: URL(fileURLWithPath: urlPath))
        return urlPath
    }
    
    func getImage(path: String) -> UIImage {
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        return UIImage(data: data)!
    }
    
    func removeItem(path: String?) {
        guard path != nil && path?.count != 0 else {return}
        try? FileManager.default.removeItem(atPath: path!)
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

