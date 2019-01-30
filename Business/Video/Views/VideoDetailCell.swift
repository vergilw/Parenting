//
//  VideoDetailCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher
import AVFoundation

class VideoDetailCell: UITableViewCell {
    
    weak var delegate: VideoDetailCellDelegate?
    
    var model: VideoModel?
    
    lazy var player: AVPlayer = {
        let view = AVPlayer()
        view.automaticallyWaitsToMinimizeStalling = false
        view.actionAtItemEnd = .none
        return view
    }()
    
    lazy fileprivate var playerLayer: AVPlayerLayer = {
        let view = AVPlayerLayer(player: player)
        view.videoGravity = .resizeAspectFill
        return view
    }()
    
    fileprivate var playerLooper: AVPlayerLooper?
    
    lazy fileprivate var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.2).cgColor, UIColor(white: 0, alpha: 0.4).cgColor]
        layer.locations = [0.3, 0.6, 1.0]
        layer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint.init(x: 0.0, y: 1.0)
        return layer
    }()
    
    lazy fileprivate var playerStatusImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_playerLargePlay")
        imgView.isHidden = true
        return imgView
    }()
    
    lazy fileprivate var favoriteBtn: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var avatarBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 25
        button.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        button.layer.borderWidth = 2
        button.clipsToBounds = true
        button.setImage(UIImage(named: "public_avatarPlaceholder"), for: .normal)
        button.addTarget(self, action: #selector(avatarBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var likeImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_playerLike")?.withRenderingMode(.alwaysTemplate)
        imgView.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        imgView.layer.shadowOpacity = 0.6
        imgView.layer.shadowColor = UIColor.black.cgColor
        imgView.clipsToBounds = false
        return imgView
    }()
    
    lazy fileprivate var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        label.layer.shadowOffset = CGSize(width: 0, height: 3.0)
        label.layer.shadowOpacity = 0.6
        label.layer.shadowColor = UIColor.black.cgColor
        label.clipsToBounds = false
        return label
    }()
    
    fileprivate lazy var likeMarkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 10)!
        label.textColor = .white
        label.text = "赏"
        label.textAlignment = .center
        label.backgroundColor = UIConstants.Color.primaryRed
        label.layer.cornerRadius = 7.5
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    lazy fileprivate var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var commentMarkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 10)!
        label.textColor = .white
        label.text = "赏"
        label.textAlignment = .center
        label.backgroundColor = UIConstants.Color.primaryRed
        label.layer.cornerRadius = 7.5
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    lazy fileprivate var shareCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var shareMarkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Regular", size: 10)!
        label.textColor = .white
        label.text = "赏"
        label.textAlignment = .center
        label.backgroundColor = UIConstants.Color.primaryRed
        label.layer.cornerRadius = 7.5
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    let captionStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .leading
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 10
        return view
    }()
    
    lazy fileprivate var authorNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()
    
    fileprivate lazy var rewardCountdownView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    fileprivate lazy var rewardCountdownLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIColor("#ffd35b")
        return label
    }()
    
    fileprivate var timeObserverToken: Any?
    
    lazy fileprivate var lastTapTime: TimeInterval = 0
    lazy fileprivate var lastTapPoint: CGPoint = .zero
    
    lazy fileprivate var isRequesting: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor("#353535")
        contentView.layer.addSublayer(playerLayer)
        contentView.layer.addSublayer(gradientLayer)
        
        
        initActionView()
        initCaptionView()
        initRewardCountdownView()
        
        
        initGesture()
        initObserver()
        
        initConstraints()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initGesture() {
        contentView.addSubview(playerStatusImgView)
        
        let tapGesture = UITapGestureRecognizer { [weak self] (sender) in
            guard let sender = sender as? UITapGestureRecognizer else { return }
            guard self != nil else { return }
            
            let point = sender.location(in: self?.contentView)
            //获取当前时间
            let time = CACurrentMediaTime()
            //判断当前点击时间与上次点击时间的时间间隔
            if (time - (self?.lastTapTime ?? 0)) > 0.25 {
                //推迟0.25秒执行单击方法
                self?.perform(#selector(self?.playerStatusBtnAction), with: nil, afterDelay: 0.25)
                
            } else {
                //取消执行单击方法
                NSObject.cancelPreviousPerformRequests(withTarget: self!, selector: #selector(self?.playerStatusBtnAction), object: nil)
                //执行连击显示爱心的方法
                self?.showLikeViewAnim(newPoint: point, oldPoint: self!.lastTapPoint)
                
                //触发喜欢请求
                if self?.model?.liked == false {
                    self?.videoLikeRequest()
                }
            }
            //更新上一次点击位置
            self?.lastTapPoint = point
            //更新上一次点击时间
            self?.lastTapTime = time
        }
        contentView.addGestureRecognizer(tapGesture)
    }
    
    fileprivate func initActionView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 24
            return view
        }()
        
        //Like Action
        let likeStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 3.5
            return view
        }()
        let likeBtn: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(videoLikeRequest), for: .touchUpInside)
            return button
        }()
        likeStackView.addArrangedSubview(likeImgView)
        likeStackView.addArrangedSubview(likeCountLabel)
        likeStackView.addSubviews([likeBtn, likeMarkLabel])
        likeBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        likeMarkLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(-5)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        
        
        //Comment Action
        let commentStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 3.5
            return view
        }()
        let commentBtn: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(commentBtnAction), for: .touchUpInside)
            return button
        }()
        let commentImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "video_playerComment")
            return imgView
        }()
        commentStackView.addArrangedSubview(commentImgView)
        commentStackView.addArrangedSubview(commentCountLabel)
        commentStackView.addSubviews([commentBtn, commentMarkLabel])
        commentBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        commentMarkLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(-5)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        
        
        //Share Action
        let shareStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 3.5
            return view
        }()
        let shareBtn: UIButton = {
            let button = UIButton()
            button.addTarget(self, action: #selector(forwardBtnAction), for: .touchUpInside)
            return button
        }()
        let shareImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "video_playerForward")
            return imgView
        }()
        shareStackView.addArrangedSubview(shareImgView)
        shareStackView.addArrangedSubview(shareCountLabel)
        shareStackView.addSubviews([shareBtn, shareMarkLabel])
        shareBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        shareMarkLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(-5)
            make.size.equalTo(CGSize(width: 15, height: 15))
        }
        
        
        
        //StackView Layout
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(avatarBtn)
        stackView.addArrangedSubview(likeStackView)
        stackView.addArrangedSubview(commentStackView)
        stackView.addArrangedSubview(shareStackView)
        
        avatarBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        likeStackView.heightAnchor.constraint(equalToConstant: 40.5).isActive = true
        commentStackView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        shareStackView.heightAnchor.constraint(equalToConstant: 41).isActive = true
        if #available(iOS 11.0, *) {
            stackView.setCustomSpacing(32, after: avatarBtn)
        } else {
            // Fallback on earlier versions
        }
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(-16)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(-45-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(-45)
            }
