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
        /* TODO: create a dictionary of string to get this string from */
        self.navigationItem.title = "DySi Open"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        self.viewModel.fetchAllPosts { (error) in
            if let error = error {
                // TODO: show alert to user with a friendly error message
                print ("Error: ", error)
            } else {
                self.tableNode.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
