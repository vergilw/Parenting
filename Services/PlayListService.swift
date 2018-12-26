//
//  PlayListService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/31.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation
import AVFoundation
import MediaPlayer
import Presentr
import Kingfisher
import StoreKit

import UserNotifications

class PlayListService: NSObject {
    
    static let sharedInstance = PlayListService()
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(playToEndTimeAction), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(notification:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        setupRemoteTransportControls()
        
        //add time observer
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self] (time) in
            
            guard let cmtime = self?.player.currentTime() else { return }
            guard self?.player.rate != 0 else { return }
            let seconds = CMTimeGetSeconds(cmtime)
            guard seconds >= 0 else { return }
            
            if let courseID = self?.playingCourseModel?.id, let sectionID = self?.playingSectionModels?[exist: self?.playingIndex ?? -1]?.id {
                PlaybackRecordService.sharedInstance.updateRecords(courseID: courseID, sectionID: sectionID, seconds: seconds)
            }
        })
    }
    
    var player: AVPlayer = {
        let player = AVPlayer()
        
        return player
    }()
    
    var playingCourseModel: CourseModel?
    
    var playingSectionModels: [CourseSectionModel]?
    
    var playingIndex: Int = -1
    
    @objc dynamic var isPlaying: Bool = false
    
    fileprivate var timeObserverToken: Any?
    
    let presenter: Presentr = {
        let width = ModalSize.full
        let height = ModalSize.full
        let center = ModalCenterPosition.customOrigin(origin: CGPoint.zero)
        let customType = PresentationType.custom(width: width, height: height, center: center)
        
        let customPresenter = Presentr(presentationType: customType)
        customPresenter.transitionType = .coverVerticalFromTop
        customPresenter.dismissTransitionType = .coverVerticalFromTop
        customPresenter.roundCorners = true
        customPresenter.cornerRadius = 5
        customPresenter.backgroundColor = .black
        customPresenter.backgroundOpacity = 0.5
        customPresenter.dismissOnSwipe = true
        customPresenter.dismissOnSwipeDirection = .top
        return customPresenter
    }()
    
    func playAudio(course: CourseModel, sections: [CourseSectionModel], playingIndex: Int, startPlaying: Bool = true) {
        
        if let audioURL = sections[playingIndex].media_attribute?.service_url {
            if let playURL = URL(string: audioURL) {
                let currentURL = (player.currentItem?.asset as? AVURLAsset)?.url
                let playerItem = AVPlayerItem(url: playURL)
                if currentURL != playURL {
                    player.pause()
                    player.replaceCurrentItem(with: playerItem)
                    
                    //之前播放的课程被打断，同步播放记录到服务器
                    PlaybackRecordService.sharedInstance.syncRecords()
                }
                
                if startPlaying {
                    player.play()
                    
                    do {
                        try AVAudioSession.sharedInstance().setActive(true)
                    } catch {
                        print(error)
                    }
                    
                    
                    playingCourseModel = course
                    playingSectionModels = sections
                    self.playingIndex = playingIndex
                    
                } else {
                    playingCourseModel = course
                    playingSectionModels = sections
                    self.playingIndex = playingIndex
                }
                
                isPlaying = startPlaying
            }
        }
    }
    
    func pauseAudio() {
        //当前播放课程暂停，同步播放记录到服务器
        PlaybackRecordService.sharedInstance.syncRecords()
        
        guard player.currentItem != nil, player.rate != 0 else {
            return
        }
        
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
        if let courseID = playingCourseModel?.id, let sectionID = playingSectionModels?[exist: playingIndex]?.id, let duration = playingSectionModels?[exist: playingIndex]?.duration_with_seconds {
            PlaybackRecordService.sharedInstance.updateRecords(courseID: courseID, sectionID: sectionID, seconds: TimeInterval(duration))
        }
        //当前小节课程播放完毕，同步播放记录到服务器
        PlaybackRecordService.sharedInstance.syncRecords()
        
        guard let course = playingCourseModel, let sections = playingSectionModels, playingIndex < sections.count - 1 else {
            isPlaying = false
            
        
            if #available(iOS 10.3, *) {
                if UIApplication.shared.applicationState == .active {
                    SKStoreReviewController.requestReview()
                }
            }
            return
        }
        
        if course.is_bought == false {
            guard let section = sections[exist: playingIndex+1], section.audition == true else {
                isPlaying = false
                return
            }
        }
        
        
        playAudio(course: course, sections: sections, playingIndex: playingIndex+1)
        self.setupNowPlaying()
        
    }
    
    func setupRemoteTransportControls() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.addTarget { [unowned self] (event) -> MPRemoteCommandHandlerStatus in
            if self.player.currentItem != nil, self.player.rate == 0.0 {
                
                self.player.play()
                self.isPlaying = true
                
                self.setupNowPlaying()
                
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.pauseCommand.addTarget { [unowned self] (event) -> MPRemoteCommandHandlerStatus in
            if self.player.currentItem != nil, self.player.rate > 0.0 {
                
                self.player.pause()
                self.isPlaying = false
                
                self.setupNowPlaying()
                
                return .success
            }
            return .commandFailed
        }
        
        commandCenter.previousTrackCommand.addTarget { [unowned self] (event) -> MPRemoteCommandHandlerStatus in
            guard let course = self.playingCourseModel, let sections = self.playingSectionModels, self.playingIndex != -1 else {
                return .commandFailed
            }
            
            if self.playingIndex > 0 {
                self.playAudio(course: course, sections: sections, playingIndex: self.playingIndex-1)
                self.setupNowPlaying()
                
                return .success
            } else {
                return .noSuchContent
            }
        }
        
        commandCenter.nextTrackCommand.addTarget { [unowned self] (event) -> MPRemoteCommandHandlerStatus in
            guard let course = self.playingCourseModel, let sections = self.playingSectionModels, self.playingIndex != -1 else {
                return .commandFailed
            }
            
            if sections.count > self.playingIndex {
                self.playAudio(course: course, sections: sections, playingIndex: self.playingIndex+1)
                self.setupNowPlaying()
                
                return .success
            } else {
                return .noSuchContent
            }
        }
        
    }
    
    func setupNowPlaying() {
        
        guard let course = playingCourseModel, let sections = playingSectionModels, playingIndex != -1, let playerItem = player.currentItem else { return }
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = sections[playingIndex].title
        nowPlayingInfo[MPMediaItemPropertyAlbumTitle] = course.teacher?.name
        nowPlayingInfo[MPMediaItemPropertyMediaType] = sections[playingIndex].media_attribute?.content_type
        
        if let image = ImageCache.default.retrieveImageInDiskCache(forKey: (course.teacher?.headshot_attribute?.service_url ?? ""), options: [.onlyFromCache]) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] =
                MPMediaItemArtwork(boundsSize: image.size) { size in
                    return image
            }
        }
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    @objc func handleInterruption(notification: Notification) {
        guard let userInfo = notification.userInfo,
            let typeValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue) else {
                return
        }
        
        if type == .began {
            // Interruption began, take appropriate actions
            setupNowPlaying()
        } else if type == .ended {
            if let optionsValue = userInfo[AVAudioSessionInterruptionOptionKey] as? UInt {
                let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)
                if options.contains(.shouldResume) {
                    // Interruption Ended - playback should resume
                } else {
                    // Interruption Ended - playback should NOT resume
                }
                setupNowPlaying()
            }
        }
    }
}
