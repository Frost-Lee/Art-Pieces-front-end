//
//  MyArtwork+CoreDataProperties.swift
//  
//
//  Created by 李灿晨 on 2018/8/31.
//
//

import Foundation
import CoreData


extension MyArtwork {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyArtwork> {
        return NSFetchRequest<MyArtwork>(entityName: "MyArtwork")
    }

    @NSManaged public var artworkDescription: String?
    @NSManaged public var keyPhotoPath: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var title: String?

}
