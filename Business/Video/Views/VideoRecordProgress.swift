//
//  VideoRecordProgress.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/14.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class VideoRecordProgress: UIView {

    fileprivate var fragmentViews = [UIView]()


    init() {
        super.init(frame: .zero)
        
        backgroundColor = UIColor(white: 1, alpha: 0.2)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func addFragment() {
        var originX: CGFloat = 0
        if let fragmentView = fragmentViews.last {
            originX = fragmentView.frame.minX
        }
        
        let fragmentView: UIView = {
            let view = UIView(frame: CGRect(origin: CGPoint(x: originX, y: 0), size: CGSize(width: 0, height: bounds.height)))
            view.backgroundColor = UIColor("#00A7A9")
            return view
        }()
        addSubview(fragmentView)
        fragmentViews.append(fragmentView)
    }
    
    func setLastWidth(width: CGFloat) {
        if let fragmentView = fragmentViews.last {
            fragmentView.frame = CGRect(origin: fragmentView.frame.origin, size: CGSize(width: width, height: fragmentView.frame.height))
        }
    }
}
