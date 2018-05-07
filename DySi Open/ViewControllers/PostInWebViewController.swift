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
    var currentURL: URL!

    init(linkToOpen: URL) {
        self.currentURL = linkToOpen

        let node = ASDisplayNode { () -> UIView in
            let webConfiguration = WKWebViewConfiguration()
            let webView = WKWebView(frame: .zero, configuration: webConfiguration)
            return webView
        }
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let myRequest = URLRequest(url: currentURL)
        (self.webNode.view as! WKWebView).load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
