//
//  AllPostsViewController.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/5/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit

import AsyncDisplayKit

class AllPostsViewController: ASViewController<ASTableNode> {
    var activityIndicator: UIActivityIndicatorView!

    var viewModel: AllPostTableViewModelProtocol!
    var tableNode: ASTableNode!

    var screenSizeForWidth: CGSize = {
        let screenRect = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        return CGSize(width: screenRect.size.width * screenScale, height: screenRect.size.width * screenScale)
    }()

    init() {
        self.viewModel = AllPostsTableViewModel()

        let tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        self.tableNode = tableNode
        self.tableNode.dataSource = self
        self.tableNode.delegate = self

        self.navigationItem.title = Constants.UILabels.AllPostViewNavigationItemTitle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupPullToRefresh()
        setupActivityIndicator()

        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        self.fetchAllPosts { (error) in
            // remove activity indicator
            self.activityIndicator.stopAnimating()

            if let error = error {
                ErrorHandler.displayErrorOnDeviceScreen(viewController: self, error: error)
            } else {
                DispatchQueue.main.async {
                    self.tableNode.reloadData()
                }
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
        if numberOfPosts == 0 {
            self.tableNode.setEmptyMessage()
        } else {
            self.tableNode.restore()
        }
        return numberOfPosts
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let nodeBlock: ASCellNodeBlock = {
            // TODO: forced unwrapping here
            return PostTableNodeCell(postModel: self.viewModel.getOnePost(for: indexPath)!)
        }

        return nodeBlock
    }
}

extension AllPostsViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        print ("selected at: ", indexPath.row)
        let viewController = PostInWebViewController(linkToOpen: self.viewModel.getPermalinkOfPost(for: indexPath))
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension AllPostsViewController {
    // helper functions
    func fetchAllPosts(completion: @escaping (_ error: Error?) -> Void) {
        self.viewModel.fetchAllPosts { (error) in
            if let error = error {
                return completion(error)
            } else {
                return completion(nil)
            }
        }
    }

    func setupPullToRefresh() -> Void {
        // set up pull to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        // add refresh control to table view
        (tableNode.view as UITableView).insertSubview(refreshControl, at: 0)
    }

    func setupActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityIndicator = activityIndicator
        let bounds = self.node.frame
        var refreshRect = activityIndicator.frame
        refreshRect.origin = CGPoint(x: (bounds.size.width - activityIndicator.frame.size.width) / 2.0, y: (bounds.size.height - activityIndicator.frame.size.height) / 2.0)
        activityIndicator.frame = refreshRect
        self.node.view.addSubview(activityIndicator)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl) {
        self.fetchAllPosts { (error) in
            if let error = error {
                ErrorHandler.displayErrorOnDeviceScreen(viewController: self, error: error) { _ in
                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                }
            } else {
                DispatchQueue.main.async {
                    // update table
                    self.tableNode.reloadData()

                    // Tell the refreshControl to stop spinning
                    refreshControl.endRefreshing()
                }
            }
        }
    }
}
