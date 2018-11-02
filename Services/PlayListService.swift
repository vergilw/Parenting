//
//  PlayListService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/31.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import AVFoundation

class PlayListService: NSObject {
    
    static let sharedInstance = PlayListService()
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTimeAction), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    var player: AVPlayer = {
        let player = AVPlayer()
        
        return player
    }()
    
    var playingCourseModel: CourseModel?
    
    var playingSectionModels: [CourseSectionModel]?
    
    var playingIndex: Int = -1
    
    @objc dynamic var isPlaying: Bool = false
    
    func playAudio(course: CourseModel, sections: [CourseSectionModel], playingIndex: Int) {
        
        if let audioURL = sections[playingIndex].media_attribute?.service_url {
            if let playURL = URL(string: audioURL) {
                let currentURL = (player.currentItem?.asset as? AVURLAsset)?.url
                if currentURL != playURL {
                    player.replaceCurrentItem(with: AVPlayerItem(url: playURL))
                }
                player.play()
                
                
                playingCourseModel = course
                playingSectionModels = sections
                self.playingIndex = playingIndex
                isPlaying = true
            }
        }
    }
    
    func pauseAudio() {
        player.pause()
        isPlaying = false
    }
    
    func seek(_ index: Float, completion: @escaping ()->()) {
        guard playingIndex != -1, let durationSeconds = playingSectionModels?[playingIndex].duration_with_seconds, durationSeconds > 0 else {
            completion()
            return
        }
        
        player.seek(to: CMTime(seconds: Double(durationSeconds * index), preferredTimescale: CMTimeScale(NSEC_PER_SEC))) { (bool) in
            completion()
        }
    }
    
    @objc func playToEndTimeAction() {
        guard let course = playingCourseModel, let sections = playingSectionModels, playingIndex < sections.count - 1 else {
            isPlaying = false
            return
        }
        
        playAudio(course: course, sections: sections, playingIndex: playingIndex+1)
    }
}
