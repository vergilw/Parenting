//
//  DVideoRewardViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/2/28.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class DVideoRewardViewController: BaseViewController {

    fileprivate var videoID: Int?
    
    fileprivate var giftModels: [GiftModel]?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreenWidth/4, height: 110)
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(RewardGiftCell.self, forCellWithReuseIdentifier: RewardGiftCell.className())
        view.dataSource = self
        view.delegate = self
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        view.backgroundColor = .clear
        view.allowsMultipleSelection = false
        return view
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let view = UIPageControl()
        view.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.3)
        view.currentPageIndicatorTintColor = .white
        return view
    }()
    
    fileprivate lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot1
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var actionBtn: ActionButton = {
        let button = ActionButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot1
        button.setTitle("打赏", for: .normal)
        button.backgroundColor = UIConstants.Color.primaryGreen
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(actionBtnAction), for: .touchUpInside)
        return button
    }()
    
    var presentationView: GiftPresentationView?
    
    var workItem: DispatchWorkItem?
    
    init(videoID: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self.videoID = videoID
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        fetchData()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.85)
        
        view.addSubviews([collectionView, pageControl, balanceLabel, actionBtn])
        view.drawSeparator(startPoint: CGPoint(x: 0, y: 15+220+20), endPoint: CGPoint(x: UIScreenWidth, y: 15+220+20), color: UIColor(white: 1, alpha: 0.2))
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(15)
            make.height.equalTo(220)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(collectionView.snp.bottom)
            make.height.equalTo(20)
        }
        balanceLabel.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(collectionView.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        actionBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalTo(balanceLabel)
            make.size.equalTo(CGSize(width: 70, height: 30))
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: Notification.User.userInfoDidChange, object: nil)
    }
    
    // MARK: - ============= Request =============
    func fetchData() {
        HUDService.sharedInstance.showFetchingView(target: view)
        
        VideoProvider.request(.video_gifts, completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in
        
            HUDService.sharedInstance.hideFetchingView(target: self.view)
            
            if code >= 0 {
                if let data = JSON?["gifts"] as? [[String: Any]] {
                    self.giftModels = [GiftModel].deserialize(from: data) as? [GiftModel]
                    
                    self.pageControl.numberOfPages = data.count/8
                    if data.count%8 != 0 {
                        self.pageControl.numberOfPages = self.pageControl.numberOfPages + 1
                    }
                }
                
                if let wallet = JSON?["wallet"] as? [String: Any], let balance = wallet["amount"] as? String {
                    let user = AuthorizationService.sharedInstance.user
                    user?.balance = balance
                    AuthorizationService.sharedInstance.user = user
                }
                
                self.reload()
            }
        }))
    }
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        if let balance = AuthorizationService.sharedInstance.user?.balance {
            balanceLabel.text = "氧育币 \(balance)"
        } else {
            balanceLabel.text = "氧育币 0"
        }
        
        collectionView.reloadData()
    }
    
    // MARK: - ============= Action =============
    @objc func actionBtnAction() {
        guard let index = collectionView.indexPathsForSelectedItems?.first?.row, let model = giftModels?[exist: index], let giftID = model.id, let iconULRString = model.icon_url, let priceString = model.amount, let price = Float(priceString) else { return }
        
        guard let string = AuthorizationService.sharedInstance.user?.balance, let balance = Float(string), balance >= price else {
            let navigationController = BaseNavigationController(rootViewController: DTopUpViewController())
            navigationController.modalPresentationStyle = .overFullScreen
            present(navigationController, animated: true, completion: nil)
            
            return
        }
        
        actionBtn.startAnimating()

        VideoProvider.request(.video_gift_give(giftID, videoID ?? 0), completion: ResponseService.sharedInstance.response(completion: { (code, JSON) in

            self.actionBtn.stopAnimating()

            if code >= 0 {
                let user = AuthorizationService.sharedInstance.user
                user?.balance = "\(balance - price)"
                AuthorizationService.sharedInstance.user = user
                self.balanceLabel.text = "氧育币 \(balance - price)"
                
                self.presentationView?.removeFromSuperview()
                self.workItem?.cancel()
                
                self.presentationView = GiftPresentationView(imgURLString: iconULRString)
                self.presentingViewController?.view.addSubview(self.presentationView!)
                self.presentingViewController?.view.bringSubviewToFront(self.presentationView!)
                self.presentationView?.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalTo((UIScreenHeight-self.view.bounds.height)/2)
                }

                self.presentationView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveLinear, animations: {
                    self.presentationView?.transform = .identity
                }, completion: { finished in
                    self.workItem = DispatchWorkItem(block: { [weak self] in
                        self?.presentationView?.removeFromSuperview()
                    })
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3, execute: self.workItem!)
                })
                
                
                NotificationCenter.default.post(name: Notification.Video.videoGiftGiveDidSuccess, object: nil)
            }
        }))
    }
    
    // MARK: - ============= Public =============
    
    // MARK: - ============= Private =============

    
    deinit {
        self.presentationView?.removeFromSuperview()
    }
}


extension DVideoRewardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return giftModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RewardGiftCell.className(), for: indexPath) as! RewardGiftCell
        if let model = giftModels?[exist: indexPath.row] {
            cell.setup(model: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}


extension DVideoRewardViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        
        let index = Int(scrollView.contentOffset.x / UIScreenWidth)
        
        pageControl.currentPage = index
    }
        
}
