//
//  BaseNavigationController.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/19.
//  Copyright © 2018 heyooo. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self

        navigationBar.barTintColor = .white
//        navigationBar.isTranslucent = false

        navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor("#333"),
             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .medium)]
        navigationBar.tintColor = .white

        navigationBar.setBackgroundImage(UIImage(color: .white), for: .any, barMetrics: .default)
//        navigationBar.shadowImage = UIImage(color: .white)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            interactivePopGestureRecognizer?.isEnabled = true
            viewController.hidesBottomBarWhenPushed = true
//            viewController.navigationItem.leftBarButtonItem =
//                UIBarButtonItem(image: #imageLiteral(resourceName: "Popback"),
//                                style: .plain,
//                                target: self,
//                                action: #selector(BaseNavigationController.popBtnAction(_:)))
        }

        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func popBtnAction(_ sender: UIButton) {
        popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
