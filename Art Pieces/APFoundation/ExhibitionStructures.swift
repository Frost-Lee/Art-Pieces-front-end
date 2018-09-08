//
//  ExhibitionStructures.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/9/7.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ArtworkPreview {
    var uuid: UUID
    var keyPhotoPath: String
    var title: String
    var creatorName: String
    var creatorPortraitPath: String?
    var numberOfForks: Int
    var numberOfStars: Int
    var timestamp: Date
    
    init(json: JSON) {
        uuid = UUID(uuidString: json["id"].string!)!
        keyPhotoPath = json["keyArtwork"]["keyPhoto"].string!
        title = json["title"].string!
        creatorName = json["starter"]["name"].string!
        creatorPortraitPath = json["starter"]["portrait"].string
        numberOfForks = json["numberOfArtworks"].int!
        numberOfStars = json["numberOfStars"].int!
        timestamp = json["timestamp"].date!
    }
    
    init(cachedRepo: CachedRepo) {
        uuid = cachedRepo.uuid!
        keyPhotoPath = cachedRepo.keyPhotoPath!
        title = cachedRepo.title!
        creatorName = cachedRepo.creatorName!
        creatorPortraitPath = cachedRepo.creatorPortraitPath
        numberOfForks = Int(cachedRepo.numberOfBranches)
        numberOfStars = Int(cachedRepo.numberOfStars)
        timestamp = cachedRepo.timestamp! as Date
    }
}
