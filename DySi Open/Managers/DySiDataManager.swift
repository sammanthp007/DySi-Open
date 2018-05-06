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
    func fetchAllPublicPosts(completion: (_ error: Error?, _ allPosts: [[String: Any]]) -> Void) -> Void
}

class DySiDataManager: DySiDataManagerProtocol {
    func fetchAllPublicPosts(completion: (Error?, [[String : Any]]) -> Void) {
        print ("Make network call here")
    }
}
