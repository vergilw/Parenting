//
//  ModelTransform.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/10.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

fileprivate let formatter: DateFormatter = {
    $0.calendar = Calendar(identifier: .iso8601)
    $0.locale = Locale(identifier: "en_US_POSIX")
    $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return $0
}(DateFormatter())

class DateISO8601Transform: DateFormatterTransform {
    
    public init() {
        super.init(dateFormatter: formatter)
    }
}
