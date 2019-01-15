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
            originX = fragmentView.frame.maxX
        }
        
        let fragmentView: UIView = {
            let view = UIView(frame: CGRect(origin: CGPoint(x: originX, y: 0), size: CGSize(width: 0, height: bounds.height)))
            view.backgroundColor = UIColor("#00A7A9")
            return view
        }()
        addSubview(fragmentView)
        fragmentViews.append(fragmentView)
    }
    
    func updateLastFragmentWidth(width: CGFloat) {
        if let fragmentView = fragmentViews.last {
            fragmentView.frame = CGRect(origin: fragmentView.frame.origin, size: CGSize(width: width, height: fragmentView.frame.height))
        }
    }
    
    func addSegmentationIndicator() {
        if let fragmentView = fragmentViews.last {
            let indicatorView: UIView = {
                let view = UIView(frame: CGRect(origin: CGPoint(x: fragmentView.bounds.maxX-1.5, y: 0), size: CGSize(width: 1.5, height: bounds.height)))
                view.backgroundColor = .white
                return view
            }()
            fragmentView.addSubview(indicatorView)
        }
    }
    
    func deleteLastFragment() {
        if let fragment = fragmentViews.last {
            fragment.removeFromSuperview()
            fragmentViews.removeLast()
        }
    }
    
    func deleteAllFragment() {
        for fragment in fragmentViews {
            fragment.removeFromSuperview()
            fragmentViews.remove(at: fragmentViews.firstIndex(of: fragment)!)
        }
    }
}
