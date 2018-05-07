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
    var allPosts: [DySiPost]?

    init() {
        self.dysiDataManager = DySiDataManager()
    }
}

extension AllPostsTableViewModel: AllPostTableViewModelProtocol {
    func fetchAllPosts(completion: @escaping (Error?) -> Void) {
        self.dysiDataManager.fetchAllPublicPosts { (error, rawPostsDict) in
            if let error = error {
                return completion(error)
            }
            /* since this will affect the UI */
            DispatchQueue.main.async {
                /* probably this is where we convert the dictionary to model objects */
                //                self.allCharacters = allCharacters
                var newPost: [DySiPost] = []
                // TODO: do not force unwrap
                for eachPostDict in rawPostsDict! {
                    // TODO: do not force unwrap
                    newPost.append(DySiPost(postDict: eachPostDict)!)
                }
                
                self.allPosts = newPost
                completion(nil)
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
