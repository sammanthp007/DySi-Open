//
//  ASTableNode.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/7/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit
import AsyncDisplayKit

extension ASTableNode {
    /**
     Set a message to the background view of the UITableView of ASTableNode to indicate the table is empty
     */
    func setEmptyMessage() -> Void {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = "No posts available.\n Try again and pull to refresh"
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        let tableView = self.view as UITableView
        tableView.separatorStyle = .none
        tableView.backgroundView = messageLabel
    }

    /**
     Remove the background view if previously set
     */
    func restore() {
        let tableView = self.view as UITableView
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }
}
