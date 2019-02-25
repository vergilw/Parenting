//
//  NSObject+Extension.swift
//  HeyMail
//
//  Created by Vergil.Wang on 2018/7/23.
//  Copyright © 2018 heyooo. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
    func printMethodNamesForClass(cls: AnyClass) {
        var methodCount: UInt32 = 0
        let methodList = class_copyMethodList(cls, &methodCount)
        if let methodList = methodList, methodCount > 0 {
            enumerateCArray(array: methodList, count: methodCount) { i, m in
                let name = methodName(m: m) ?? "unknown"
                print("#\(i): \(name)")
            }
            
            free(methodList)
        }
    }
    func enumerateCArray<T>(array: UnsafePointer<T>, count: UInt32, f: (UInt32, T) -> Void) {
        var ptr = array
        for i in 0..<count {
            f(i, ptr.pointee)
            ptr = ptr.successor()
        }
    }
    func methodName(m: Method) -> String? {
        let sel = method_getName(m)
        let nameCString = sel_getName(sel)
        return String(cString: nameCString)
    }
    func printMethodNamesForClassNamed(classname: String) {
        // NSClassFromString() is declared to return AnyClass!, but should be AnyClass?
        let maybeClass: AnyClass? = NSClassFromString(classname)
        if let cls: AnyClass = maybeClass {
            printMethodNamesForClass(cls: cls)
        } else {
            print("\(classname): no such class")
        }
    }
}
