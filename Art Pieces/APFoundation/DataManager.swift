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
                      email: String, title: String, description: String, selfID: UUID) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        var previewPhotoArrayPath = ""
        for image in stepPreviewPhotoArray {
            previewPhotoArrayPath += (saveImage(photo: image, isCachedPhoto: false) + ";")
        }
        if (getArtboard(uuid: selfID) != nil) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyArtboard")
            fetchRequest.predicate = NSPredicate(format: "uuid=\"\(selfID)\"")
            if let fetchedResults = try! context.fetch(fetchRequest) as? [MyArtboard] {
                let result = fetchedResults.first!
                removeItem(path: result.keyPhotoPath!)
                for path in result.stepPreviewPhotoPath!.components(separatedBy: ";") {
                    removeItem(path: path)
                }
                result.keyPhotoPath = saveImage(photo: keyPhoto, isCachedPhoto: false)
                result.stepPreviewPhotoPath = previewPhotoArrayPath
                result.content = content as NSData
            }
        } else {
            let entity = NSEntityDescription.entity(forEntityName: "MyArtboard", in: context)
            let newArtboard = MyArtboard(entity: entity!, insertInto: context)

            newArtboard.keyPhotoPath = saveImage(photo: keyPhoto, isCachedPhoto: false)
            newArtboard.stepPreviewPhotoPath = previewPhotoArrayPath
            newArtboard.content = content as NSData
            newArtboard.creatorEmail = email
            newArtboard.title = title
            newArtboard.boardDescription = description
            newArtboard.timestamp = Date() as NSDate
            newArtboard.uuid = selfID
        }
        try! context.save()
    }
    
    func updateArtboard(title: String, uuid: UUID) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyArtboard")
        fetchRequest.predicate = NSPredicate(format: "uuid=\"\(uuid)\"")
        if let fetchedResults = try! context.fetch(fetchRequest) as? [MyArtboard] {
            fetchedResults.first?.title = title
            try! context.save()
        }
    }
    
    func removeArtboard(uuid: UUID) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyArtboard")
        fetchRequest.predicate = NSPredicate(format: "uuid=\"\(uuid)\"")
        if let fetchedResults = try! context.fetch(fetchRequest) as? [MyArtboard] {
            context.delete(fetchedResults.first!)
            try! context.save()
        }
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
    
    func cacheRepoPreview(preview: ArtworkPreview) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "CachedRepo", in: context)
            let newCachedRepo = CachedRepo(entity: entity!, insertInto: context)
            newCachedRepo.uuid = preview.uuid
            newCachedRepo.keyPhotoPath = preview.keyPhotoPath
            newCachedRepo.title = preview.title
            newCachedRepo.creatorName = preview.creatorName
            newCachedRepo.creatorPortraitPath = preview.creatorPortraitPath
            newCachedRepo.numberOfBranches = Int32(preview.numberOfForks)
            newCachedRepo.numberOfStars = Int32(preview.numberOfStars)
            newCachedRepo.timestamp = preview.timestamp as NSDate
            try! context.save()
        }
    }
    
    func getCachedRepoPreviews() -> [ArtworkPreview] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedRepo")
        let fetchedRepos = try! context.fetch(fetchRequest) as! [CachedRepo]
        var previews: [ArtworkPreview] = []
        for repo in fetchedRepos {
            previews.append(ArtworkPreview(cachedRepo: repo))
        }
        return previews.sorted(by: {$0.timestamp > $1.timestamp})
    }
    
    func cleanRepoPreviewCache() {
        DispatchQueue.main.async {
            self.cleanEntity(entityName: "CachedRepo")
        }
    }
    
    func cacheLecturePreview(preview: LecturePreview) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "CachedLecture", in: context)
            let newCachedLecture = CachedLecture(entity: entity!, insertInto: context)
            newCachedLecture.uuid = preview.uuid
            newCachedLecture.creatorName = preview.creatorName
            newCachedLecture.creatorPortraitPath = preview.creatorPortraitPath
            newCachedLecture.keyPhotoPath = preview.keyPhotoPath
            newCachedLecture.numberOfStars = Int32(preview.numberOfStars)
            newCachedLecture.numberOfSteps = Int32(preview.numberOfSteps)
            newCachedLecture.timestamp = preview.timestamp as NSDate
            newCachedLecture.title = preview.title
            newCachedLecture.uuid = preview.uuid
        }
    }
    
    func getCachedLecturePreviews() -> [LecturePreview] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedLecture")
        let fetchedLectures = try! context.fetch(fetchRequest) as! [CachedLecture]
        var previews: [LecturePreview] = []
        for lecture in fetchedLectures {
            previews.append(LecturePreview(cachedLecture: lecture))
        }
        return previews.sorted(by: {$0.timestamp > $1.timestamp})
    }
    
    func cleanLecturePreviewCache() {
        DispatchQueue.main.async {
            self.cleanEntity(entityName: "CachedLecture")
        }
    }
    
    func saveImage(photo: UIImage, isCachedPhoto: Bool) -> String {
        initializeDirectory()
        let photoIdentifier = UUID().uuidString + ".jpeg"
        let photoData = isCachedPhoto ? photo.jpegData(compressionQuality: 0.2)! :
            photo.jpegData(compressionQuality: 1)!
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
    
    private func cleanEntity(entityName: String) {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let fetchedCaches = try! context.fetch(fetchRequest) as! [CachedRepo]
            for repo in fetchedCaches {
                context.delete(repo)
            }
            try! context.save()
        }
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

