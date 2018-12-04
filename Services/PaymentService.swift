//
//  PaymentService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/4.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import StoreKit

class PaymentService: NSObject {
    
    static let sharedInstance = PaymentService()
    
    private override init() {
        productIdentifiers = ["com.otof.yangyu.8",
                              "com.otof.yangyu.68",
                              "com.otof.yangyu.88"
        ]
    }
    
    var productIdentifiers: [String] = [String]()
    
    var products: [SKProduct] = [SKProduct]()
    
    var validateComplete: (()->())?
    
    func validateProductIdentifiers(complete: @escaping ()->()) {
        validateComplete = complete
        
        let productsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func creatingPaymentRequest(product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        if let name = AuthorizationService.sharedInstance.user?.name {
            if let nameMD5 = NSString(string: name).md5() {
                payment.applicationUsername = nameMD5
            }
        }
        SKPaymentQueue.default().add(payment)
    }
}


extension PaymentService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products.removeAll()
        for product in response.products {
            if !response.invalidProductIdentifiers.contains(product.productIdentifier) {
                products.append(product)
            }
        }
        if let closure = validateComplete {
            closure()
        }
    }
}


extension PaymentService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                if let receiptURL = Bundle.main.appStoreReceiptURL {
//                    do {
                        if let receiptData = try? Data(contentsOf: receiptURL) {
                            print(String(data: receiptData, encoding: String.Encoding.utf8))
                        }
//                        print(String(data: receipt, encoding: String.Encoding.utf8))
                    
//                    } catch {
//                        print(error)
//                    }
                
                }
            }
        }
    }


    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
