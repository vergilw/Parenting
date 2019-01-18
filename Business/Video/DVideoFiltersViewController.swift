//
//  DVideoFiltersViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/17.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import PLShortVideoKit

class DVideoFiltersViewController: BaseViewController {
    
    var editHandler: ((Int)->Void)?
    
    lazy fileprivate var filterData: VideoFilter = VideoFilter()
    
    lazy fileprivate var selectedIndex: Int = 0
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Semibold", size: 15)!
        label.textColor = .white
        label.text = "选择滤镜"
        return label
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 55, height: 55+10+14)
        layout.sectionInset = UIEdgeInsets(top: 0, left: UIConstants.Margin.leading, bottom: 0, right: UIConstants.Margin.trailing)
        layout.minimumLineSpacing = 22
        layout.minimumInteritemSpacing = 22
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(VideoFilterCell.self, forCellWithReuseIdentifier: VideoFilterCell.className())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    init(selectedIndex: Int) {
//        self.asset = asset
//
//        let generator = AVAssetImageGenerator(asset: asset)
//        generator.maximumSize = CGSize(width: 110, height: 110)
//        generator.appliesPreferredTrackTransform = true
//        if let img = try? generator.copyCGImage(at: CMTime(seconds: 0, preferredTimescale: CMTimeScale(exactly: 600)!), actualTime: nil) {
//            coverImg = UIImage(cgImage: img)
//        } else {
//            coverImg = UIImage()
//        }

        super.init(nibName: nil, bundle: nil)

        self.selectedIndex = selectedIndex
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initContentView()
        initConstraints()
        addNotificationObservers()
        
        if collectionView.numberOfItems(inSection: 0) > selectedIndex {
            collectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: false, scrollPosition: UICollectionView.ScrollPosition())
        }
        
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.backgroundColor = .clear
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let effectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(effectView)
        effectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubviews([titleLabel, collectionView])
        
        view.drawSeparator(startPoint: CGPoint(x: 0, y: 56), endPoint: CGPoint(x: UIScreenWidth, y: 56))
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(56)
        }
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(74)
            make.height.equalTo(55+10+14)
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

}


// MARK: - ============= UICollectionViewDataSource, UICollectionViewDelegate =============
extension DVideoFiltersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterData.filterPreviewImgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoFilterCell.className(), for: indexPath) as! VideoFilterCell
        
        if let imgString = filterData.filterPreviewImgs[exist: indexPath.row], let img = UIImage(contentsOfFile: imgString), let filterString = filterData.filterNames[exist: indexPath.row] {
            cell.setup(img: img, string: filterString)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let closure = editHandler {
            closure(indexPath.row)
        }
        collectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
    }
    
}


struct VideoFilter {
    
    lazy var filterNames = [String]()
    
    lazy var filterPreviewImgs = [String]()
    
    lazy var filterImgs = [String]()
    
    init() {
        setupData()
        
        //FIXME: generate filter preview programmed
        //        generateFilterPreviews()
    }
    
    fileprivate mutating func setupData() {
        let filePath = Bundle.main.url(forResource: "plsfilters", withExtension: "json")!
        guard let data = try? Data(contentsOf: filePath) else {
            return
        }
        guard let JSON = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())) as? [AnyHashable: Any] else {
            return
        }
        
        if let filters = JSON["filters"] as? [[String: String]] {
            
            let bundlePath = Bundle.main.bundlePath.appending("/PLShortVideoKit.bundle")
            
            for obj in filters {
                if let name = obj["name"] {
                    filterNames.append(name)
                }
                if let name = obj["dir"] {
                    let imgPath = bundlePath.appending("/\(name).png")
                    filterPreviewImgs.append(imgPath)
                }
                if let name = obj["dir"] {
                    let imgPath = bundlePath.appending("/colorFilter/\(name)").appending("/filter.png")
                    filterImgs.append(imgPath)
                }
            }
        }
    }
    
    fileprivate mutating func generateFilterPreviews() {
        
        let documentURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask).first!
        
        for i in 0..<filterImgs.count {
            guard let filterImg = filterImgs[exist: i] else { continue }
            let paths = URL(fileURLWithPath: filterImg).pathComponents
            let filterName = paths[paths.count-2]
            
            let result: UIImage = PLSFilter.apply(UIImage(named: "video_filterOriginImg"), colorImagePath: filterImg)!
            let filePath = documentURL.appendingPathComponent("\(filterName).png")
            let data: Data = result.pngData()!
            try? data.write(to: filePath)
        }
        
        print(documentURL)
    }
}
