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
        setupActivityIndicator()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
        }
        self.fetchAllPosts()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AllPostsViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.getNumberOfRowsInSection(in: section)
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
    func fetchAllPosts() {
        self.viewModel.fetchAllPosts { (error) in
            // remove the activity indicator
            self.activityIndicator.stopAnimating()
            if let error = error {
                // TODO: show alert to user with a friendly error message
                print ("Error: ", error)
            } else {
                DispatchQueue.main.async {
                    self.tableNode.reloadData()
                }
            }
        }
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
}
