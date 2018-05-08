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

/**
 ViewModel to link DySiPost with AllPostsViewController
 */
class AllPostsTableViewModel {
    /// Owned dataManager to get data over network
    private var dysiDataManager: DySiDataManagerProtocol!

    // Holds data received from api call
    private var allPosts: [DySiPost]?

    private var cellViewModels: [PostTableNodeCellViewModel] = [PostTableNodeCellViewModel]() {
        didSet {
            self.reloadTableNodeClosure?()
        }
    }

    init(dataManager: DySiDataManagerProtocol) {
        self.dysiDataManager = dataManager
    }

    var reloadTableNodeClosure: (()->())?
}

extension AllPostsTableViewModel: AllPostTableViewModelProtocol {
    /**
     Get data from over the network and convert them to Posts and cellViewModels
     - Parameter completion: Callback to call upon completion of network call.
     - Parameter error: Any error upon completion of network call. Make it `nil` to
     indicate success
     */
    func fetchAllPosts(completion: @escaping (_ error: Error?) -> Void) {
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

    /**
     Gets the number of rows. Used to provide data to UITableViewDataSource methods
     - Parameter section: The section of a UITableView
     - Returns: Number of cells to show in a section
     */
    func getNumberOfRowsInSection(in section: Int) -> Int {
        return self.allPosts?.count ?? 0
    }

    /**
     Gets the CellViewModel to display in UITableView.
     Used to provide data to UITableViewDataSource methods.
     - Parameter indexPath: The indexpath of a UITableView
     - Returns: The data to show in a UITableViewCell
     */
    func getCellViewModel(for indexPath: IndexPath) -> PostTableNodeCellViewModelProtocol? {
        if self.cellViewModels.count > 0 {
            return self.cellViewModels[indexPath.row]
        }
        return nil
    }

    /**
     Gets the permalink of a post.
     - Parameter indexPath: The indexpath of a UITableView
     - Returns: A link to open
     */
    func getPermalinkOfPost(for indexPath: IndexPath) -> URL {
        if let urlString = self.allPosts?[indexPath.row].cleanPermaLinkString, let url = URL(string: urlString) {
            return url
        }
        return  URL(string: Constants.ForDySiAPI.URLS.FallBackPermaLink)!
    }
}

// private methods
extension AllPostsTableViewModel {
    /**
     Iterates through an array or dictionary and
     initializes DySiPost objects from each dictionary to return
     an array of DySiPosts
     - Parameter posts: Dictionary to use to initialize DySiPost
     - Returns: An array of DySiPost
     */
    private func createListOfPosts(from posts: [[String : Any]]) -> [DySiPost] {
        var newPosts: [DySiPost] = []
        for eachPostDict in posts {
            if let currNewPost = DySiPost(postDict: eachPostDict) {
                newPosts.append(currNewPost)
            }
        }
        return newPosts
    }

    /**
     Iterates through an array or DySiPost and
     initializes PostTableNodeCellViewModel objects from each DySiPost
     to return an array of PostTableNodeCellViewModel
     - Parameter posts: An array of DySiPost
     - Returns: An array of PostTableNodeCellViewModel
     */
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
