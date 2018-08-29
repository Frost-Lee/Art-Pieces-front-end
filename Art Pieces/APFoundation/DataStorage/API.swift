//
//  API.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/28.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import Foundation

struct User {
    var email: String
    var name: String
    var portrait: URL?
    var compressedPortrait: URL?
    var artworks: [UUID]
    var lectures: [UUID]
}


struct RemoteArtwork {
    var id: UUID
    var keyPhoto: URL
    var compressedKeyPhoto: URL
    var title: String
    var description: String?
    var creator: User
    var timestamp: Date
    var belongingRepo: UUID?
}


struct RemoteLecture {
    var id: UUID
    var title: String
    var description: String?
    var timestamp: Date
    var creator: User
    var lecture: Data
    var numberOfStars: Int
}


struct Repo {
    var id: UUID
    var keyArtwork: RemoteArtwork
    var title: String
    var starter: User
    var timestamp: Date
    var artworks: [UUID]
}
