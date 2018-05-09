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
import Alamofire

class PostInWebViewController: ASViewController<ASDisplayNode> {
    var webNode: ASDisplayNode!
    var currentURL: URL!
    var progressView: UIProgressView!

    var webView: WKWebView {
        get {
            return self.webNode.view as! WKWebView
        }
    }

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

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressView.removeFromSuperview()
    }

    /// Updates the progress bar on changes to estimated progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let change = change else {
            return
        }

        if keyPath == "estimatedProgress" {
            if let progress = (change[NSKeyValueChangeKey.newKey] as AnyObject).floatValue {
                progressView.progress = progress;
            }
            return
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupProgressView()
        self.webView.navigationDelegate = self

        // add observer
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        self.showAlertIfNotConnectedToInternetAndPopViewController()
        // load the web page
        let myRequest = URLRequest(url: currentURL)
        (self.webNode.view as! WKWebView).load(myRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Adds progress bar to the bottom of the screen
    func setupProgressView() -> Void {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.sizeToFit()
        self.progressView = progressView
        progressView.tintColor = Constants.ForPostInWebViewController.ProgressViewColor

        if let navBar = self.navigationController?.navigationBar {
            let refreshRect = CGRect(x: 0, y: navBar.frame.size.height, width: navBar.frame.size.width, height: 2)
            progressView.frame = refreshRect
            navBar.addSubview(progressView)
        } else {
            let bounds = self.node.frame
            let refreshRect = CGRect(x: 0, y: (bounds.size.height - progressView.frame.size.height), width: bounds.width, height: 2)
            progressView.frame = refreshRect
            self.node.view.addSubview(progressView)
        }
    }
}

extension PostInWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
}

extension PostInWebViewController {
    func showAlertIfNotConnectedToInternetAndPopViewController() {
        if !NetworkReachabilityManager()!.isReachable {
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your connection and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
