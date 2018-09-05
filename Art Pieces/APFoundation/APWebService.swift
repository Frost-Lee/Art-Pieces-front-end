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
    
    static let defaultManager = APWebService()
    
    func registerUser(email: String, password: String, completion: ((String?) -> Void)?) {
        var request = self.getRequest(httpMethod: "POST")
        let query = """
        mutation InsertUser {
        insertUser(email: "\(email)", name: "\(email)", password: "\(password)")
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
                       completion: ((() -> Void)?)) {
        let descriptionParameter = getOptionalParameter(field: "description", value: description,
                                                        quotation: true)
        let belongingRepoParameter = getOptionalParameter(field: "belongingRepo", value: belongingRepo)
        sendFile(url: APWebService.resourceServerURL, fileName: "NewRepo.jpeg", data:
            keyPhoto.jpegData(compressionQuality: 0.2)!) { urlPath, compressedURLPath in
                var request = self.getRequest(httpMethod: "POST")
                let query = """
                mutation UploadArtwork {
                    insertWork(id: "\(selfID)", creator: "\(creatorEmail)",
                        password: "\(creatorPassword)", title: "\(title)",
                        \(descriptionParameter) keyPhoto: "\(urlPath)",
                        \(belongingRepoParameter) timestamp: \(Date().timeIntervalSince1970 * 1000))
                }
                """
                print(query)
                request.httpBody = self.constructRequestBody(with: query)
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    print(String(data: data!, encoding: .utf8) ?? "No Response")
                    completion?()
                }
                task.resume()
        }
    }
    
    func createRepo(creatorEmail: String, creatorPassword: String, title: String,
                    description: String?, selfID: UUID, keyArtworkID: UUID,
                    completion: ((() -> Void)?)) {
        let descriptionParameter = getOptionalParameter(field: "description", value: description,
                                                        quotation: true)
        var request = getRequest(httpMethod: "POST")
        let query = """
        mutation InsertRepo {
            insertRepo(id: "\(selfID)", title: "\(title)", \(descriptionParameter)
                       keyArtwork: "\(keyArtworkID)", starter: "\(creatorEmail)",
                       password: "\(creatorPassword)", timestamp: \(Date().timeIntervalSince1970 * 1000))
        }
        """
        request.httpBody = constructRequestBody(with: query)
        print(query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(String(data: data!, encoding: .utf8) ?? "No Response")
            completion?()
        }
        task.resume()
    }
    
    func checkForLogin(email: String, password: String, completion: ((String?) -> Void)?) {
        var request = getRequest(httpMethod: "POST")
        let query = """
            query CheckLogin {
                login(email: "\(email)", password: "\(password)")
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
    
    func getUserInfo(email: String, completion: (((String, String, UIImage?) -> Void)?)) {
        var request = getRequest(httpMethod: "POST")
        let query = """
            query GetUserInfo {
                getUser(email: "\(email)") {
                    name
                    compressedPortrait
                }
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let json = try! JSON(data: data)
                let name = json["data"]["getUser"]["name"].string!
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
    
    func fetchPhoto(url: URL) -> UIImage {
        let data = try! Data(contentsOf: url)
        return UIImage(data: data)!
    }
    
    private func getOptionalParameter(field: String, value: Any?,
                                             quotation: Bool = false, comma: Bool = true) -> String {
        let tailing = comma ? "," : ""
        if value != nil {
            if quotation {
                return "\(field): \"\(value!)\"" + tailing
            } else {
                return "\(field): \(value!)" + tailing
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
