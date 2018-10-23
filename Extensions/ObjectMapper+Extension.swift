//
//  ObjectMapper+Extension.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/24.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation
//import RealmSwift
import ObjectMapper

infix operator <-

/// Object of Realm's List type
//public func <- <T: Mappable>(left: List<T>, right: Map) {
//    var array: [T]?
//    
//    if right.mappingType == .toJSON {
//        array = Array(left)
//    }
//    
//    array <- right
//    
//    if right.mappingType == .fromJSON {
//        if let theArray = array {
//            left.append(objectsIn: theArray)
//        }
//    }
//}

/// Object of Realm's RealmOptional type
//public func <- <T>(left: RealmOptional<T>, right: Map) {
//    var optional: T?
//
//    if right.mappingType == .toJSON {
//        optional = left.value
//    }
//
//    optional <- right
//
//    if right.mappingType == .fromJSON {
//        if let theOptional = optional {
//            left.value = theOptional
//        }
//    }
//}

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
