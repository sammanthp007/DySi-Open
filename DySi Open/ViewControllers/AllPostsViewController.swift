//
//  AllPostsViewController.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/5/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit

import AsyncDisplayKit

/**
 View controller housing a table view of posts
 */
class AllPostsViewController: ASViewController<ASTableNode> {
    /// To indicate to users that expensive work being done in background
    var activityIndicator: UIActivityIndicatorView!
    /// The table view being displayed on screen
    var tableNode: ASTableNode!

    /// Link between the model and View for this VC
    lazy var viewModel: AllPostTableViewModelProtocol = {
        return AllPostsTableViewModel()
    }()

    var screenSizeForWidth: CGSize = {
        let screenRect = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        return CGSize(width: screenRect.size.width * screenScale, height: screenRect.size.width * screenScale)
    }()

    init() {
        let tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        self.tableNode = tableNode
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initView()
        initViewModel()

        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        self.fetchAllPosts { (error) in
            // remove activity indicator
            self.activityIndicator.stopAnimating()

            if let error = error {
                ErrorHandler.displayErrorOnDeviceScreen(viewController: self, error: error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AllPostsViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        let numberOfPosts = self.viewModel.getNumberOfRowsInSection(in: section)
        // show empty message on tableView, if empty
        if numberOfPosts == 0 {
            self.tableNode.setEmptyMessage()
        } else {
            self.tableNode.restore()
        }
        return numberOfPosts
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let nodeBlock: ASCellNodeBlock = {
            if let cellViewModel = self.viewModel.getCellViewModel(for: indexPath) {
                return PostTableNodeCell(postCellViewModel: cellViewModel)
            }
            return ASCellNode()
        }
        return nodeBlock
    }
}

extension AllPostsViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        let viewController = PostInWebViewController(linkToOpen: self.viewModel.getPermalinkOfPost(for: indexPath))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AllPostsViewController {
    /// Allows ViewModel the logic to reload table
    private func initViewModel() {
        viewModel.reloadTableNodeClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableNode.reloadData()
            }
        }
    }

    /// Initializes components to display on view
    private func initView() {
        self.navigationItem.title = Constants.UILabels.AllPostViewNavigationItemTitle

        setupPullToRefresh()
        setupActivityIndicator()
    }

    /**
     Gets all posts
     - Parameter completion: Callback upon completion of network call
     - Parameter error: Any error during network call
     */
    private func fetchAllPosts(completion: @escaping (_ error: Error?) -> Void) {
        self.viewModel.fetchAllPosts { (error) in
            if let error = error {
                return completion(error)
            } else {
                return completion(nil)
            }
        }
    }

    /// Adds refresh control to top of table view
    private func setupPullToRefresh() -> Void {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        (tableNode.view as UITableView).insertSubview(refreshControl, at: 0)
    }

    /// Creates activity indicator and place it at the center of the view being loaded
    private func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityIndicator = activityIndicator
        let bounds = self.node.frame
        var refreshRect = activityIndicator.frame
        refreshRect.origin = CGPoint(x: (bounds.size.width - activityIndicator.frame.size.width) / 2.0, y: (bounds.size.height - activityIndicator.frame.size.height) / 2.0)
        activityIndicator.frame = refreshRect
        self.node.view.addSubview(activityIndicator)
    }

    /// Adds pull to refresh control
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.fetchAllPosts { [weak self] (error) in
            if let error = error {
                ErrorHandler.displayErrorOnDeviceScreen(viewController: self!, error: error) { _ in
                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                }
            } else {
                DispatchQueue.main.async {
                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}
