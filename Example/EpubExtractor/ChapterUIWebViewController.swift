//
//  ChapterUIWebViewController.swift
//  EpubExtractor_Example
//
//  Created by junoyang on 12/22/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

class ChapterUIWebViewController: UIViewController {
    @IBOutlet weak var webView : UIWebView!
    
    var content: String!
    var url: URL! {
        didSet {
            do {
                content = try String(contentsOf: url, encoding: .ascii)
            } catch let error {
                print("Error: \(error)")
            }
        }
    }
    
    override func loadView() {
        super.loadView()
//        webView = UIWebView(coder: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        webView.load(URLRequest(url: url!))
        if content != nil {
            webView.loadHTMLString(content, baseURL: nil)
        }
    }
}
