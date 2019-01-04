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
    
    fileprivate var HUDContainers: [HUDView] = [HUDView]()
    
    private init() { }
    
    func show(string: String) {
        for view in HUDContainers {
            view.removeFromSuperview()
        }
        HUDContainers.removeAll()
        
        let HUD = HUDView()
        HUD.titleLabel.text = string
        UIApplication.shared.keyWindow?.addSubview(HUD)
        HUD.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        HUDContainers.append(HUD)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            if let _ = HUD.superview {
                HUD.removeFromSuperview()
            }
            if let index = self.HUDContainers.firstIndex(of: HUD) {
                self.HUDContainers.remove(at: index)
            }
        }
    }
    
    func hideAllHUD() {
        for view in HUDContainers {
            view.removeFromSuperview()
        }
        HUDContainers.removeAll()
    }
    
    func showFetchingView(target view: UIView, frame: CGRect = .zero) {
        guard !view.subviews.contains(where: { (subview) -> Bool in
            return subview.isKind(of: FetchView.self)
        }) else {
            return
        }
        
        let HUD = FetchView()
        view.addSubview(HUD)
        
        if frame != .zero {
            HUD.snp.makeConstraints { make in
                make.size.equalTo(frame.size)
                make.leading.equalTo(frame.origin.x)
                make.top.equalTo(frame.origin.y)
            }
        } else if let scrollView = view as? UIScrollView {
            HUD.snp.makeConstraints { make in
                make.size.equalTo(scrollView.bounds.size)
                make.leading.equalTo(scrollView.contentOffset.x)
                make.top.equalTo(scrollView.contentOffset.y)
            }
        } else {
            HUD.snp.makeConstraints { make in
                make.edges.equalTo(view)
            }
        }
        
    }
    
    func hideFetchingView(target view: UIView) {
        if let subview = view.subviews.first(where: { (subview) -> Bool in
            return subview.isKind(of: FetchView.self)
        }) {
            subview.alpha = 1.0
            UIView.animate(withDuration: 0.35, animations: {
                subview.alpha = 0.0
            }) { (bool) in
                subview.removeFromSuperview()
            }
            
        }
    }
    
    func showNoNetworkView(target view: UIView, frame: CGRect = .zero, retry block: @escaping ()->()) {
        let HUD = ResultView()
        view.addSubview(HUD)
        HUD.actionBlock = block
        
        if frame != .zero {
            HUD.snp.makeConstraints { make in
                make.size.equalTo(frame.size)
                make.leading.equalTo(frame.origin.x)
                make.top.equalTo(frame.origin.y)
            }
        } else if let scrollView = view as? UIScrollView {
            HUD.snp.makeConstraints { make in
                make.size.equalTo(scrollView.bounds.size)
                make.leading.equalTo(scrollView.contentOffset.x)
                make.top.equalTo(scrollView.contentOffset.y)
            }
        } else {
            HUD.snp.makeConstraints { make in
                make.edges.equalTo(view)
            }
        }
    }
    
    func showNoDataView(target view: UIView, frame: CGRect = .zero, redirect block: (()->())? = nil) {
        let HUD = ResultView()
        HUD.setupNoData(isSolutionHidden: block == nil)
        view.addSubview(HUD)
        HUD.actionBlock = block
        
        if frame != .zero {
            HUD.snp.makeConstraints { make in
                make.size.equalTo(frame.size)
                make.leading.equalTo(frame.origin.x)
                make.top.equalTo(frame.origin.y)
            }
        } else if let scrollView = view as? UIScrollView {
            HUD.snp.makeConstraints { make in
                make.size.equalTo(scrollView.bounds.size)
                make.leading.equalTo(scrollView.contentOffset.x)
                make.top.equalTo(scrollView.contentOffset.y)
            }
        } else {
            HUD.snp.makeConstraints { make in
                make.edges.equalTo(view)
            }
        }
    }
    
    func hideResultView(target view: UIView) {
        if let subview = view.subviews.first(where: { (subview) -> Bool in
            return subview.isKind(of: ResultView.self)
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


class FetchView: UIView {
    
    lazy fileprivate var animationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy fileprivate var imgView: YYAnimatedImageView = {
        let view = YYAnimatedImageView(image: YYImage(named: "public_loadingAnimation.gif"))
        return view
    }()
    
    lazy fileprivate var backBarBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "public_backBarItem")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIConstants.Color.head
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubviews([animationView, backBarBtn])
        animationView.addSubview(imgView)
        
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 29, height: 38))
        }
        imgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backBarBtn.snp.makeConstraints { make in
            make.leading.equalTo(0)
            if #available(iOS 11, *) {
                make.top.equalTo(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight)
            } else {
                make.top.equalTo(UIStatusBarHeight)
            }
            make.width.equalTo(62.5)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func didMoveToWindow() {
        var viewController: UIViewController?
        var view: UIView? = self
        repeat {
            if view?.next?.isKind(of: UIViewController.self) ?? false {
                viewController = view?.next as? UIViewController
                break
            }
            view = view?.superview
        } while view != nil
        
        if viewController?.navigationController?.isNavigationBarHidden ?? true {
            backBarBtn.isHidden = false
        }
    }
    
    @objc func dismissBtnAction() {
        var viewController: UIViewController?
        var view: UIView? = self
        repeat {
            if view?.next?.isKind(of: UIViewController.self) ?? false {
                viewController = view?.next as? UIViewController
                break
            }
            view = view?.superview
        } while view != nil
        
        if let navigationController = viewController?.navigationController {
            navigationController.popViewController(animated: true)
        }
    }
}


