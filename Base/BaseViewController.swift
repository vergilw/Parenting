//
//  BaseViewController.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/19.
//  Copyright © 2018 heyooo. All rights reserved.
//

import UIKit
import SnapKit
import UINavigationItem_Margin

class BaseViewController: UIViewController {

    lazy var tableView: UITableView = {
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.tableFooterView = UIView()
        if #available(iOS 11, *) {
            $0.contentInsetAdjustmentBehavior = .never
            $0.estimatedRowHeight = 0
            $0.estimatedSectionHeaderHeight = 0
            $0.estimatedSectionFooterHeight = 0
        }
        return $0
    }(UITableView.init(frame: .zero, style: .plain))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        if let nav = navigationController, nav.viewControllers.first != self {
            let backBtn: UIButton = {
                let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 50+12.5+30, height: 44)))
                button.setImage(UIImage(named: "public_backBarItem")?.withRenderingMode(.alwaysOriginal), for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -15-4, bottom: 0, right: 15+4)
                button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
                return button
            }()
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            navigationItem.leftMargin = 0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backBarItemAction() {
        navigationController?.popViewController(animated: true)
    }
}
