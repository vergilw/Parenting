//
//  UploadService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/4.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

class UploadService {
    
    static let sharedInstance = UploadService()
    
    private init() { }
    
    func upload(data: Data, complete: @escaping ((String?) -> ())) {
        
        CommonProvider.request(.uploadToken(data.count, mimeType(imageData: data)), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            if code >= 0 {
                if let key = JSON?["key"] as? String, let directUpload = JSON?["direct_upload"] as? [String: Any], let headers = directUpload["headers"] as? [String: Any], let token = headers["Up-Token"] as? String {
                    let manager = QNUploadManager.init()
                    let option = QNUploadOption(mime: self.mimeType(imageData: data), progressHandler: { (string, float) in

                    }, params: [AnyHashable : Any](), checkCrc: true, cancellationSignal: { () -> Bool in
                        return false
                    })
                    manager!.put(data, key: key, token: token, complete: { (response, key, data) in
                        if response?.isOK ?? false {
                            complete(JSON?["signed_id"] as? String)
                        } else {
                            complete(nil)
                        }
                    }, option: option!)
                }
            }
        }))
    }
    
    func putImgToQiniu(filepath: String, key: String, token: String, completeClosure: @escaping ((Bool)->Void)) {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filepath)) else { return completeClosure(false) }
        
        let option = QNUploadOption(mime: self.mimeType(imageData: data), progressHandler: { (string, float) in
            
        }, params: [AnyHashable : Any](), checkCrc: true, cancellationSignal: { () -> Bool in
            return false
        })
        QNUploadManager()!.put(data, key: key, token: token, complete: { (response, key, data) in
            completeClosure(response?.isOK ?? false)
        }, option: option!)
    }
    
    func mimeType(imageData: Data) -> String {
        var values = [UInt8](repeating:0, count:1)
        imageData.copyBytes(to: &values, count: 1)
        
        let mimeType: String
        switch (values[0]) {
        case 0xFF:
            mimeType = "image/jpeg"
        case 0x89:
            mimeType = "image/jpeg"
        case 0x47:
            mimeType = "image/gif"
        case 0x49, 0x4D :
            mimeType = "iamge/tiff"
        default:
            mimeType = "image/png"
        }
        return mimeType
    }
}

