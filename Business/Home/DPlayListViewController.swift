//
//  DPlayListViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/31.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import AVFoundation

class DPlayListViewController: BaseViewController {

//    lazy fileprivate var interactor:Interactor? = nil
    
    
    
    lazy fileprivate var headView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        var height: CGFloat
        if #available(iOS 11, *) {
            height = 94+(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
        } else {
            height = 94+UIStatusBarHeight
        }
        view.drawSeparator(startPoint: CGPoint(x: 0, y: height), endPoint: CGPoint(x: UIScreenWidth, y: height))
        return view
    }()
    
    lazy fileprivate var controlView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.drawSeparator(startPoint: .zero, endPoint: CGPoint(x: UIScreenWidth, y: 0))
        return view
    }()
    
    lazy fileprivate var dismissArrowBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(named: "public_dismissArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 15
        return imgView
    }()
    
    lazy fileprivate var courseEntranceBtn: UIButton = {
        let button = UIButton()
        button.semanticContentAttribute = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
        button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.setTitle("进入课程 ", for: .normal)
        button.setImage(UIImage(named: "public_arrowIndicator"), for: .normal)
        button.layer.cornerRadius = UIConstants.cornerRadius
        button.layer.borderColor = UIConstants.Color.primaryGreen.cgColor
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(courseEntranceBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var tagLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var playingSectionBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sectionEntranceBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var playingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    lazy fileprivate var playingIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .right
        imgView.image = UIImage(named: "public_arrowIndicator")?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = UIConstants.Color.head
        return imgView
    }()
    
    lazy fileprivate var audioSlider: UISlider = {
        let view = UISlider()
        view.minimumTrackTintColor = UIConstants.Color.primaryGreen
        view.maximumTrackTintColor = UIConstants.Color.background
        view.setThumbImage(UIImage(named: "course_audioSliderThumb"), for: .normal)
        view.addTarget(self, action: #selector(sliderTouchBeganAction), for: .touchDown)
        view.addTarget(self, action: #selector(sliderTouchEndedAction), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        return view
    }()
    
    lazy fileprivate var audioCurrentTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var audioDurationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var audioActionBtn: UIButton = {
        let button = UIButton()
//        button.backgroundColor = UIConstants.Color.primaryGreen
        button.setImage(UIImage(named: "course_borderPlayAction")?.withRenderingMode(.alwaysOriginal), for: .normal)
//        button.layer.cornerRadius = 22.5
        button.addTarget(self, action: #selector(audioActionBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var audioPreviousBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "course_audioPrevious")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(audioPreviousBtnAction), for: .touchUpInside)
        return button
    }()

    lazy fileprivate var audioNextBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "course_audioNext")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(audioNextBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var isSliderDragging: Bool = false
    
    fileprivate var observer: NSKeyValueObservation?
    
    fileprivate var timeObserverToken: Any?
    
    public var selectedCourseBlock: ((_ courseID: Int)->())?
    
    public var selectedSectionBlock: ((_ courseID: Int, _ sectionID: Int)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        initContentView()
        initConstraints()
        addNotificationObservers()
        
        reloadPlayPanel()
    }
    
    // MARK: - ============= Initialize View =============
    func initContentView() {
        
        tableView.estimatedRowHeight = 90
        tableView.register(CourseCatalogueCell.self, forCellReuseIdentifier: CourseCatalogueCell.className())
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubviews([headView, tableView, controlView, dismissArrowBtn])
        headView.addSubviews([avatarImgView, courseEntranceBtn, titleLabel, tagLabel])
        controlView.addSubviews([audioActionBtn, playingSectionBtn, playingIndicatorImgView, playingTitleLabel, audioSlider, audioCurrentTimeLabel, audioDurationTimeLabel, audioPreviousBtn, audioNextBtn])
        
        
    }
    
    // MARK: - ============= Constraints =============
    func initConstraints() {
        headView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            if #available(iOS 11, *) {
                make.height.equalTo(94+(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0))
            } else {
                make.height.equalTo(94+UIStatusBarHeight)
            }
        }
        dismissArrowBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(0)
            make.height.equalTo(75)
        }
        controlView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(dismissArrowBtn.snp.top)
            make.height.equalTo(158)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(controlView.snp.top)
        }
        
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp_leadingMargin)
            if #available(iOS 11, *) {
                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)+32)
            } else {
                make.top.equalTo(UIStatusBarHeight+32)
            }
            make.size.equalTo(UIConstants.Size.avatar)
        }
        courseEntranceBtn.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp_trailingMargin)
            make.centerY.equalTo(avatarImgView)
            make.width.equalTo(80)
            make.height.equalTo(25)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(10)
            make.top.equalTo(avatarImgView.snp.top).offset(-2.5)
            make.trailing.greaterThanOrEqualTo(courseEntranceBtn.snp.leading).offset(-10)
            make.height.equalTo(14)
        }
        tagLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(10)
            make.trailing.greaterThanOrEqualTo(courseEntranceBtn.snp.leading).offset(-10)
            make.top.equalTo(titleLabel.snp.bottom).offset(9)
            make.height.equalTo(12)
        }
        
        playingIndicatorImgView.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp_trailingMargin)
            make.centerY.equalTo(playingTitleLabel)
        }
        playingTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp_leadingMargin)
            make.trailing.greaterThanOrEqualTo(playingIndicatorImgView.snp.leading).offset(-32)
            make.top.equalTo(20)
        }
        playingSectionBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(playingTitleLabel.snp.top).offset(-20)
            make.bottom.equalTo(playingTitleLabel.snp.bottom).offset(20)
        }
        
        audioSlider.snp.makeConstraints { make in
            make.leading.equalTo(view.snp_leadingMargin).offset(40)
            make.trailing.equalTo(view.snp_trailingMargin).offset(-40)
            make.centerY.equalTo(audioCurrentTimeLabel)
        }
        audioCurrentTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.snp_leadingMargin)
            make.top.equalTo(playingTitleLabel.snp.bottom).offset(32)
        }
        audioDurationTimeLabel.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp_trailingMargin)
            make.top.equalTo(playingTitleLabel.snp.bottom).offset(32)
        }
        audioActionBtn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.top.equalTo(audioCurrentTimeLabel.snp.bottom).offset(22.5)
            make.bottom.equalToSuperview()
