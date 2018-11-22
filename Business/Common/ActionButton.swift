//
//  ActionButton.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class ActionButton: UIButton {

    lazy fileprivate var activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.white)
        return view
    }()
    
    lazy fileprivate var hiddenTitle: String? = nil

    lazy fileprivate var hiddenImgView: UIImage? = nil
    
    init() {
        super.init(frame: .zero)
        
        addSubview(activityView)
        activityView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setIndicatorStyle(style: UIActivityIndicatorView.Style) {
        activityView.style = style
    }
    
    func startAnimating() {
        isUserInteractionEnabled = false
        
        hiddenTitle = titleLabel?.text
        hiddenImgView = imageView?.image
        setTitle(nil, for: .normal)
        setImage(nil, for: .normal)
        
        activityView.startAnimating()
    }
    
    func stopAnimating() {
        isUserInteractionEnabled = true
        
        activityView.stopAnimating()
        
        setTitle(hiddenTitle, for: .normal)
        setImage(hiddenImgView, for: .normal)
    }
}
