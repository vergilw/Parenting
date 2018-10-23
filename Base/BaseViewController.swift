//
//  BaseViewController.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/19.
//  Copyright © 2018 heyooo. All rights reserved.
//

import UIKit
import SnapKit

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
