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
    
    func fetchLatestCourseSectionID(courseID: Int) -> Int? {
        if let courseRecords = records?[courseID] {
            if let index = courseRecords[0] {
                return Int(index)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func updateRecords(courseID: Int, sectionID: Int, seconds: TimeInterval) {
        guard AuthorizationService.sharedInstance.isSignIn() else { return }
        
        if let _ = records?[courseID] {
            records?[courseID]?[sectionID] = seconds
            //用0来记录课程最新播放索引
            records?[courseID]?[0] = TimeInterval(sectionID)
        } else {
            records?[courseID] = [sectionID: seconds]
            //用0来记录课程最新播放索引
            records?[courseID]?[0] = TimeInterval(sectionID)
        }
    }
    
    func syncRecords() {
        guard AuthorizationService.sharedInstance.isSignIn() else { return }
        guard let records = records, isSynchronizing == false else { return }
        guard Alamofire.NetworkReachabilityManager(host: ServerHost)?.isReachableOnEthernetOrWiFi ?? false else { return }
        
        let dispatchGroup = DispatchGroup()
        isSynchronizing = true
        
        for courseRecords in records {
            
            for sectionRecord in courseRecords.value {
                
                //如果是播放索引记录，则跳过
                guard sectionRecord.key != 0 else { continue }
                
                dispatchGroup.enter()
                CourseProvider.request(.course_record(courseRecords.key, sectionRecord.key, String(Int(sectionRecord.value))), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
                    
                    if code >= 0 {
                        //通知所有持有课程Model的class更新数据
                        NotificationCenter.default.post(name: Notification.Course.courseRecordDidChanged, object: nil, userInfo: [courseRecords.key: sectionRecord])
                        
                        self.records?[courseRecords.key]?.removeValue(forKey: sectionRecord.key)
                        if self.records?[courseRecords.key]?.keys.count == 0 || (self.records?[courseRecords.key]?.keys.count == 1 && self.records?[courseRecords.key]?.keys.first == 0) {
                            self.records?.removeValue(forKey: courseRecords.key)
                        }
                        
                        
                        //显示获得奖励
                        if let reward = JSON?["reward"] as? [String: Any], let status = reward["code"] as? String, status == "success", let rewardValue = reward["amount"] as? String, UIApplication.shared.applicationState == .active {
                            
                            let view = RewardView()
                            UIApplication.shared.keyWindow?.addSubview(view)
                            view.snp.makeConstraints { make in
                                make.edges.equalToSuperview()
                            }
                            view.present(string: rewardValue, mode: .study)
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
