//
//  ChapterViewController.swift
//  EpubExtractor_Example
//
//  Created by Jun Ouyang on 12/6/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import SwiftSoup
import EpubExtractor

class ChapterViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet var webView : WKWebView!
    
    var content: String!
    var nextChapter: ChapterItem!
    var chapter: ChapterItem!

    override func loadView() {
        webView = createWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if content != nil {
            webView.loadHTMLString(content, baseURL: nil)
        }
    }
}

let viewportScriptString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); meta.setAttribute('initial-scale', '3'); meta.setAttribute('maximum-scale', '5'); meta.setAttribute('minimum-scale', '1'); meta.setAttribute('user-scalable', 'no'); document.getElementsByTagName('head')[0].appendChild(meta);"
//    let disableSelectionScriptString = "document.documentElement.style.webkitUserSelect='none';"
//    let disableCalloutScriptString = "document.documentElement.style.webkitTouchCallout='none';"

fileprivate func createWebView() -> WKWebView? {
    // 1 - Make user scripts for injection
    let viewportScript = WKUserScript(source: viewportScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    //        let disableSelectionScript = WKUserScript(source: disableSelectionScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    //        let disableCalloutScript = WKUserScript(source: disableCalloutScriptString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    
    // 2 - Initialize a user content controller
    // From docs: "provides a way for JavaScript to post messages and inject user scripts to a web view."
    let controller = WKUserContentController()
    
    // 3 - Add scripts
    controller.addUserScript(viewportScript)
    //        controller.addUserScript(disableSelectionScript)
    //        controller.addUserScript(disableCalloutScript)
    
    // 4 - Initialize a configuration and set controller
    let config = WKWebViewConfiguration()
    config.userContentController = controller
    
    // 5 - Initialize webview with configuration
    let webView = WKWebView(frame: CGRect.zero, configuration: config)
    
    // 6 - Webview options
    webView.scrollView.isScrollEnabled = true               // Make sure our view is interactable
    webView.scrollView.bounces = false                    // Things like this should be handled in web code
    webView.scrollView.isPagingEnabled = true
    webView.allowsBackForwardNavigationGestures = false   // Disable swiping to navigate
    webView.contentMode = .scaleAspectFit                    // Scale the page to fill the web view
    // 7 - Set the scroll view delegate
    webView.scrollView.delegate = ChapterViewScrollViewDelegate.shared
    return webView
}

class ChapterViewScrollViewDelegate: NSObject, UIScrollViewDelegate {
    
    // MARK: - Shared delegate
    static var shared = ChapterViewScrollViewDelegate()
    var count: Int = 0
    
    // MARK: - UIScrollViewDelegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        print("viewForZoomingInScrollView ==========")
        return createWebView()
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        scrollView.refreshControl()
//        scrollView.reloadInputViews()
//        print("view did zoom" + String(count) + "=====")
        count += 1
    }
}