//            make.size.equalTo(CGSize(width: 50, height: 268))
            make.width.equalTo(50)
        }
    }
    
    fileprivate func initCaptionView() {
        
        captionStackView.addArrangedSubview(authorNameLabel)
        captionStackView.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(captionStackView)
        captionStackView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-12-50-16)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(-45-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(-45)
            }
        }
    }
    
    fileprivate func initRewardCountdownView() {
        let img = YYImage(named: "reward_videoAnimation")!
        let imgView = YYAnimatedImageView(image: img)
        
        
        rewardCountdownView.addSubviews([imgView, rewardCountdownLabel])
            
            
        imgView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.size.equalTo(CGSize(width: 55, height: 55))
        }
        rewardCountdownLabel.snp.makeConstraints { make in
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(imgView.snp.bottom)
        }
        
        
        contentView.addSubview(rewardCountdownView)
        rewardCountdownView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.bottom.equalTo(captionStackView.snp.top).offset(-25)
        }
    }
    
    fileprivate func initObserver() {
        player.addObserver(self, forKeyPath: "timeControlStatus", options: NSKeyValueObservingOptions.new, context: nil)
        
        
        //add time observer
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self] (time) in
            
            guard let currentSeconds = self?.player.currentTime().seconds else { return }
            guard let duationSeconds = self?.player.currentItem?.duration.seconds else { return }
            
            let timeInterval: TimeInterval = TimeInterval(duationSeconds - currentSeconds)
            let date = Date(timeIntervalSince1970: timeInterval)
            self?.rewardCountdownLabel.text = CourseCatalogueCell.timeFormatter.string(from: date)
            
        })
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(rewardStatusDidChange(sender:)), name: Notification.Video.rewardStatusDidChange, object: nil)
    }
    
    fileprivate func initConstraints() {
        playerStatusImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
//        playerView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = CGRect(x: 0, y: contentView.bounds.height - 500, width: contentView.bounds.width, height: 500)
        playerLayer.frame = contentView.layer.bounds
        CATransaction.commit()
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        isPlayerReady = false
//        playerView.cancelLoading()
//    }
    
    func setup(model: VideoModel) {
        self.model = model
        
        if let URLString = model.media?.url, let url = URL(string: URLString) {
            if let currentURL = (player.currentItem?.asset as? AVURLAsset)?.url {
                //TODO: cache asset
//                if currentURL.path != url.path.appending(".mp4") {
//                    player.replaceCurrentItem(with: CachingPlayerItem(url: url, customFileExtension: "mp4"))
                if currentURL.path != url.path {
                    player.replaceCurrentItem(with: AVPlayerItem(url: url))
                    NotificationCenter.default.addObserver(self, selector: #selector(playToEndTimeAction), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
                }
            } else {
                player.replaceCurrentItem(with: AVPlayerItem(url: url))
//                player.replaceCurrentItem(with: CachingPlayerItem(url: url, customFileExtension: "mp4"))
                NotificationCenter.default.addObserver(self, selector: #selector(playToEndTimeAction), name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            }
            
        }
        
        if let URLString = model.author?.avatar_url {
//            let processor = RoundCornerImageProcessor(cornerRadius: 50, targetSize: CGSize(width: 100, height: 100))
            avatarBtn.kf.setImage(with: URL(string: URLString), for: .normal, placeholder: UIImage(named: "public_avatarPlaceholder"))
        }
        
        if let likedCount = model.liked_count {
            likeCountLabel.text = "\(likedCount)"
        }
        if model.liked == true {
            likeImgView.tintColor = UIConstants.Color.primaryRed
        } else {
            likeImgView.tintColor = .white
        }
        if let commentedCount = model.comments_count {
            commentCountLabel.text = "\(commentedCount)"
        }
        if let sharedCount = model.share_count {
            shareCountLabel.text = "\(sharedCount)"
        }
        
        authorNameLabel.text = "@\(model.author?.name ?? "")"
        
        descriptionLabel.text = model.title
        
        
        //是否已读优先从本地缓存读取
        if let string = model.id, let videoID = Int(string) {
            if VideoPlayedCacheService.shared.finishedPlayingIDs?.contains(videoID) ?? false {
                model.viewed = true
            }
        }
        
        //赏金显示逻辑
        if AuthorizationService.sharedInstance.isSignIn() {
            if (model.rewardable_codes?.count ?? 0) > 0 {
                
                if model.viewed == true {
                    rewardCountdownView.isHidden = true
                    
                    if model.rewardable_codes?.contains("interact/api/attitudes#create") ?? false {
                        likeMarkLabel.isHidden = false
                    }
                    if model.rewardable_codes?.contains("interact/api/comments#create") ?? false {
                        commentMarkLabel.isHidden = false
                    }
                    if model.rewardable_codes?.contains("share_video") ?? false {
                        shareMarkLabel.isHidden = false
                    }
                } else {
                    rewardCountdownView.isHidden = false
                    
                    likeMarkLabel.isHidden = true
                    commentMarkLabel.isHidden = true
                    shareMarkLabel.isHidden = true
                }
            } else {
                rewardCountdownView.isHidden = true
                
                likeMarkLabel.isHidden = true
                commentMarkLabel.isHidden = true
                shareMarkLabel.isHidden = true
            }
            
        } else {
            if model.rewardable == true {
                if model.viewed == true {
                    likeMarkLabel.isHidden = false
                    commentMarkLabel.isHidden = false
                    shareMarkLabel.isHidden = false
                } else {
                    likeMarkLabel.isHidden = true
                    commentMarkLabel.isHidden = true
                    shareMarkLabel.isHidden = true
                    
                    rewardCountdownView.isHidden = false
                }
            }
        }
        
        
        
    }
    
    @objc func playerStatusBtnAction() {
        if player.rate == 0 {
            player.play()
        } else {
            player.pause()
        }
    }
    
    func showLikeViewAnim(newPoint:CGPoint, oldPoint:CGPoint) {
        
        
        let likeImageView = UIImageView.init(image: UIImage.init(named: "video_playerLikeAnimation"))
        var k = (oldPoint.y - newPoint.y) / (oldPoint.x - newPoint.x)
        k = abs(k) < 0.5 ? k : (k > 0 ? 0.5 : -0.5)
        let angle = .pi/4 * -k
        
        //TODO: point incorrect
        let newPoint = CGPoint(x: newPoint.x-40, y: newPoint.y-38)
            
        likeImageView.frame = CGRect.init(origin: newPoint, size: CGSize.init(width: 80, height: 80))
        likeImageView.transform = CGAffineTransform.init(scaleX: 0.8, y: 1.8).concatenating(CGAffineTransform.init(rotationAngle: angle))
        contentView.addSubview(likeImageView)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            likeImageView.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0).concatenating(CGAffineTransform.init(rotationAngle: angle))
        }) { finished in
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                likeImageView.transform = CGAffineTransform.init(scaleX: 3.0, y: 3.0).concatenating(CGAffineTransform.init(rotationAngle: angle))
                likeImageView.alpha = 0.0
            }, completion: { finished in
                likeImageView.removeFromSuperview()
            })
        }
    }
    
    @objc func playToEndTimeAction() {
        player.seek(to: CMTime.zero)
        
        //记录播放过的视频，下次不显示赏金倒计时
        if !AuthorizationService.sharedInstance.isSignIn(), let string = model?.id, let videoID = Int(string) {
            VideoPlayedCacheService.shared.cacheFinishedID(videoID)
        }
        
        if AuthorizationService.sharedInstance.isSignIn() {
            if model?.rewardable_codes?.contains("interact/api/attitudes#create") ?? false {
                likeMarkLabel.isHidden = false
            }
            if model?.rewardable_codes?.contains("interact/api/comments#create") ?? false {
                commentMarkLabel.isHidden = false
            }
            if model?.rewardable_codes?.contains("share_video") ?? false {
                shareMarkLabel.isHidden = false
            }
            if model?.viewed == false {
                model?.viewed = true
                rewardCountdownView.isHidden = true
                
                asReadRequest()
            }
            
        } else {
            likeMarkLabel.isHidden = false
            commentMarkLabel.isHidden = false
            shareMarkLabel.isHidden = false
            rewardCountdownView.isHidden = true
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "timeControlStatus") {
            if player.timeControlStatus == .playing {
                self.playerStatusImgView.isHidden = true
            } else if player.timeControlStatus == .paused {
                self.playerStatusImgView.isHidden = false
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func startCountdown() {
        if (model?.rewardable_codes?.count ?? 0) > 0 && model?.viewed == false {
            rewardCountdownView.isHidden = false
        } else {
            rewardCountdownView.isHidden = true
        }
        
    }
    
    // MARK: - ============= Reward Observer =============
    @objc func rewardStatusDidChange(sender: Notification) {
        if let info = sender.userInfo, let videoID = info["id"] as? String, videoID == model?.id, let rewardable_codes = info["rewardable_codes"] as? [String] {
            
            if rewardable_codes.contains("interact/api/attitudes#create") {
                likeMarkLabel.isHidden = false
            } else {
                likeMarkLabel.isHidden = true
            }
            if rewardable_codes.contains("interact/api/comments#create") {
                commentMarkLabel.isHidden = false
            } else {
                commentMarkLabel.isHidden = true
            }
            if rewardable_codes.contains("share_video") {
                shareMarkLabel.isHidden = false
            } else {
                shareMarkLabel.isHidden = true
            }
        }
    }
    
    // MARK: - ============= Action =============
    @objc func commentBtnAction() {
        if let delegate = delegate {
            delegate.tableViewCellComment(self)
        }
    }
    
    @objc func forwardBtnAction() {
        if let delegate = delegate {
            delegate.tableViewCellForward(self)
        }
    }
    
    @objc func avatarBtnAction() {
        if let delegate = delegate {
            delegate.tableViewCellAvatar(self)
        }
    }
    
    fileprivate func asReadRequest() {
        guard let string = model?.id, let videoID = Int(string) else { return }
        
        VideoProvider.request(.video_viewed(videoID), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
        }))
    }
    
    deinit {
        player.removeObserver(self, forKeyPath: "timeControlStatus")
        
    }
}


