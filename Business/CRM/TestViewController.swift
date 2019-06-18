//
//  TestViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/4/15.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

class TestViewController: FlutterViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GeneratedPluginRegistrant.register(with: engine)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
