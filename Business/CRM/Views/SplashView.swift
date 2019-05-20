//
//  SplashView.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/5/20.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class SplashView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initContentView()
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        backgroundColor = .white
        
        let bgImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "crm_splashBg")
            imgView.contentMode = .scaleAspectFill
            return imgView
        }()
        
        let sloganImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "crm_splashSlogan")
            return imgView
        }()
        
        let logoImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "crm_splashLogo")
            return imgView
        }()
        
        addSubviews([bgImgView, sloganImgView, logoImgView])
        bgImgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(UIScreenWidth/750*1448)
        }
        sloganImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(224)
        }
        logoImgView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-42)
        }
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        
    }

}
