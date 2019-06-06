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
        
//        guard (URI.scheme == "https" || URI.scheme == nil) else { return nil }
        guard (URI.host == "sg.1314-edu.com" || URI.host == "m.1314-edu.com" || URI.host == nil) else { return nil }
        
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
            
        } else if NSPredicate(format: "SELF MATCHES %@", "^/notification/[0-9]+$").evaluate(with: path) {
            guard let string = URI.pathComponents.last, let identifier = Int(string) else { return nil }
            return DMeMessageDetailViewController(messageID: identifier)
        }
        
        return nil
    }
}
