//
//  Array+Extension.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/25.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {
    subscript (exist index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
