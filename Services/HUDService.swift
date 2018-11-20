//
//  HUDService.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/12.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import Foundation

class HUDService {
    
    static let sharedInstance = HUDService()
    
    private init() { }
    
    func show(string: String) {
        let HUD = HUDView()
        HUD.titleLabel.text = string
        UIApplication.shared.keyWindow?.addSubview(HUD)
        HUD.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            HUD.removeFromSuperview()
        }
    }
    
    func showFetchingView(target view: UIView) {
        let HUD = FetchView()
        view.addSubview(HUD)
        HUD.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func hideFetchingView(target view: UIView) {
        if let subview = view.subviews.first(where: { (subview) -> Bool in
            return subview.isKind(of: FetchView.self)
        }) {
            subview.removeFromSuperview()
        }
    }
}

fileprivate class HUDView: UIView {
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.primaryGreen
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
        label.preferredMaxLayoutWidth = UIScreenWidth-100
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        layer.shadowOffset = CGSize(width: 0, height: 8.0)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 11
        layer.shadowColor = UIColor.black.cgColor
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
//            make.leading.equalTo(26)
//            make.trailing.lessThanOrEqualTo(-26)
//            make.top.equalTo(14)
//            make.bottom.lessThanOrEqualTo(-14)
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override var intrinsicContentSize: CGSize {
        let size = NSString(string: titleLabel.text!).boundingRect(with: CGSize(width: UIScreenWidth-100, height: CGFloat.greatestFiniteMagnitude), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : titleLabel.font], context: nil).size
        layer.cornerRadius = (size.height+28)/2
        return CGSize(width: size.width+52, height: size.height+28)
    }
}


fileprivate class FetchView: UIView {
    
    lazy fileprivate var animationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var imgView: YYAnimatedImageView = {
        let view = YYAnimatedImageView(image: YYImage(named: "public_loadingAnimation.gif"))
        return view
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubview(animationView)
        animationView.addSubview(imgView)
        
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}


class CustomMJHeader: MJRefreshHeader {
    
    lazy fileprivate var imgView: YYAnimatedImageView = {
        let view = YYAnimatedImageView(image: YYImage(named: "public_loadingAnimation.gif"))
        view.autoPlayAnimatedImage = false
        addSubview(view)
        return view
    }()
    
    override func prepare() {
        super.prepare()
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        //FIXME: safeArea is nil
        if #available(iOS 11, *) {
            let safeTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight
            imgView.origin = CGPoint(x: mj_w/2-22, y: mj_h/2-22-safeTop/2)
        } else {
            imgView.origin = CGPoint(x: mj_w/2-22, y: mj_h/2-22-UIStatusBarHeight)
        }
        imgView.size = CGSize(width: 44, height: 44)
    }
    
    fileprivate var refreshState: MJRefreshState = .idle
    
    override var state: MJRefreshState {
        get {
            return refreshState
        }
        set {
            super.state = newValue
            refreshState = newValue
            if newValue == .idle {
                imgView.stopAnimating()
                imgView.currentAnimatedImageIndex = 0
            } else if newValue == .refreshing {
                imgView.startAnimating()
            } else {
                imgView.stopAnimating()
            }
            
            print(newValue.rawValue)
        }
    }
}
