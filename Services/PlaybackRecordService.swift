//
//  PlaybackRecordService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/26.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Alamofire

class PlaybackRecordService {
    
    static let sharedInstance = PlaybackRecordService()
    
    lazy fileprivate var cache = YYCache(name: "D" + String(describing: type(of: self)))
    
    private init() { }
    
    lazy fileprivate var isSynchronizing = false
    
    var records: [Int: [Int: TimeInterval]]? {
        get {
            if let records = cache?.object(forKey: "records") as? [Int: [Int: TimeInterval]] {
                return records
            } else {
                return [Int: [Int: TimeInterval]]()
            }
        }
        set {
            if newValue != nil {
                cache?.setObject(newValue as NSCoding?, forKey: "records")
                print(newValue)
            } else {
                cache?.removeObject(forKey: "records")
            }
        }
    }
    
    func fetchRecords(courseID: Int, sectionID: Int?) -> Any? {
        if let courseRecords = records?[courseID] {
            if let sectionID = sectionID {
                if let seconds = courseRecords[sectionID] {
                    return seconds
                } else {
                    return nil
                }
            } else {
                return courseRecords
            }
        } else {
            return nil
        }
    }
    
    func updateRecords(courseID: Int, sectionID: Int, seconds: TimeInterval) {
        if let _ = records?[courseID] {
            records?[courseID]?[sectionID] = seconds
        } else {
            records?[courseID] = [sectionID: seconds]
        }
    }
    
    func syncRecords() {
        guard let records = records, isSynchronizing == false else { return }
        guard Alamofire.NetworkReachabilityManager(host: ServerHost)?.isReachableOnEthernetOrWiFi ?? false else { return }
        
        let dispatchGroup = DispatchGroup()
        isSynchronizing = true
        
        for courseRecords in records {
            
            for sectionRecord in courseRecords.value {
                dispatchGroup.enter()
                CourseProvider.request(.course_record(courseRecords.key, sectionRecord.key, String(sectionRecord.value)), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                    
                    if code >= 0 {
                        self.records?[courseRecords.key]?.removeValue(forKey: sectionRecord.key)
                        if self.records?[courseRecords.key]?.keys.count == 0 {
                            self.records?.removeValue(forKey: courseRecords.key)
                        }
                    }
                    dispatchGroup.leave()
                }))
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.background)) {
            self.isSynchronizing = false
        }
    }
}
