//
//  PostInWebViewController.swift
//  DySi Open
//
//  Created by Samman Thapa on 5/6/18.
//  Copyright © 2018 Samman Labs. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import WebKit

class PostInWebViewController: ASViewController<ASDisplayNode> {

    var webNode: ASDisplayNode!
    var webView: WKWebView!
    var currentURL: URL!

    init(linkToOpen: URL) {
        self.currentURL = linkToOpen
        let node = ASDisplayNode()
        super.init(node: node)
        self.webNode = node
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
