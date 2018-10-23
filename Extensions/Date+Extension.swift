//
//  NSDate+Extension.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/24.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation

fileprivate let formatter: DateFormatter = {
    $0.calendar = Calendar(identifier: .iso8601)
    $0.locale = Locale(identifier: "en_US_POSIX")
    $0.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return $0
}(DateFormatter())

extension Date {
    
    init?(iso8601: String) {
        if let date = formatter.date(from: iso8601) {
            self.init(timeInterval: 0, since: date)
        } else {
            return nil
        }
    }
    
    func string(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: self)
    }
    
//    func isToday() -> Bool {
//        var components = Calendar.current.dateComponents(in: TimeZone(secondsFromGMT: AppService.timeZone*3600)!, from: Date())
//        components = DateComponents(calendar: Calendar.current, timeZone: TimeZone(secondsFromGMT: AppService.timeZone*3600), year: components.year, month: components.month, day: components.day)
//        if self > components.date! && self < components.date!.addingTimeInterval(60 * 60 * 24) {
//            return true
//        } else {
//            return false
//        }
//    }
    
    var timeStamp: Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
}
