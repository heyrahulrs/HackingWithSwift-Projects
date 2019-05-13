//
//  DetailViewController.swift
//  Project7
//
//  Created by Rahul on 5/12/19.
//  Copyright © 2019 Rahul Sharma. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    
    var selectedPetition: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let selectedPetition = selectedPetition else { return }
        
        guard let path = Bundle.main.path(forResource: "html", ofType: "txt") else { return }
        
        let html = try! String(contentsOfFile: path)
        
        let replacedHTML = html.replacingOccurrences(of: "selectedPetition", with: selectedPetition.body)
        
        webView.loadHTMLString(replacedHTML, baseURL: nil)
        
    }

}
