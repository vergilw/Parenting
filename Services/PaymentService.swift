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
    }
    
    var productIdentifiers: [String] = [String]()
    
    var products: [SKProduct] = [SKProduct]()
    
    var validateComplete: (()->())?
    
    func validateProductIdentifiers(models: [AdvanceModel], complete: @escaping ()->()) {
        validateComplete = complete
        
        productIdentifiers = extractProductIdentifiers(models: models)
        
        let productsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func extractProductIdentifiers(models: [AdvanceModel]) -> [String] {
        var identifiers: [String] = [String]()
        
        for model in models {
            if let productIdentifier = model.apple_product_id {
                identifiers.append(productIdentifier)
            }
        }
        
        return identifiers
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
                    if let receiptData = try? Data(contentsOf: receiptURL) {
                        validateReceipt(receiptData.base64EncodedString())
                    }
                }
            } else if transaction.transactionState == .failed {
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }


    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    func validateReceipt(_ string: String) {
        PaymentProvider.request(.advance_receipt(string), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0 {
                HUDService.sharedInstance.show(string: "充值成功")
            }
        }))
    }
}
