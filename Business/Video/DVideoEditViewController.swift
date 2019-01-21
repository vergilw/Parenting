//
//  DVideoEditViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/15.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import PLShortVideoKit

class DVideoEditViewController: BaseViewController {

    fileprivate let editor: PLShortVideoEditor
    
    fileprivate let asset: AVAsset
    
    fileprivate var outputSettings: [AnyHashable: Any]
    
    fileprivate var movieSettings: [AnyHashable: Any]
    
    fileprivate lazy var filterData: VideoFilter = VideoFilter()
    
    fileprivate lazy var composerMusicBtn: VerticallyButton = {
        let button = VerticallyButton()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot
        button.setTitle("剪音乐", for: .normal)
        button.setImage(UIImage(named: "video_editComposeMusic"), for: .normal)
        button.padding = 4
        //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var videoSoundImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_editSelectSoundIcon")
        imgView.contentMode = .center
        return imgView
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreenWidth, height: UIScreenHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VideoEditFilterCell.self, forCellWithReuseIdentifier: VideoEditFilterCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.isPagingEnabled = true
        return view
    }()
    
    init(settings: [String: Any]) {
        outputSettings = settings
        movieSettings = settings[PLSMovieSettingsKey] as! [AnyHashable : Any]
        asset = movieSettings[PLSAssetKey] as! AVAsset
        
        editor = PLShortVideoEditor(asset: asset)
        editor.loopEnabled = true
        editor.timeRange = CMTimeRange(start: CMTime(seconds: movieSettings[PLSStartTimeKey] as! Double,
                                                     preferredTimescale: CMTimeScale(NSEC_PER_SEC)),
                                       duration: CMTime(seconds: movieSettings[PLSDurationKey] as! Double,
                                                        preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
        editor.videoSize = asset.pls_videoSize
        editor.fillMode = PLSVideoFillModeType(rawValue: 1)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
        
        if !(navigationController?.isNavigationBarHidden ?? true) {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = UIColor("#353535")
        
        view.addSubview(editor.previewView)
        editor.startEditing()
        
        view.addSubview(collectionView)
        
        initBackBtn()
        initTopView()
        initBottomView()
        initSubmitBtn()
        
    }
    
    fileprivate func initBackBtn() {
        let img = UIImage(named: "public_backBarItem")
        let backBarBtn: UIButton = {
            let button = UIButton()
            button.setImage(img?.withRenderingMode(.alwaysTemplate), for: .normal)
            button.tintColor = .white
            button.addTarget(self, action: #selector(backBarItemAction), for: .touchUpInside)
            return button
        }()
        view.addSubview(backBarBtn)
        backBarBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            if #available(iOS 11, *) {
                make.top.equalTo(UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0)
            } else {
                make.top.equalTo(0)
            }
            make.size.equalTo(CGSize(width: UIConstants.Margin.leading*2+12, height: 60+22))
        }
    }
    
    fileprivate func initTopView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .bottom
            view.axis = .horizontal
            view.distribution = .equalSpacing
            view.spacing = 25
            return view
        }()
        
        let composerVideoBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("剪视频", for: .normal)
            button.setImage(UIImage(named: "video_editComposeVideo"), for: .normal)
            button.padding = 4.5
            button.addTarget(self, action: #selector(videoClipBtnAction), for: .touchUpInside)
            return button
        }()
        
        let volumeBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("音量", for: .normal)
            button.setImage(UIImage(named: "video_editVolume"), for: .normal)
            button.padding = 7.5
            button.addTarget(self, action: #selector(videoVolumeBtnAction), for: .touchUpInside)
            return button
        }()
        
        let selectSoundBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("选音乐", for: .normal)
            button.setImage(UIImage(named: "video_editSelectSoundBg"), for: .normal)
            button.padding = 0
            //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        
        selectSoundBtn.imageView?.addSubview(videoSoundImgView)
        videoSoundImgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 24.5, height: 24.5))
        }
        
        stackView.addArrangedSubview(composerVideoBtn)
        stackView.addArrangedSubview(composerMusicBtn)
        stackView.addArrangedSubview(volumeBtn)
        stackView.addArrangedSubview(selectSoundBtn)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            if #available(iOS 11, *) {
                make.top.equalTo((UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 23)
            } else {
                make.top.equalTo(23)
            }
        }
    }
    
    fileprivate func initBottomView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .bottom
            view.axis = .horizontal
            view.distribution = .equalSpacing
            view.spacing = 25
            return view
        }()
        
        let filtersBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("滤镜", for: .normal)
            button.setImage(UIImage(named: "video_editFilters"), for: .normal)
            button.padding = 4.5
            button.addTarget(self, action: #selector(videoFiltersBtnAction), for: .touchUpInside)
            return button
        }()
        
        let selectCoverBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("选封面", for: .normal)
            button.setImage(UIImage(named: "video_editCover"), for: .normal)
            button.padding = 4.5
            //            button.addTarget(self, action: #selector(<#BtnAction#>), for: .touchUpInside)
            return button
        }()
        
        let stickersBtn: VerticallyButton = {
            let button = VerticallyButton()
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIConstants.Font.foot
            button.setTitle("贴纸", for: .normal)
            button.setImage(UIImage(named: "video_editStickers"), for: .normal)
            button.padding = 4.5
            button.addTarget(self, action: #selector(videoStickersBtnAction), for: .touchUpInside)
            return button
        }()
        
        stackView.addArrangedSubview(filtersBtn)
        stackView.addArrangedSubview(selectCoverBtn)
        stackView.addArrangedSubview(stickersBtn)
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) - 30)
            } else {
                make.bottom.equalTo(-30)
            }
        }
    }
    
    fileprivate func initSubmitBtn() {
        let submitBtn: UIButton = {
            let button = UIButton()
            button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitle("下一步", for: .normal)
            button.backgroundColor = .white
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(submitBtnAction), for: .touchUpInside)
            return button
        }()
        
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            if #available(iOS 11, *) {
                make.bottom.equalTo(-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0) - 33)
            } else {
                make.bottom.equalTo(-33)
            }
            make.size.equalTo(CGSize(width: 82.5, height: 40))
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        editor.previewView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    // MARK: - ============= Action =============
    @objc func videoClipBtnAction() {
        let viewController = DVideoClipViewController(asset: asset, settings: movieSettings)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        viewController.clipHandler = { [weak self] (startSeconds, endSeconds) in
            self?.movieSettings[PLSStartTimeKey] = NSNumber(value: startSeconds)
            self?.movieSettings[PLSDurationKey] = NSNumber(value: endSeconds-startSeconds)
            self?.editor.timeRange = CMTimeRange(start: CMTime(seconds: startSeconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), end: CMTime(seconds: endSeconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
            self?.editor.startEditing()
        }
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func videoVolumeBtnAction() {
        let viewController = DVideoVolumeViewController(videoVolume: Float(editor.volume), musicVolume: Float(editor.musicVolume))
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        viewController.editHandler = { [weak self] (videoVolume, musicVolume) in
            self?.editor.volume = CGFloat(videoVolume)
            self?.editor.updateMusic(CMTimeRange.zero, volume: NSNumber(value: musicVolume))
        }
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func videoFiltersBtnAction() {
        let index = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
        let viewController = DVideoFiltersViewController(selectedIndex: index)
        viewController.modalPresentationStyle = .custom
        viewController.transitioningDelegate = self
        viewController.editHandler = { [weak self] (selectedIndex) in
            
            if let imgPath = self?.filterData.filterImgs[exist: selectedIndex] {
                self?.editor.addFilter(imgPath)
                self?.collectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition.centeredHorizontally)
            }
        }
        present(viewController, animated: true, completion: nil)
    }

    @objc func videoStickersBtnAction() {
        let stickerView = VideoStickerView(img: UIImage(named: "payment_coinLargeIcon")!)
        view.addSubview(stickerView)
        stickerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    @objc func submitBtnAction() {
        editor.stopEditing()
        
        let exportSession = PLSAVAssetExportSession(asset: asset)
        exportSession?.outputFileType = .MPEG4
        exportSession?.shouldOptimizeForNetworkUse = true
        exportSession?.outputSettings = outputSettings
        exportSession?.isExportMovieToPhotosAlbum = false
        exportSession?.audioChannel = 2
        exportSession?.audioBitrate = PLSAudioBitRate(128000)
        exportSession?.outputVideoFrameRate = min(60, asset.pls_normalFrameRate)
        //TODO: aspect video size to 16:9
        exportSession?.outputVideoSize = asset.pls_videoSize
        exportSession?.videoLayerOrientation = .portrait
        
        //filter
        let index = collectionView.indexPathsForSelectedItems?.first?.row ?? 0
        if let imgPath = filterData.filterImgs[exist: index] {
            exportSession?.addFilter(imgPath)
        }
        
        //cover
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.requestedTimeToleranceBefore = .zero
        imgGenerator.requestedTimeToleranceAfter = .zero
        imgGenerator.appliesPreferredTrackTransform = true
        imgGenerator.maximumSize = asset.pls_videoSize
        guard let cgImg = try? imgGenerator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: CMTimeScale(exactly: 600)!), actualTime: nil) else {
            return
        }
        
        exportSession?.failureBlock = { error in
            
        }
        exportSession?.completionBlock = { fileURL in
            guard let fileURL = fileURL else { return }
            
            DispatchQueue.main.async {
                let viewController = DVideoPostViewController(fileURL: fileURL, coverImg: UIImage(cgImage: cgImg))
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        exportSession?.exportAsynchronously()
    }
}


// MARK: - ============= UIViewControllerTransitioningDelegate =============
extension DVideoEditViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentation = PresentationManager(presentedViewController: presented, presenting: presenting)
        if presented.isKind(of: DVideoClipViewController.self) {
            if #available(iOS 11, *) {
                presentation.layoutHeight = 170 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            } else {
                presentation.layoutHeight = 170
            }
        } else if presented.isKind(of: DVideoVolumeViewController.self) {
            if #available(iOS 11, *) {
                presentation.layoutHeight = 170 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            } else {
                presentation.layoutHeight = 170
            }
        } else if presented.isKind(of: DVideoFiltersViewController.self) {
            if #available(iOS 11, *) {
                presentation.layoutHeight = 170 + (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
            } else {
                presentation.layoutHeight = 170
            }
        }
        return presentation
    }
}


// MARK: - ============= UICollectionViewDataSource, UICollectionViewDelegate =============
extension DVideoEditViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData.filterImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoEditFilterCell.className(), for: indexPath) as! VideoEditFilterCell
        
        if let filterString = filterData.filterNames[exist: indexPath.row] {
            cell.setup(string: filterString)
        }
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = Int(targetContentOffset.pointee.x/UIScreenWidth)
        
        collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
        
        if let imgPath = filterData.filterImgs[exist: index] {
            editor.addFilter(imgPath)
        }
    }
}


extension DVideoEditViewController: UIGestureRecognizerDelegate {
    
}
