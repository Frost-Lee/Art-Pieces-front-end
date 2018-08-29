//
//  CachedArtwork+CoreDataProperties.swift
//  
//
//  Created by 李灿晨 on 2018/8/29.
//
//

import Foundation
import CoreData


extension CachedArtwork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedArtwork> {
        return NSFetchRequest<CachedArtwork>(entityName: "CachedArtwork")
    }

    @NSManaged public var compressedKeyPhotoPath: String?
    @NSManaged public var id: UUID?
    @NSManaged public var keyPhotoPath: String?
    @NSManaged public var title: String?
    @NSManaged public var belongsTo: CachedRepo?

}
