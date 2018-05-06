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
    func getPostAuthor (for indexPath: IndexPath) -> DySiPostAuthor
    func getPostDescription (for indexPath: IndexPath) -> String
    func getPostCreationDate (for indexPath: IndexPath) -> Date
    func getPostImageLink (for indexPath: IndexPath) -> URL
    func getPostPermaLink (for indexPath: IndexPath) -> URL
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
                completion(error)
            }
            /* since this will affect the UI */
            DispatchQueue.main.async {
                /* probably this is where we convert the dictionary to model objects */
                //                self.allCharacters = allCharacters
                print (rawPostsDict)
                completion(nil)
            }
        }
    }
    
    
    func getNumberOfRowsInSection(in section: Int) -> Int {
        return self.allPosts?.count ?? 0
    }
    
    func getPostTitleToDisplay(for indexPath: IndexPath) -> String {
        // TODO:
        return "title"
    }
    
    func getPostAuthor(for indexPath: IndexPath) -> DySiPostAuthor {
        // TODO:
        return DySiPostAuthor()
    }
    
    func getPostDescription(for indexPath: IndexPath) -> String {
        // TODO:
        return "description"
    }
    
    func getPostCreationDate(for indexPath: IndexPath) -> Date {
        // TODO:
        return Date()
    }
    
    func getPostImageLink(for indexPath: IndexPath) -> URL {
        // TODO:
        return URL(string: "www.google.com")!
    }
    
    func getPostPermaLink(for indexPath: IndexPath) -> URL {
        // TODO:
        return URL(string: "www.google.com")!
    }
    
}
