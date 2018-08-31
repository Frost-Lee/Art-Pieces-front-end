//
//  MyLecture+CoreDataProperties.swift
//  
//
//  Created by 李灿晨 on 2018/8/31.
//
//

import Foundation
import CoreData


extension MyLecture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyLecture> {
        return NSFetchRequest<MyLecture>(entityName: "MyLecture")
    }

    @NSManaged public var lectureDescription: String?
    @NSManaged public var numberOfSteps: Int32
    @NSManaged public var stepPreviewPhotoPathArray: String?
    @NSManaged public var timestamp: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var content: NSData?
    @NSManaged public var previewPhotoPath: String?

}
