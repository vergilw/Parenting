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
        $0.tableFooterView = UIView()
        if #available(iOS 11, *) {
            $0.contentInsetAdjustmentBehavior = .never
            $0.estimatedRowHeight = 0
            $0.estimatedSectionHeaderHeight = 0
            $0.estimatedSectionFooterHeight = 0
        }
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        return $0
    }(UITableView.init(frame: .zero, style: .plain))
    
    lazy var backBarBtn: UIButton = {
        let img = UIImage(named: "public_backBarItem")!.withRenderingMode(.alwaysTemplate)
        let button = UIButton()
        button.setImage(img, for: .normal)
        if #available(iOS 11.0, *) {
            button.frame = CGRect(origin: .zero, size: CGSize(width: UIConstants.Margin.leading+img.size.width+35, height: UIStatusBarHeight+(navigationController?.navigationBar.bounds.height ?? 0)))
            button.imageEdgeInsets = UIEdgeInsets(top: UIStatusBarHeight, left: -(35-UIConstants.Margin.leading)/2, bottom: 0, right: (35-UIConstants.Margin.leading)/2)
        } else {
            button.frame = CGRect(origin: .zero, size: CGSize(width: UIConstants.Margin.leading+img.size.width+35, height: (navigationController?.navigationBar.bounds.height ?? 0)))
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(35-UIConstants.Margin.leading)/2, bottom: 0, right: (35-UIConstants.Margin.leading)/2)
        }
        button.tintColor = .white
        button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        if let nav = navigationController, nav.viewControllers.first != self {
            let backBtn: UIButton = {
                let img = UIImage(named: "public_backBarItem")!.withRenderingMode(.alwaysOriginal)
                let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: UIConstants.Margin.leading+img.size.width+35, height: nav.navigationBar.bounds.height)))
                button.setImage(img, for: .normal)
                button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -(35-UIConstants.Margin.leading)/2, bottom: 0, right: (35-UIConstants.Margin.leading)/2)
                button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
                return button
            }()
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            navigationItem.leftMargin = 0
            
        }
        
        view.layoutMargins = UIEdgeInsets(top: 16, left: 25, bottom: 16, right: 25)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController, (parent?.isKind(of: BaseNavigationController.self) ?? true) {
            navigationController.setNavigationBarHidden(false, animated: animated)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backBarItemAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func dimissBarItemAction() {
        dismiss(animated: true, completion: nil)
    }

    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func initDismissBtn() {
        
        let backBtn: UIButton = {
            let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 25+15+25, height: 44)))
            button.setImage(UIImage(named: "public_dismissBtn")?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = UIConstants.Color.head
            button.addTarget(self, action: #selector(dimissBarItemAction), for: .touchUpInside)
            return button
        }()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
        navigationItem.leftMargin = 0
    }
}
