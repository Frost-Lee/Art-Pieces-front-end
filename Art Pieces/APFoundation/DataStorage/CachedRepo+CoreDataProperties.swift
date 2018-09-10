//
//  CachedRepo+CoreDataProperties.swift
//  
//
//  Created by 李灿晨 on 2018/9/10.
//
//

import Foundation
import CoreData


extension CachedRepo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedRepo> {
        return NSFetchRequest<CachedRepo>(entityName: "CachedRepo")
    }

    @NSManaged public var creatorName: String?
    @NSManaged public var creatorPortraitPath: String?
    @NSManaged public var keyPhotoPath: String?
    @NSManaged public var numberOfBranches: Int32
    @NSManaged public var numberOfStars: Int32
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?

}
