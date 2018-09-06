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
    
    func saveArtboard(keyPhoto: UIImage, stepPreviewPhotoArray: [UIImage], content: Data,
                      email: String, title: String, description: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyArtboard", in: context)
        let newArtboard = MyArtboard(entity: entity!, insertInto: context)
        var previewPhotoArrayPath = ""
        for image in stepPreviewPhotoArray {
            previewPhotoArrayPath += (saveImage(photo: image, isCachedPhoto: false) + ";")
        }
        newArtboard.keyPhotoPath = saveImage(photo: keyPhoto, isCachedPhoto: false)
        newArtboard.stepPreviewPhotoPath = previewPhotoArrayPath
        newArtboard.content = content as NSData
        newArtboard.creatorEmail = email
        newArtboard.title = title
        newArtboard.boardDescription = description
        newArtboard.timestamp = Date() as NSDate
        newArtboard.uuid = UUID()
        try! context.save()
    }
    
    func getArtboard(uuid: UUID) -> MyArtboard? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyArtboard")
        fetchRequest.predicate = NSPredicate(format: "uuid=\"\(uuid)\"")
        let fetchedArtboards = try! context.fetch(fetchRequest) as! [MyArtboard]
        return fetchedArtboards.first
    }
    
    func getAllArtboards() -> [MyArtboard] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyArtboard")
        let fetchedArtboards = try! context.fetch(fetchRequest) as! [MyArtboard]
        return fetchedArtboards
    }
    
    func removeArtboard(uuid: UUID) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyArtboard")
        fetchRequest.predicate = NSPredicate(format: "uuid=\"\(uuid)\"")
        let objects = try! context.fetch(fetchRequest) as! [NSManagedObject]
        for object in objects {
            context.delete(object)
        }
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

