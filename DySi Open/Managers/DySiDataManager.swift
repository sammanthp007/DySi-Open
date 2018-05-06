//
//  DySiDataManager.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/5/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import Foundation

import Alamofire

protocol DySiDataManagerProtocol {
    func fetchAllPublicPosts(completion: @escaping (_ error: Error?, _ allPosts: [[String: Any]]?) -> Void) -> Void
}

class DySiDataManager: DySiDataManagerProtocol {
    func fetchAllPublicPosts(completion: @escaping (Error?, [[String : Any]]?) -> Void) {
        print ("Make network call here")
        
        /* TODO: get the url from a different location, where all hardcoded urls are stored */
        guard let url = URL(string: "https://www.dysiopen.com/v1/posts/public") else {
            let newError = NSError(domain: "DySiDataManagerError", code: 100, userInfo: ["message": " Could not unwrap the url for getting all public posts"])
            completion(newError, nil)
            return
        }
        
        Alamofire.request(url).responseJSON { (response) in
            if let rawPosts = response.result.value as? [String: Any], let posts = rawPosts["posts"] as? [[String: Any]]{
                completion(nil, posts)
            } else {
                let newError = NSError(domain: "DySiDataManagerError", code: 404, userInfo: ["message": "Could not find any data over network"])
                completion(newError, nil)
            }
        }

    }
}
