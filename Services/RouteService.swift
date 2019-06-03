//
//  RouteService.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/27.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import Foundation

class RouteService {
    
    static let shared = RouteService()
    
    private init() { }
    
    func route(URI: URL) -> UIViewController? {
        
        guard URI.scheme == "https" else { return nil }
        guard URI.host == "crm.1314-edu.com" else { return nil }
        
        let path = URI.path
        
        if NSPredicate(format: "SELF MATCHES %@", "^/web").evaluate(with: path) {
            guard let urlComponent = URLComponents(url: URI, resolvingAgainstBaseURL: false) else { return nil }
            guard let items = urlComponent.queryItems else { return nil }
            guard let item = items.first(where: { (queryItem) -> Bool in
                return queryItem.name == "url"
            }) else { return nil }
            guard let string = item.value, let url = URL(string: string) else { return nil }
            let webViewController = WebViewController()
            webViewController.url = url
            return webViewController
        }
        
        return nil
    }
}
