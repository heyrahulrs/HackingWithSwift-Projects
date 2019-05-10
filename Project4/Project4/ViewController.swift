//
//  ViewController.swift
//  Project4
//
//  Created by Rahul on 5/10/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    
    var websites = ["apple.com", "www.hackingwithswift.com", "tesla.com"]
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(didTapOpenButton))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        
        let progressButton = UIBarButtonItem(customView: progressView)
        
        toolbarItems = [backButton, spacer, progressButton, spacer, forwardButton]
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new
            , context: nil)
        
        navigationController?.isToolbarHidden = false
        
        let url = URL(string: "https://" + websites[0])!
        let request = URLRequest(url: url)
        
        webView.load(request)
        webView.allowsBackForwardNavigationGestures = true
        
    }
    
    @objc func didTapOpenButton() {
        let actionSheet = UIAlertController(title: "Open...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            let action = UIAlertAction(title: website, style: .default, handler: openPage)
            actionSheet.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true)

    }
    
    @objc func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }


}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        decisionHandler(.cancel)
        
        //the code below has some issues
        //showAlert(title: "Website Blocked", message: "The website you're trying to access is blocked")
        
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .default)
        
        alert.addAction(action)
        
        present(alert, animated: true)
    }
    
}

