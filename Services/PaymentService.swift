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
    
    var completeClosure: ((Bool)->())?
    var purchasingProductID: String?
    var purchasingPayment: SKPayment?
    var purchasedTransactionID: String?
    
    public func purchaseProduct(productID: String, models: [AdvanceModel], complete: @escaping (Bool)->()) {
        completeClosure = complete
        purchasingProductID = productID
        
        if productIdentifiers.count > 0 {
            if let product = products.first(where: { (product) -> Bool in
                return product.productIdentifier == purchasingProductID
            }) {
                creatingPaymentRequest(product: product)
            } else {
                validateProductIdentifiers(models: models)
            }
        } else {
            validateProductIdentifiers(models: models)
        }
    }
    
    fileprivate func validateProductIdentifiers(models: [AdvanceModel]) {
        
        productIdentifiers = extractProductIdentifiers(models: models)
        
        let productsRequest = SKProductsRequest(productIdentifiers: Set(productIdentifiers))
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    fileprivate func extractProductIdentifiers(models: [AdvanceModel]) -> [String] {
        var identifiers: [String] = [String]()
        
        for model in models {
            if let productIdentifier = model.apple_product_id {
                identifiers.append(productIdentifier)
            }
        }
        
        return identifiers
    }
    
    fileprivate func creatingPaymentRequest(product: SKProduct) {
        let payment = SKMutablePayment(product: product)
        if let name = AuthorizationService.sharedInstance.user?.name {
            if let nameMD5 = NSString(string: name).md5() {
                payment.applicationUsername = nameMD5
            }
        }
        purchasingPayment = payment
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
        
        if purchasingProductID != nil {
            if let product = products.first(where: { (product) -> Bool in
                return product.productIdentifier == purchasingProductID
            }) {
                creatingPaymentRequest(product: product)
            } else {
                print("\(#function) product id not found")
            }
        }
    }
}


extension PaymentService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            
            print("\(#function) \n \(transaction.transactionIdentifier ?? "") : \(transaction.transactionState.rawValue)")
            
            if transaction.transactionState == .purchased || transaction.transactionState == .restored {
                if transaction.payment == purchasingPayment {
                    purchasedTransactionID = transaction.transactionIdentifier
                }
                
                if let receiptURL = Bundle.main.appStoreReceiptURL {
                    if let receiptData = try? Data(contentsOf: receiptURL) {
                        validateReceipt(receiptString: receiptData.base64EncodedString(), isForeground: purchasedTransactionID == transaction.transactionIdentifier)
                    }
                }
            } else if transaction.transactionState == .failed {
                if transaction.payment == purchasingPayment {
                    if let closure = self.completeClosure {
                        closure(false)
                        purchasingProductID = nil
                        purchasingPayment = nil
                        purchasedTransactionID = nil
                        completeClosure = nil
                    }
                }
                
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
    
    func validateReceipt(receiptString: String, isForeground: Bool = true) {
        PaymentProvider.request(.advance_receipt(receiptString), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            //response fail
            guard let invoices = JSON?["invoices"] as? [[String: Any]], code >= 0 else {
                if !isForeground {
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).asyncAfter(deadline: DispatchTime.now()+30, execute: {
                        if let receiptURL = Bundle.main.appStoreReceiptURL {
                            if let receiptData = try? Data(contentsOf: receiptURL) {
                                self.validateReceipt(receiptString: receiptData.base64EncodedString(), isForeground: isForeground)
                            }
                        }
                    })
                } else {
                    if let closure = self.completeClosure {
                        closure(false)
                    }
                }
                
                return
            }
            
            //response succeed
            for invoice in invoices {
                guard let transactionID = invoice["transaction_id"] as? String, let checked = invoice["checked"] as? Bool else {
                    continue
                }
                
                //found purchasing transaction
                if transactionID == self.purchasedTransactionID, isForeground == true {
                    if let closure = self.completeClosure {
                        closure(checked)
                    }
                    self.purchasingProductID = nil
                    self.purchasingPayment = nil
                    self.purchasedTransactionID = nil
                    self.completeClosure = nil
                }
                
                guard checked == true else { continue }
                
                //receipt validate success
                if let paymentTransaction = SKPaymentQueue.default().transactions.first(where: { (paymentTransaction) -> Bool in
                    return paymentTransaction.transactionIdentifier == transactionID
                }) {
                    //finish transaction
                    SKPaymentQueue.default().finishTransaction(paymentTransaction)
                    AuthorizationService.sharedInstance.updateUserInfo()
                }
            }
            
            //not found purchasing transaction
            if let closure = self.completeClosure, isForeground == true {
                closure(false)
                self.purchasingProductID = nil
                self.purchasingPayment = nil
                self.purchasedTransactionID = nil
                self.completeClosure = nil
            }
        }))
    }
    
}