//            make.height.equalTo(55)
//            make.width.equalTo(55)
        }
        audioPreviousBtn.snp.makeConstraints { make in
            make.centerY.equalTo(audioActionBtn)
            make.trailing.equalTo(audioActionBtn.snp.leading).offset(-25)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
        audioNextBtn.snp.makeConstraints { make in
            make.centerY.equalTo(audioActionBtn)
            make.leading.equalTo(audioActionBtn.snp.trailing).offset(25)
            make.width.equalTo(44)
            make.height.equalTo(44)
        }
    }
    
    // MARK: - ============= Notification =============
    func addNotificationObservers() {
        observer = PlayListService.sharedInstance.observe(\.isPlaying) { [weak self] (service, changed) in
            self?.reloadPlayPanel()
        }
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        tableView.reloadData()
        
        guard let playingCourseModel = PlayListService.sharedInstance.playingCourseModel else { return }
        
        if let avatarURL = playingCourseModel.teacher?.headshot_attribute?.service_url {
            avatarImgView.kf.setImage(with: URL(string: avatarURL))
        }
        
        titleLabel.text = playingCourseModel.title
        
        tagLabel.text = playingCourseModel.teacher?.name ?? ""
        if let tags = playingCourseModel.teacher?.tags {
            let tagString = tags.joined(separator: " | ")
            tagLabel.text = tagLabel.text?.appendingFormat(" : %@", tagString)
        }
        
        let playingIndex = PlayListService.sharedInstance.playingIndex
        guard let playingSectionModels = PlayListService.sharedInstance.playingSectionModels, playingIndex != -1 else {
            return
        }
        
        playingTitleLabel.text = playingSectionModels[playingIndex].title
        audioCurrentTimeLabel.text = "00:00"
        if let durationSeconds = playingSectionModels[playingIndex].duration_with_seconds {
            let duration: TimeInterval = TimeInterval(durationSeconds)
            let durationDate = Date(timeIntervalSince1970: duration)
            audioDurationTimeLabel.text = CourseCatalogueCell.timeFormatter.string(from: durationDate)
        }
        
        audioPreviousBtn.tintColor = UIConstants.Color.primaryGreen
        audioNextBtn.tintColor = UIConstants.Color.primaryGreen
        if playingIndex == 0 {
            audioPreviousBtn.tintColor = UIConstants.Color.disable
        }
        if playingIndex == playingSectionModels.count - 1 {
            audioNextBtn.tintColor = UIConstants.Color.disable
        }
    }
    
    func reloadPlayPanel() {
        weak var player = PlayListService.sharedInstance.player
        
        //reset time observer
        if let timeObserverToken = timeObserverToken {
            player?.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
        guard let playingSectionModels = PlayListService.sharedInstance.playingSectionModels,
            PlayListService.sharedInstance.playingIndex != -1 else {
                recoverPlayPanelView()
                return
        }
        
        reload()
        
        //reset audio button img
        if PlayListService.sharedInstance.isPlaying {
            audioActionBtn.setImage(UIImage(named: "course_borderPauseAction")?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            audioActionBtn.setImage(UIImage(named: "course_borderPlayAction")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        //reset current time
        guard let cmtime = player?.currentTime() else { return }
        let seconds = CMTimeGetSeconds(cmtime)
        guard seconds >= 0 else { return }
        let timeInterval: TimeInterval = TimeInterval(seconds)
        let date = Date(timeIntervalSince1970: timeInterval)
        audioCurrentTimeLabel.text = CourseCatalogueCell.timeFormatter.string(from: date)
        
        //reset slider
        guard let durationSeconds = playingSectionModels[PlayListService.sharedInstance.playingIndex].duration_with_seconds else { return }
        audioSlider.setValue(Float(seconds) / durationSeconds, animated: true)
        
        
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self] (time) in
            
            guard let cmtime = player?.currentTime() else { return }
            guard player?.rate != 0 else {
                let playImg = UIImage(named: "course_borderPlayAction")?.withRenderingMode(.alwaysOriginal)
                if self?.audioActionBtn.currentImage != playImg {
                    self?.audioActionBtn.setImage(playImg, for: .normal)
                }
                return
            }
            let seconds = CMTimeGetSeconds(cmtime)
            guard seconds >= 0 else { return }
            let timeInterval: TimeInterval = TimeInterval(seconds)
            let date = Date(timeIntervalSince1970: timeInterval)
            self?.audioCurrentTimeLabel.text = CourseCatalogueCell.timeFormatter.string(from: date)
            
            let pauseImg = UIImage(named: "course_borderPauseAction")?.withRenderingMode(.alwaysOriginal)
            if self?.audioActionBtn.currentImage != pauseImg {
                self?.audioActionBtn.setImage(pauseImg, for: .normal)
            }
            
            guard self?.isSliderDragging == false else { return }
            guard let durationSeconds = playingSectionModels[PlayListService.sharedInstance.playingIndex].duration_with_seconds else { return }
            self?.audioSlider.setValue(Float(seconds) / durationSeconds, animated: true)
        })
    }
    
    func recoverPlayPanelView() {
        if let timeObserverToken = timeObserverToken {
            PlayListService.sharedInstance.player.removeTimeObserver(timeObserverToken)
        }
        audioCurrentTimeLabel.text = "00:00"
        audioSlider.value = 0
        audioActionBtn.setImage(UIImage(named: "course_borderPlayAction")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    // MARK: - ============= Action =============
    
    @objc func dismissBtnAction() {
//        if let dismissBlock = dismissBlock {
//            dismissBlock()
//        }
        
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = .moveIn
//        transition.subtype = .fromBottom
//        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
//        view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func courseEntranceBtnAction() {
        guard let courseID = PlayListService.sharedInstance.playingCourseModel?.id else {
            return
        }
        
        if let block = selectedCourseBlock {
            dismiss(animated: true, completion: nil)
            block(_: courseID)
        }
    }
    
    @objc func audioActionBtnAction() {
        if PlayListService.sharedInstance.isPlaying == false  {
            
            guard let course = PlayListService.sharedInstance.playingCourseModel, let sections = PlayListService.sharedInstance.playingSectionModels, PlayListService.sharedInstance.playingIndex != -1 else {
                return
            }
            PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: PlayListService.sharedInstance.playingIndex)
            audioActionBtn.setImage(UIImage(named: "course_borderPauseAction")?.withRenderingMode(.alwaysOriginal), for: .normal)
            
        } else {
            PlayListService.sharedInstance.pauseAudio()
            audioActionBtn.setImage(UIImage(named: "course_borderPlayAction")?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    @objc func sliderTouchBeganAction() {
        isSliderDragging = true
    }
    
    @objc func sliderTouchEndedAction() {
        guard let _ = PlayListService.sharedInstance.playingCourseModel, let _ = PlayListService.sharedInstance.playingSectionModels, PlayListService.sharedInstance.playingIndex != -1 else {
            isSliderDragging = false
            return
        }
        PlayListService.sharedInstance.seek(audioSlider.value) {
            self.isSliderDragging = false
        }
    }
    
    @objc func audioPreviousBtnAction() {
        guard let course = PlayListService.sharedInstance.playingCourseModel,
            let sections = PlayListService.sharedInstance.playingSectionModels,
            PlayListService.sharedInstance.playingIndex > 0 else {
            return
        }
        PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: PlayListService.sharedInstance.playingIndex-1)
    }
    
    @objc func audioNextBtnAction() {
        guard let course = PlayListService.sharedInstance.playingCourseModel,
            let sections = PlayListService.sharedInstance.playingSectionModels,
            PlayListService.sharedInstance.playingIndex < sections.count-1 else {
                return
        }
        PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: PlayListService.sharedInstance.playingIndex+1)
    }
    
    @objc func sectionEntranceBtnAction() {
        guard let courseID = PlayListService.sharedInstance.playingCourseModel?.id, let sections = PlayListService.sharedInstance.playingSectionModels,
            PlayListService.sharedInstance.playingIndex != -1 else {
                return
        }
        
        if let block = selectedSectionBlock, let sectionID = sections[PlayListService.sharedInstance.playingIndex].id {
            dismiss(animated: true, completion: nil)
            block(_: courseID, _: sectionID)
        }
    }
    
    deinit {
        if let timeObserverToken = timeObserverToken {
            PlayListService.sharedInstance.player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        if let observer = observer {
            observer.invalidate()
            self.observer = nil
        }
        
    }
}


extension DPlayListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayListService.sharedInstance.playingSectionModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseCatalogueCell.className(), for: indexPath) as! CourseCatalogueCell
        var isPlaying = false
        let playingIndex = PlayListService.sharedInstance.playingIndex
        if playingIndex != -1, playingIndex == indexPath.row {
            isPlaying = true
        }
        cell.setup(model: PlayListService.sharedInstance.playingSectionModels![indexPath.row], isPlaying: isPlaying, isBought: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let course = PlayListService.sharedInstance.playingCourseModel,
            let sections = PlayListService.sharedInstance.playingSectionModels,
            indexPath.row <= sections.count-1, indexPath.row != PlayListService.sharedInstance.playingIndex else {
                return
        }
        PlayListService.sharedInstance.playAudio(course: course, sections: sections, playingIndex: indexPath.row)
    }
}

/*
extension DPlayListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor?.hasStarted ?? false ? interactor : nil
    }
}


class DismissAnimator : NSObject { }

extension DismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        let containerView = transitionContext.containerView
        containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromVC.view.frame = finalFrame
        }) { (bool) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}


class Interactor: UIPercentDrivenInteractiveTransition {
    var hasStarted = false
    var shouldFinish = false
}
*/
