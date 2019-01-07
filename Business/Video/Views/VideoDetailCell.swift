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
    
    var isPlayerReady: Bool = false
    var onPlayerReady: (()->Void)?
    
    lazy var playerView: AVPlayerView = {
        let view = AVPlayerView()
        view.delegate = self
        return view
    }()
    
    lazy fileprivate var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.2).cgColor, UIColor(white: 0, alpha: 0.4).cgColor]
        layer.locations = [0.3, 0.6, 1.0]
        layer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
        layer.endPoint = CGPoint.init(x: 0.0, y: 1.0)
        return layer
    }()
    
    lazy fileprivate var favoriteBtn: UIButton = {
        let button = UIButton()
//        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
//        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var avatarBtn: UIButton = {
        let button = UIButton()
        //        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
        //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var likeImgView: UIImageView = {
        let imgView = UIImageView()
//        imgView.image = UIImage(named: <#T##String#>)
        return imgView
    }()
    
    lazy fileprivate var likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var commentMarkImgView: UIImageView = {
        let imgView = UIImageView()
//        imgView.image = UIImage(named: <#T##String#>)
        return imgView
    }()
    
    lazy fileprivate var shareCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var shareMarkImgView: UIImageView = {
        let imgView = UIImageView()
//        imgView.image = UIImage(named: <#T##String#>)
        return imgView
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
//        contentView.layer.addSublayer(gradientLayer)
        
        contentView.addSubview(playerView)
        
        initActionView()
        initCaptionView()
        initConstraints()
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        CATransaction.begin()
//        CATransaction.setDisableActions(true)
//        gradientLayer.frame = CGRect.init(x: 0, y: self.bounds.height - 500, width: self.bounds.width, height: 500)
//        CATransaction.commit()
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initActionView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 16
            return view
        }()
        
        //Like Action
        let likeStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        let likeBtn: UIButton = {
            let button = UIButton()
            //        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
            //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        likeStackView.addSubview(likeBtn)
        likeBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        likeStackView.addSubview(likeBtn)
        likeStackView.addArrangedSubview(likeImgView)
        likeStackView.addArrangedSubview(likeCountLabel)
        
        
        //Comment Action
        let commentStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        let commentBtn: UIButton = {
            let button = UIButton()
            //        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
            //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        let commentImgView: UIImageView = {
            let imgView = UIImageView()
//            imgView.image = UIImage(named: <#T##String#>)
            return imgView
        }()
        commentStackView.addSubviews([commentBtn, commentMarkImgView])
        commentBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        commentMarkImgView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(-5)
        }
        commentStackView.addArrangedSubview(commentImgView)
        commentStackView.addArrangedSubview(commentCountLabel)
        
        
        //Share Action
        let shareStackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .vertical
            view.distribution = .fillProportionally
            return view
        }()
        let shareBtn: UIButton = {
            let button = UIButton()
            //        button.setImage(UIImage(named: <#T##String#>)?.withRenderingMode(.alwaysTemplate), for: .normal)
            //        button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        let shareImgView: UIImageView = {
            let imgView = UIImageView()
            //            imgView.image = UIImage(named: <#T##String#>)
            return imgView
        }()
        shareStackView.addSubviews([shareBtn, shareMarkImgView])
        shareBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        shareMarkImgView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(-5)
        }
        shareStackView.addArrangedSubview(shareImgView)
        shareStackView.addArrangedSubview(shareCountLabel)
        
        
        //StackView Layout
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(avatarBtn)
        stackView.addArrangedSubview(likeStackView)
        stackView.addArrangedSubview(commentStackView)
        stackView.addArrangedSubview(shareStackView)
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(-16)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(-45-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(-45)
            }
            make.size.equalTo(CGSize(width: 50, height: 223))
        }
    }
    
    fileprivate func initCaptionView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .leading
            view.axis = .vertical
            view.distribution = .fillProportionally
            view.spacing = 10
            return view
        }()
        
        stackView.addArrangedSubview(authorNameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-12-50-16)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(-45-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(-45)
            }
        }
    }
    
    fileprivate func initConstraints() {
        playerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        isPlayerReady = false
        playerView.cancelLoading()
    }
    
    func setup(model: VideoModel) {
        if let URLString = model.media?.url, let url = URL(string: URLString) {
//            playerView.setup(url: url)
            playerView.setPlayerSourceUrl(url: URLString)
        }
        
        if let URLString = model.author?.avatar_url {
            let processor = RoundCornerImageProcessor(cornerRadius: 25, targetSize: CGSize(width: 50, height: 50))
            avatarBtn.kf.setImage(with: URL(string: URLString), for: .normal, placeholder: UIImage(named: "public_avatarPlaceholder"), options: [.processor(processor)])
        }
        
        if let likedCount = model.liked_count {
            likeCountLabel.text = "\(likedCount)"
        }
        //TODO: image
//        if model.isLike == true {
//            likeImgView.image =
//        }
        if let commentedCount = model.comments_count {
            commentCountLabel.text = "\(commentedCount)"
        }
        if let sharedCount = model.share_count {
            shareCountLabel.text = "\(sharedCount)"
        }
        
        authorNameLabel.text = "@\(model.author?.name ?? "")"
        
        descriptionLabel.text = model.title
    }
}


// MARK: - ============= AVPlayer =============
extension VideoDetailCell {
    func play() {
        playerView.play()
    }
    
    func pause() {
        playerView.pause()
    }
    
    func replay() {
        playerView.replay()
    }
}

// MARK: - ============= AVPlayerUpdateDelegate =============
extension VideoDetailCell: AVPlayerUpdateDelegate {
    
    func onProgressUpdate(current: CGFloat, total: CGFloat) {
        
    }
    
    func onPlayItemStatusUpdate(status: AVPlayerItem.Status) {
        switch status {
        case .unknown:
//            startLoadingPlayItemAnim()
            break
        case .readyToPlay:
//            startLoadingPlayItemAnim(false)
            
            isPlayerReady = true
            //            musicAlum.startAnimation(rate: CGFloat(aweme?.rate ?? 0))
            onPlayerReady?()
            break
        case .failed:
//            startLoadingPlayItemAnim(false)
            break
        }
    }
}