class ResultView: UIView {
    
    enum ResultMode {
        case noNetwork
        case noData
    }
    
    var mode: ResultMode = .noNetwork
    
    var actionBlock: (()->())?
    
    lazy fileprivate var actionBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(actionBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 32
        return view
    }()
    
    lazy fileprivate var stackActionBtn: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(actionBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy var iconImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_noNetworkImg")
        return imgView
    }()
    
    lazy var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.head
        label.textAlignment = .center
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        label.setSymbolText("氧育现在很方，你的网络好像开小差了\n请点击 刷新一下", symbolText: "刷新一下", symbolAttributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.primaryGreen])
        return label
    }()
    
    lazy var solutionBtn: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
        button.titleLabel?.font = UIFont(name: "PingFangSC-Regular", size: 18)!
        button.setTitle("   查看解决方案   ", for: .normal)
        button.layer.borderColor = UIConstants.Color.primaryGreen.cgColor
        button.layer.borderWidth = 0.5
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(solutionBtnAction), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .white
        
        addSubviews([actionBtn, stackView])
        stackView.addSubviews([stackActionBtn])
        
        actionBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackActionBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIScreenWidth)
            make.centerY.equalToSuperview()//.multipliedBy((1-0.618)/0.5)
        }
        stackView.addArrangedSubview(iconImgView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(solutionBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setupNoData(isSolutionHidden: Bool) {
        mode = .noData
        iconImgView.image = UIImage(named: "public_noDataImg")
        titleLabel.setParagraphText("糟糕！这里什么都没有")
        
        solutionBtn.isHidden = isSolutionHidden
        solutionBtn.setTitle("   随便逛逛   ", for: .normal)
    }
    
    @objc func actionBtnAction() {
        guard mode == .noNetwork else { return }
        
        if let block = actionBlock {
            block()
        }
        removeFromSuperview()
    }
    
    @objc func solutionBtnAction() {
        if mode == .noNetwork {
            var viewController: UIViewController?
            var view: UIView? = self
            repeat {
                if view?.next?.isKind(of: UIViewController.self) ?? false {
                    viewController = view?.next as? UIViewController
                    break
                }
                view = view?.superview
            } while view != nil
            
            if let navigationController = viewController?.navigationController {
                navigationController.pushViewController(SolutionViewController(), animated: true)
            }
            
        } else if mode == .noData {
            if let block = actionBlock {
                block()
            }
        }
        
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
        
        if #available(iOS 11, *) {
            let safeTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight
            mj_h = MJRefreshHeaderHeight + safeTop
        }
        
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        if #available(iOS 11, *) {
            let safeTop = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? UIStatusBarHeight
            imgView.origin = CGPoint(x: mj_w/2-29/2, y: mj_h/2-38/2+safeTop/2)
        } else {
            imgView.origin = CGPoint(x: mj_w/2-29/2, y: mj_h/2-38/2-UIStatusBarHeight)
        }
        imgView.size = CGSize(width: 29, height: 38)
    }
    
//    fileprivate var refreshState: MJRefreshState = .idle
    
    override var state: MJRefreshState {
//        get {
//            return refreshState
//        }
//        set {
//            super.state = newValue
//            refreshState = newValue
//            if newValue == .idle {
//                imgView.stopAnimating()
//                imgView.currentAnimatedImageIndex = 0
//            } else if newValue == .refreshing {
//                imgView.startAnimating()
//            } else {
//                imgView.stopAnimating()
//            }
//
//        }
        didSet {
            if state == .idle {
                imgView.stopAnimating()
                imgView.currentAnimatedImageIndex = 0
            } else if state == .refreshing {
                imgView.startAnimating()
            } else {
                imgView.stopAnimating()
            }
            
        }
    }
}
