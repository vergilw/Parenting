//
//  AnimationTabBar.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/25.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import Foundation
import Kingfisher

class AnimationTabBar: NSObject, UITabBarControllerDelegate {
    
    fileprivate lazy var animatedImgView: AnimatedImageView? = nil
    
    fileprivate lazy var iconImgView: UIImageView? = nil
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        animatedImgView?.removeFromSuperview()
        iconImgView?.isHidden = false
        
        guard let navigationController = viewController as? UINavigationController, let topViewController = navigationController.topViewController else {
            return true
        }
        
        var path = Bundle.main.path(forResource: "tabbar_homeAnimation", ofType: "gif")!
        if topViewController.isKind(of: CRMViewController.self) {
            path = Bundle.main.path(forResource: "tabbar_crmAnimation", ofType: "gif")!
        } else if topViewController.isKind(of: DMeViewController.self) {
            path = Bundle.main.path(forResource: "tabbar_meAnimation", ofType: "gif")!
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return true }
        let img = DefaultImageProcessor.default.process(item: .data(data), options: [])
        animatedImgView = {
            let imgView = AnimatedImageView(image: img)
            imgView.repeatCount = .once
            imgView.autoPlayAnimatedImage = true
            imgView.needsPrescaling = true
            imgView.delegate = self
            return imgView
        }()
        
        guard let animatedImgView = animatedImgView else { return true }
        
        for view in tabBarController.tabBar.subviews {
            
            if view.isKind(of: NSClassFromString("UITabBarButton")!) {
                for subview in view.subviews {
                    if subview.isKind(of: NSClassFromString("UITabBarSwappableImageView")!) {
                        guard let imgView = subview as? UIImageView else {
                            continue
                        }
                        
                        if topViewController.isKind(of: CRMViewController.self) {
                            guard imgView.image!.pngData() == UIImage(named: "tab_crmSelected")!.pngData() else { continue }
                        } else if topViewController.isKind(of: DMeViewController.self) {
                            guard imgView.image!.pngData() == UIImage(named: "tab_meSelected")!.pngData() else { continue }
                        }
                        
                        iconImgView = imgView
                        imgView.isHidden = true
                        
                        view.addSubview(animatedImgView)
                        animatedImgView.snp.makeConstraints { make in
                            make.center.equalTo(imgView)
                            make.size.equalTo(CGSize(width: 25, height: 25))
                        }
                        
                        return true
                    }
                }
            }
        }
        
        return true
    }
}


extension AnimationTabBar: AnimatedImageViewDelegate {
    
    func animatedImageViewDidFinishAnimating(_ imageView: AnimatedImageView) {
        recovery()
    }
    
    func recovery() {
        animatedImgView?.removeFromSuperview()
        
        iconImgView?.isHidden = false
    }
}