extension VideoDetailCell {
    
    @objc func videoLikeRequest() {
        guard AuthorizationService.sharedInstance.isSignIn() else {
            let authorizationNavigationController = BaseNavigationController(rootViewController: AuthorizationViewController())
            UIApplication.shared.keyWindow?.rootViewController?.present(authorizationNavigationController, animated: true, completion: nil)
            return
        }
        
        guard let videoID = model?.id, let liked = model?.liked else { return }
        guard isRequesting == false else { return }
        
        
        //TODO: 赏金视频点赞后不能取消(服务端未识别当前用户是否已点赞)
        if model?.rewardable == true && liked == true { return }
        
        isRequesting = true
        VideoProvider.request(.video_like(videoID, !liked), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
            
            self.isRequesting = false
            
            if code >= 0 {
                self.model?.liked = !liked
                if let likedCount = self.model?.liked_count {
                    if liked == true {
                        self.model?.liked_count = likedCount - 1
                        self.likeCountLabel.text = String(likedCount - 1)
                    } else {
                        self.model?.liked_count = likedCount + 1
                        self.likeCountLabel.text = String(likedCount + 1)
                    }
                    
                }
                
                if self.model?.liked == true {
                    self.likeImgView.tintColor = UIConstants.Color.primaryRed
                } else {
                    self.likeImgView.tintColor = .white
                }
                
                if let reward = JSON?["reward"] as? [String: Any], let status = reward["code"] as? String, status == "success", let amount = reward["amount"] as? String {
                    let view = RewardView()
                    UIApplication.shared.keyWindow?.addSubview(view)
                    view.snp.makeConstraints { make in
                        make.edges.equalToSuperview()
                    }
                    view.present(string: amount, mode: RewardView.DRewardMode.like)
                    
                    if let rewardCodes = reward["rewardable_codes"] as? [String] {
                        NotificationCenter.default.post(name: Notification.Video.rewardStatusDidChange, object: nil, userInfo: ["id": videoID, "rewardable_codes": rewardCodes])
                    }
                    
                    return
                }
            }
        }))
    }
}


protocol VideoDetailCellDelegate: NSObjectProtocol {
    
    func tableViewCellComment(_ tableViewCell: VideoDetailCell)
    
    func tableViewCellForward(_ tableViewCell: VideoDetailCell)
    
    func tableViewCellAvatar(_ tableViewCell: VideoDetailCell)
}
