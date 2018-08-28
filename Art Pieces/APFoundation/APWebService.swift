//
//  APWebService.swift
//  Art Pieces
//
//  Created by 李灿晨 on 2018/8/28.
//  Copyright © 2018 李灿晨. All rights reserved.
//

import Foundation
import UIKit

struct RequestBody: Codable {
    var operationName: String?
    var variables: [Int]
    var query: String
}


class APWebService {
    
    static let backEndURL = URL(string: "https://artpieces.cn/api")!
    
    func registerUser(email: String, password: String,
                      completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = getPostRequest()
        let query = """
            mutation InsertUser {
                insertUser(email: \(email), name: \(email), password: \(password), portrait: "")
            }
        """
        request.httpBody = constructRequestBody(with: query)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
    }
    
    private func constructRequestBody(with query: String) -> Data {
        let body = RequestBody(operationName: nil, variables: [], query: query)
        let data = try! JSONEncoder().encode(body)
        return data
    }
    
    private func getPostRequest() -> URLRequest {
        var request = URLRequest(url: APWebService.backEndURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
}
