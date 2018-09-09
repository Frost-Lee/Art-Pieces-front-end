//
//  MyArtboard+CoreDataProperties.swift
//  
//
//  Created by 李灿晨 on 2018/9/9.
//
//

import Foundation
import CoreData


extension MyArtboard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyArtboard> {
        return NSFetchRequest<MyArtboard>(entityName: "MyArtboard")
    }

    @NSManaged public var boardDescription: String?
    @NSManaged public var content: NSData?
    @NSManaged public var creatorEmail: String?
    @NSManaged public var keyPhotoPath: String?
    @NSManaged public var stepPreviewPhotoPath: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var numberOfStars: Int32
    @NSManaged public var numberOfForks: Int32

}
