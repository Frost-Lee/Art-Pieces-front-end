//
//  CachedLecture+CoreDataProperties.swift
//  
//
//  Created by 李灿晨 on 2018/9/10.
//
//

import Foundation
import CoreData


extension CachedLecture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedLecture> {
        return NSFetchRequest<CachedLecture>(entityName: "CachedLecture")
    }

    @NSManaged public var creatorName: String?
    @NSManaged public var creatorPortraitPath: String?
    @NSManaged public var numberOfStars: Int32
    @NSManaged public var numberOfSteps: Int32
    @NSManaged public var price: Int32
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var keyPhotoPath: String?

}
