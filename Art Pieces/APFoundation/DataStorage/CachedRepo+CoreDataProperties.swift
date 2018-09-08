//
//  CachedRepo+CoreDataProperties.swift
//  
//
//  Created by 李灿晨 on 2018/9/8.
//
//

import Foundation
import CoreData


extension CachedRepo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedRepo> {
        return NSFetchRequest<CachedRepo>(entityName: "CachedRepo")
    }

    @NSManaged public var creatorName: String?
    @NSManaged public var keyPhotoPath: String?
    @NSManaged public var numberOfBranches: Int32
    @NSManaged public var numberOfStars: Int32
    @NSManaged public var creatorPortraitPath: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var contains: NSSet?

}

// MARK: Generated accessors for contains
extension CachedRepo {

    @objc(addContainsObject:)
    @NSManaged public func addToContains(_ value: CachedArtwork)

    @objc(removeContainsObject:)
    @NSManaged public func removeFromContains(_ value: CachedArtwork)

    @objc(addContains:)
    @NSManaged public func addToContains(_ values: NSSet)

    @objc(removeContains:)
    @NSManaged public func removeFromContains(_ values: NSSet)

}
