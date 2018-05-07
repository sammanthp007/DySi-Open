//
//  AllPostsTableViewModel.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/5/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import Foundation

protocol AllPostTableViewModelProtocol {
    func fetchAllPosts (completion: @escaping (_ error: Error?) -> Void) -> Void
    func getNumberOfRowsInSection (in section: Int) -> Int
    func getOnePost(for indexPath: IndexPath) -> DySiPost?
    func getPermalinkOfPost(for indexPath: IndexPath) -> URL
}

class AllPostsTableViewModel {
    // owns the dataManager to get data over network
    var dysiDataManager: DySiDataManagerProtocol!
    
    // Holds data received from api call
    private var allPosts: [DySiPost]?

    init() {
        self.dysiDataManager = DySiDataManager()
    }
}

extension AllPostsTableViewModel: AllPostTableViewModelProtocol {
    func fetchAllPosts(completion: @escaping (Error?) -> Void) {
        self.dysiDataManager.fetchAllPublicPosts { (error, rawDict) in
            if let error = error {
                return completion(error)
            } else if let rawPostsDict = rawDict {
                // since this will affect the UI
                DispatchQueue.main.async {
                    // convert dictionary to model objects
                    var newPost: [DySiPost] = []
                    for eachPostDict in rawPostsDict {
                        if let currNewPost = DySiPost(postDict: eachPostDict) {
                            newPost.append(currNewPost)
                        }
                    }
                    
                    self.allPosts = newPost
                    return completion(nil)
                }
            } else {
                let newError = NSError(domain: "DySiAllPostViewModelError", code: 100, userInfo: ["message": "DySiDataManager gave neither error nor rawDict"])
                return completion(newError)
            }
        }
    }
    
    
    func getNumberOfRowsInSection(in section: Int) -> Int {
        return self.allPosts?.count ?? 0
    }
    
    func getOnePost(for indexPath: IndexPath) -> DySiPost? {
        return self.allPosts?[indexPath.row]
    }
    
    func getPermalinkOfPost(for indexPath: IndexPath) -> URL {
        if let urlString = self.allPosts?[indexPath.row].cleanPermaLinkString, let url = URL(string: urlString) {
            return url
        }
        return  URL(string: Constants.ForDySiAPI.URLS.FallBackPermaLink)!
    }
}
