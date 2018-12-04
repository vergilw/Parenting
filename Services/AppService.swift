//
//  AppService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/3.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation

class AppService {
    
    static let sharedInstance = AppService()
    
    private init() {
        if let string = YYKeychain.getPasswordForService(keychainGroupID, account: "device_unique_id") {
            uniqueIdentifier = string
        } else {
            if let newIdentifier = UIDevice.current.identifierForVendor?.uuidString {
                YYKeychain.setPassword(newIdentifier, forService: keychainGroupID, account: "device_unique_id")
                uniqueIdentifier =  newIdentifier
            } else {
                uniqueIdentifier = "unknow"
            }
        }
    }
    
    let keychainGroupID: String = "com.otof.yangyu"
    
    let uniqueIdentifier: String
}
