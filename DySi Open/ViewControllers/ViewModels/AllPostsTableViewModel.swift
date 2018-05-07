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
    func getCellViewModel(for indexPath: IndexPath) -> PostTableNodeCellViewModelProtocol?
    func getPermalinkOfPost(for indexPath: IndexPath) -> URL
    var reloadTableNodeClosure: (()->())? { get set }
}

class AllPostsTableViewModel {
    // owns the dataManager to get data over network
    var dysiDataManager: DySiDataManagerProtocol!

    // Holds data received from api call
    private var allPosts: [DySiPost]?

    private var cellViewModels: [PostTableNodeCellViewModel] = [PostTableNodeCellViewModel]() {
        didSet {
            self.reloadTableNodeClosure?()
        }
    }

    init() {
        self.dysiDataManager = DySiDataManager()
    }

    var reloadTableNodeClosure: (()->())?
}

extension AllPostsTableViewModel: AllPostTableViewModelProtocol {
    func fetchAllPosts(completion: @escaping (Error?) -> Void) {
        self.dysiDataManager.fetchAllPublicPosts { [weak self] (error, rawDict) in
            if let error = error {
                return completion(error)
            } else if let rawPostsDict = rawDict {
                // convert dictionary to Post objects
                self?.allPosts = self?.createListOfPosts(from: rawPostsDict)
                // create an array of tableNodeViewModels from Posts
                self?.cellViewModels = self?.createListOfTableNodeCellViewModels(from: self?.allPosts) ?? []
                return completion(nil)
            } else {
                let newError = NSError(domain: "DySiAllPostViewModelError", code: 100, userInfo: ["message": "DySiDataManager gave neither error nor rawDict"])
                return completion(newError)
            }
        }
    }

    func getNumberOfRowsInSection(in section: Int) -> Int {
        return self.allPosts?.count ?? 0
    }

    func getCellViewModel(for indexPath: IndexPath) -> PostTableNodeCellViewModelProtocol? {
        return self.cellViewModels[indexPath.row]
    }

    func getPermalinkOfPost(for indexPath: IndexPath) -> URL {
        if let urlString = self.allPosts?[indexPath.row].cleanPermaLinkString, let url = URL(string: urlString) {
            return url
        }
        return  URL(string: Constants.ForDySiAPI.URLS.FallBackPermaLink)!
    }
}

// private methods
extension AllPostsTableViewModel {
    private func createListOfPosts(from posts: [[String : Any]]) -> [DySiPost] {
        var newPosts: [DySiPost] = []
        for eachPostDict in posts {
            if let currNewPost = DySiPost(postDict: eachPostDict) {
                newPosts.append(currNewPost)
            }
        }
        return newPosts
    }

    private func createListOfTableNodeCellViewModels(from posts: [DySiPost]?) -> [PostTableNodeCellViewModel] {
        var viewModels: [PostTableNodeCellViewModel] = []
        guard let posts = posts else {
            return viewModels
        }

        for post in posts {
            viewModels.append(PostTableNodeCellViewModel(post: post))
        }
        return viewModels
    }
}
