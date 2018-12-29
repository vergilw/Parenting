//
//  WebViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: BaseViewController {

    var url: URL?
    
    lazy fileprivate var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reload()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubview(webView)
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        if let URL = url {
            webView.load(URLRequest(url: URL))
        }
        
    }
    
    // MARK: - ============= Action =============
    @objc override func backBarItemAction() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}


extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        HUDService.sharedInstance.showFetchingView(target: self.view)
        print(#function)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        HUDService.sharedInstance.hideFetchingView(target: self.view)
        
        HUDService.sharedInstance.showNoNetworkView(target: self.view) { [weak self] in
            self?.reload()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUDService.sharedInstance.hideFetchingView(target: self.view)
        print(#function)
    }
}
