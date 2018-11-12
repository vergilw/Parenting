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
        HUD.titleLabel.text = "两次输入密码不一致两次输入密码不一致两次输入密码不"
        UIApplication.shared.keyWindow?.addSubview(HUD)
        HUD.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.equalTo(50)
            make.trailing.lessThanOrEqualTo(-50)
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            HUD.removeFromSuperview()
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
            make.leading.equalTo(26)
            make.trailing.lessThanOrEqualTo(-26)
            make.top.equalTo(14)
            make.bottom.lessThanOrEqualTo(-14)
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
