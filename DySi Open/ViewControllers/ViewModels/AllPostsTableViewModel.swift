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
    func getPostTitleToDisplay (for indexPath: IndexPath) -> String
    func getPostAuthorDisplayName (for indexPath: IndexPath) -> String
    func getPostDescription (for indexPath: IndexPath) -> String
    func getPostCreationDate (for indexPath: IndexPath) -> Date
    func getDisplayableCreatedDate (for indexPath: IndexPath) -> String
    func getPostImageLinkString (for indexPath: IndexPath) -> String
    func getPostPermaLinkString (for indexPath: IndexPath) -> String
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
    
    func getPostTitleToDisplay(for indexPath: IndexPath) -> String {
        // TODO: remove the string from here. Pull such text from a different storage of strings
        return self.allPosts?[indexPath.row].title ?? "Not Available"
    }
    
    func getPostAuthorDisplayName(for indexPath: IndexPath) -> String {
        // TODO:
        return self.allPosts?[indexPath.row].author?.getAuthorDisplayName() ?? "Not Available"
    }
    
    func getPostDescription(for indexPath: IndexPath) -> String {
        // TODO:
        return self.allPosts?[indexPath.row].descriptionText ?? "Not Available"
    }
    
    func getPostCreationDate(for indexPath: IndexPath) -> Date {
        // TODO:
        return Date()
    }
    
    func getDisplayableCreatedDate(for indexPath: IndexPath) -> String {
        // TODO:
        return self.allPosts?[indexPath.row].getDisplayableDateString() ?? "Not Available"
    }
    
    func getPostImageLinkString(for indexPath: IndexPath) -> String {
        // TODO: replace this with a default image
        return self.allPosts?[indexPath.row].getCoverImageURLString() ?? "Not Available"
    }
    
    func getPostPermaLinkString(for indexPath: IndexPath) -> String {
        // TODO:
        return self.allPosts?[indexPath.row].getPermaLinkUrlString() ?? "Not Available"
    }
    
}
