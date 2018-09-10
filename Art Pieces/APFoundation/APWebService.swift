//
//  APWebService.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/28.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import UIKit
import SwiftyJSON

struct RequestBody: Codable {
    var operationName: String?
    var variables: [Int]
    var query: String
}

class APWebService {
    
    static let backEndURL = URL(string: "https://artpieces.cn/api")!
    static let resourceServerURL = URL(string: "http://95.179.143.156:4001/upload")!
    var now: TimeInterval {
        return Date().secondsSince1970
    }
    
    static let defaultManager = APWebService()
    
    func registerUser(email: String, password: String, completion: ((String?) -> Void)?) {
        var request = self.getRequest(httpMethod: "POST")
        let query = """
        mutation InsertUser {
            insertUser(email: "\(email.secured())", name: "\(email.secured())",
                password: "\(password.secured())")
        }
        """
        request.httpBody = self.constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let json = try! JSON(data: data)
                let statusCode = json["data"]["insertUser"]["status"].int
                completion?(self.translateStatusCode(status: statusCode!))
            }
        }
        task.resume()
    }
    
    func uploadArtwork(creatorEmail: String, creatorPassword: String, title: String,
                       description: String?, keyPhoto: UIImage, belongingRepo: UUID?, selfID: UUID,
                       completion: (() -> Void)?) {
        let descriptionParameter = getOptionalParameter(field: "description", value: description,
                                                        quotation: true)
        let belongingRepoParameter = getOptionalParameter(field: "belongingRepo", value: belongingRepo,
                                                          quotation: true)
        sendFile(url: APWebService.resourceServerURL, fileName: "NewRepo.jpeg", data:
            keyPhoto.jpegData(compressionQuality: 0.2)!) { urlPath, compressedURLPath in
                var request = self.getRequest(httpMethod: "POST")
                let query = """
                mutation UploadArtwork {
                    insertWork(id: "\(selfID)", creator: "\(creatorEmail.secured())",
                        password: "\(creatorPassword.secured())", title: "\(title.secured())",
                        \(descriptionParameter.secured()) keyPhoto: "\(urlPath)",
                        \(belongingRepoParameter) timestamp: \(self.now))
                }
                """
                request.httpBody = self.constructRequestBody(with: query)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    completion?()
                }
                task.resume()
        }
    }
    
    func uploadLecture(creatorEmail: String, creatorPassword: String, title: String,
                       description: String, keyPhoto: UIImage, content: NSData, selfID: UUID,
                       completion: (() -> Void)?) {
        let descriptionParameter = getOptionalParameter(field: "description", value: description,
                                                        quotation: true)
        sendFile(url: APWebService.resourceServerURL, fileName: "NewLecture.jpeg", data:
            keyPhoto.jpegData(compressionQuality: 0.2)!) { urlPath, compressedURLPath in
                var request = self.getRequest(httpMethod: "POST")
                let query = """
                mutation InsertLect {
                    insertLect(id: "\(selfID)", title: "\(title.secured())", \(descriptionParameter)
                        steps: "\(String(data: content as Data, encoding: .utf8)!.secured())",
                        creator: "\(creatorEmail.secured())", password: "\(creatorPassword.secured())",
                        timestamp: \(self.now), keyPhoto: "\(urlPath)")
                }
                """
                request.httpBody = self.constructRequestBody(with: query)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    completion?()
                }
                task.resume()
        }
    }
    
    func getRepoPreviewFeed(email: String? = nil, completion: (([ArtworkPreview]) -> Void)? = nil) {
        let userParameter = getOptionalParameter(field: "user", value: email, quotation: true)
        var request = getRequest(httpMethod: "POST")
        let query = """
            query GetRepoFeed {
                getRepoFeed(\(userParameter) timestamp: 429) {
                    title
                    id
                    keyArtwork {
                        keyPhoto
                    }
                    starter {
                        name
                        portrait
                    }
                    numberOfStars
                    numberOfArtworks
                    timestamp
                }
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try! JSON(data: data!)
            guard let repoArray = json["data"]["getRepoFeed"].array else {completion?([]);return}
            var previews: [ArtworkPreview] = []
            for repo in repoArray {
                previews.append(ArtworkPreview(json: repo))
            }
            completion?(previews)
        }
        task.resume()
    }
    
    func extendRepoPreviewFeed(timestamp: Date, email: String? = nil,
                               completion: (([ArtworkPreview]) -> Void)? = nil) {
        let userParameter = getOptionalParameter(field: "user", value: email, quotation: true)
        var request = getRequest(httpMethod: "POST")
        let query = """
            query ExtentRepoFeed {
                extendRepoFeed(\(userParameter) timestamp: \(timestamp.secondsSince1970)) {
                    title
                    id
                    keyArtwork {
                        keyPhoto
                    }
                    starter {
                        name
                        portrait
                    }
                    numberOfStars
                    numberOfArtworks
                    timestamp
                }
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try! JSON(data: data!)
            guard let repoArray = json["data"]["extendRepoFeed"].array else {completion?([]);return}
            var previews: [ArtworkPreview] = []
            for repo in repoArray {
                previews.append(ArtworkPreview(json: repo))
            }
            completion?(previews)
        }
        task.resume()
    }
    
    func getLecturePreviewFeed(email: String? = nil, completion: (([LecturePreview]) -> Void)? = nil) {
        let userParameter = getOptionalParameter(field: "user", value: email, quotation: true)
        var request = getRequest(httpMethod: "POST")
        let query = """
            query GetLectFeed {
                getLectFeed(\(userParameter) timestamp: 429) {
                    id
                    title
                    keyPhoto
                    creator {
                        email
                        name
                    }
                    numberOfStars
                    numberOfSteps
                    timestamp
                }
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try! JSON(data: data!)
            guard let lectureArray = json["data"]["getLectFeed"].array else {completion?([]);return}
            var previews: [LecturePreview] = []
            for lecture in lectureArray {
                previews.append(LecturePreview(json: lecture))
            }
            completion?(previews)
        }
        task.resume()
    }
    
    func extendLecturePreviewFeed(timestamp: Date, email: String? = nil,
                                  completion: (([LecturePreview]) -> Void)? = nil) {
        let userParameter = getOptionalParameter(field: "user", value: email, quotation: true)
        var request = getRequest(httpMethod: "POST")
        let query = """
            query ExtendLectFeed {
                extendLectFeed(\(userParameter) timestamp: \(timestamp.secondsSince1970)) {
                    id
                    title
                    keyPhoto
                    creator {
                        email
                        name
                    }
                    numberOfStars
                    numberOfSteps
                    timestamp
                }
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try! JSON(data: data!)
            guard let lectureArray = json["data"]["extendLectFeed"].array else {completion?([]);return}
            var previews: [LecturePreview] = []
            for lecture in lectureArray {
                previews.append(LecturePreview(json: lecture))
            }
            completion?(previews)
        }
        task.resume()
    }
    
    func getLectureContent(uuid: UUID, completion: ((Data) -> Void)?) {
        var request = getRequest(httpMethod: "POST")
        let query = """
            query GetLecture {
                getLecture(id: "\(uuid)") {
                    steps
                }
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try! JSON(data: data!)
            let contentString = json["data"]["getLecture"]["steps"].string!
            let content = try! JSON(parseJSON: contentString).rawData()
            completion?(content)
        }
        task.resume()
    }
    
    func getRepoArtworks(repoID: UUID, completion: (([BranchPreview]) -> Void)?) {
        var request = getRequest(httpMethod: "POST")
        let query = """
            query GetRepo {
                getRepo(id: "\(repoID)") {
                    artworks {
                        id
                        title
                        timestamp
                        keyPhoto
                    }
                }
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try! JSON(data: data!)
            guard let branchArray = json["data"]["getRepo"]["artworks"].array else {completion?([]);return}
            var previews: [BranchPreview] = []
            for branch in branchArray {
                previews.append(BranchPreview(json: branch))
            }
            completion?(previews)
        }
        task.resume()
    }
    
    func createRepo(creatorEmail: String, creatorPassword: String, title: String,
                    description: String?, selfID: UUID, keyArtworkID: UUID,
                    completion: (() -> Void)?) {
        let descriptionParameter = getOptionalParameter(field: "description", value: description,
                                                        quotation: true)
        var request = getRequest(httpMethod: "POST")
        let query = """
            mutation InsertRepo {
                insertRepo(id: "\(selfID)", title: "\(title)", \(descriptionParameter)
                           keyArtwork: "\(keyArtworkID)", starter: "\(creatorEmail)",
                           password: "\(creatorPassword)", timestamp: \(self.now))
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion?()
        }
        task.resume()
    }
    
    func checkForLogin(email: String, password: String, completion: ((String?) -> Void)?) {
        var request = getRequest(httpMethod: "POST")
        let query = """
            query CheckLogin {
                login(email: "\(email.secured())", password: "\(password.secured())")
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let json = try! JSON(data: data)
                let statusCode = json["data"]["login"]["status"].int
                completion?(self.translateStatusCode(status: statusCode!))
            }
        }
        task.resume()
    }
    
    func getUserInfo(email: String, completion: ((String?, String, UIImage?) -> Void)?) {
        var request = getRequest(httpMethod: "POST")
        let query = """
            query GetUserInfo {
                getUser(email: "\(email.secured())") {
                    name
                    compressedPortrait
                }
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let json = try! JSON(data: data)
                let name = json["data"]["getUser"]["name"].string
                let signature = json["data"]["getUser"]["signature"].string ?? ""
                let compressedPortraitPath = json["data"]["getUser"]["compressedPortrait"].string
                var portrait: UIImage? = nil
                if let compressedPortraitPath = compressedPortraitPath {
                    portrait = self.fetchPhoto(url: URL(string: compressedPortraitPath)!)
                }
                completion?(name, signature, portrait)
            }
        }
        task.resume()
    }
    
    @discardableResult
    func fetchPhoto(url: URL, completion: ((UIImage?) -> Void)? = nil) -> UIImage? {
        if completion == nil {
            let data = try! Data(contentsOf: url)
            return UIImage(data: data)!
        } else {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    completion?(UIImage(data: data))
                }
            }
            task.resume()
            return nil
        }
    }
    
    private func getOptionalParameter(field: String, value: Any?,
                                             quotation: Bool = false, comma: Bool = true) -> String {
        let tailing = comma ? "," : ""
        if value != nil {
            if quotation {
                return ("\(field): \"\(value!)\"" + tailing).secured()
            } else {
                return ("\(field): \(value!)" + tailing).secured()
            }
        } else {
            return ""
        }
    }
    
    private func translateStatusCode(status: Int) -> String? {
        switch status {
        case 0:
            return nil
        case -1:
            return "Wrong password."
        case -2:
            return "Illegal identity."
        case -3:
            return "User not exist."
        case -4:
            return "User already existed."
        case 1:
            return "Unknown error, please try later."
        default:
            return "Unknown error, please try later."
        }
    }
    
    private func sendFile(url: URL, fileName: String, data: Data,
        completion: ((String, String) -> Void)?) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "FuckEmperorXi"
        let fullData = photoDataToFormData(data: data, boundary: boundary, fileName: fileName)
        request.setValue("multipart/form-data; boundary=" + boundary,
                          forHTTPHeaderField: "Content-Type")
        request.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = fullData
        request.httpShouldHandleCookies = false
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let json = try! JSON(data: data!)
            let url = json["url"].string!
            let compressedURL = json["compressedURL"].string!
            completion?(url, compressedURL)
        }
        task.resume()
    }
    
    private func photoDataToFormData(data: Data,boundary: String,fileName: String) -> Data {
        let fullData = NSMutableData()
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        fullData.append(lineTwo.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        let lineThree = "Content-Type: image/jpg\r\n\r\n"
        fullData.append(lineThree.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        fullData.append(data as Data)
        let lineFive = "\r\n"
        fullData.append(lineFive.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        let lineSix = "--" + boundary + "--\r\n"
        fullData.append(lineSix.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        return fullData as Data
    }
    
    private func constructRequestBody(with query: String) -> Data {
        let body = RequestBody(operationName: nil, variables: [], query: query)
        let data = try! JSONEncoder().encode(body)
        return data
    }
    
    private func getRequest(httpMethod: String) -> URLRequest {
        var request = URLRequest(url: APWebService.backEndURL)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
