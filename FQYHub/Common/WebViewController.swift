//
//  WebViewController.swift
//  FQYHub
//
//  Created by ysq on 2019/7/8.
//  Copyright © 2019 FengQingYang. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {

    private var webView: WKWebView!
    
    private var progress: UIProgressView!
    
    var url: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupRequest()
    }
    
    private func setupSubviews() {
        
        webView = WKWebView(frame: self.view.bounds)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        self.view.addSubview(webView)
        
        progress = UIProgressView(frame: CGRect(x: 0, y: (self.navigationController?.navigationBar.height)!, width: UIScreen.main.bounds.width, height: 10))
        progress.progressTintColor = LightTheme().primary
        progress.trackTintColor = .clear
        navigationController?.navigationBar.addSubview(progress)
        
        
        webView.addObserver(self, forKeyPath: "title", options: .new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
    }
    
    private func setupRequest() {
        
        guard let _url = url else {
            view.showFail(with: "url error!")
            return
        }
        let request = URLRequest(url: _url.url!)
        webView.load(request)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let path = keyPath else {
            return
        }
        if path == "title" {
            self.title = change?[.newKey] as? String ?? ""
        }
        if path == "estimatedProgress" {
            self.progress.alpha = 1
            self.progress.setProgress(Float(self.webView.estimatedProgress), animated: true)
            if self.webView.estimatedProgress >= 1.0 {
                UIView.animate(withDuration: 0.25, animations: {
                    self.progress.alpha = 0
                }) { (_) in
                    self.progress.progress = 0
                }
            }
        }
    }

    deinit {
        self.webView.removeObserver(self, forKeyPath: "title")
        self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }

}

extension WebViewController: WKNavigationDelegate, WKUIDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
}
