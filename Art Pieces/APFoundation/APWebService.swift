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
    
    static let defaultManager = APWebService()
    
    func registerUser(email: String, password: String,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = getRequest(httpMethod: "POST")
        let query = """
            mutation InsertUser {
                insertUser(email: "\(email)", name: "\(email)", password: "\(password)")
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
    func checkForLogin(email: String, password: String, completion: @escaping (String?) -> Void) {
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
                completion(self.translateStatusCode(status: statusCode!))
            }
        }
        task.resume()
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
    
    private func sendFile(urlPath: String, fileName: String, data: Data,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let url = URL(string: urlPath)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "FuckEmperorXi"
        let fullData = photoDataToFormData(data: data, boundary: boundary, fileName: fileName)
        request.setValue("multipart/form-data; boundary=" + boundary,
                          forHTTPHeaderField: "Content-Type")
        request.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")
        request.httpBody = fullData
        request.httpShouldHandleCookies = false
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
    }
    
    private func photoDataToFormData(data: Data,boundary: String,fileName: String) -> Data {
        let fullData = NSMutableData()
        let lineOne = "--" + boundary + "\r\n"
        fullData.append(lineOne.data(
            using: String.Encoding.utf8,
            allowLossyConversion: false)!)
        let lineTwo = "Content-Disposition: form-data; name=\"image\"; filename=\"" + fileName + "\"\r\n"
        NSLog(lineTwo)
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
