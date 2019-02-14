//
//  VideoUserCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class VideoUserCell: UICollectionViewCell {
    
    var deleteHandler: ((Int, ActionButton)->Void)?
    
    var model: VideoModel?
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    fileprivate lazy var shadowLayerView: UIView = {
        let view = UIView()
        return view
    }()
    
    fileprivate lazy var deleteBtn: ActionButton = {
        let button = ActionButton()
        button.setImage(UIImage(named: "video_videoDelete"), for: .normal)
        button.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var viewsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var viewsImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "video_viewsIcon")
        return imgView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor("#353535")
        contentView.addSubviews([previewImgView, shadowLayerView, deleteBtn, viewsCountLabel, viewsImgView])
        
        initShadowLayer()
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initShadowLayer() {
        let gradientLayer: CAGradientLayer = {
            let layer = CAGradientLayer()
            layer.colors = [UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.2).cgColor, UIColor(white: 0, alpha: 0.4).cgColor]
            layer.locations = [0.3, 0.6, 1.0]
            layer.startPoint = CGPoint.init(x: 0.0, y: 0.0)
            layer.endPoint = CGPoint.init(x: 0.0, y: 1.0)
            return layer
        }()
        
        shadowLayerView.layer.addSublayer(gradientLayer)
        
        let width = (UIScreenWidth-2)/3.0
        let height = width/9.0*16
        gradientLayer.frame = CGRect(x: 0, y: height - 200, width: width, height: 200)
    }
    
    fileprivate func initConstraints() {
        previewImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        shadowLayerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let imgSize = deleteBtn.imageView?.image?.size {
            deleteBtn.snp.makeConstraints { make in
                make.trailing.top.equalToSuperview()
                make.size.equalTo(CGSize(width: imgSize.width+20, height: imgSize.height+20))
            }
        }
        
        viewsImgView.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.bottom.equalTo(-10)
        }
        viewsCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(viewsImgView)
            make.leading.equalTo(viewsImgView.snp.trailing).offset(4)
        }
        
    }
    
    func setup(model: VideoModel, hideDelete: Bool) {
        self.model = model
        
        if let URLString = model.cover_url {
            //            let width = (UIScreenWidth-1)/2.0
            //            let processor = RoundCornerImageProcessor(cornerRadius: 0, targetSize: CGSize(width: width*2, height: width/9.0*16*2))
            previewImgView.kf.setImage(with: URL(string: URLString))
        }
        
        deleteBtn.isHidden = hideDelete
        
        
        viewsCountLabel.text = "\(model.view_count?.simplifiedNumber() ?? "0")"
        
    }
    
    @objc func deleteBtnAction() {
        if let closure = deleteHandler, let string = model?.id, let videoID = Int(string) {
            
            let alertController = UIAlertController(title: nil, message: "确定删除吗？", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertAction.Style.default, handler: { (action) in
                closure(videoID, self.deleteBtn)
            }))
            self.viewController?.present(alertController, animated: true, completion: nil)
            
        }
    }
}

