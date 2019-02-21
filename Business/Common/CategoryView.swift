//
//  CategoryView.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/21.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CategoryView: UIView {

    weak var delegate: CategoryDelegate?
    
    lazy fileprivate var titleScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    lazy fileprivate var contentScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.delegate = self
        
        return scrollView
    }()
    
    lazy fileprivate var titleStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .horizontal
        return view
    }()
    
    lazy fileprivate var contentStackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .horizontal
        return view
    }()
    
    lazy fileprivate var categoryIndicatorImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIConstants.Color.primaryGreen
        return imgView
    }()
    
    lazy fileprivate var buttons = [UIButton]()
    lazy fileprivate var childViews = [UIView]()
    lazy fileprivate var selectedIndex = 0

    /// Initializer
    ///
    /// - Parameters:
    ///   - distribution: only .fillEqually and .fillProportionally will work
    ///   - titles: button title
    ///   - width: total width
    init(distribution: UIStackView.Distribution, titles: [String], childViews: [UIView], titleHeight: CGFloat = 46, contentHeight: CGFloat) {
        
        let width = UIScreenWidth
        
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: width, height: titleHeight)))
        
        titleStackView.distribution = distribution
        contentStackView.distribution = distribution
        addSubviews([titleScrollView, contentScrollView])
        titleScrollView.addSubview(titleStackView)
        contentScrollView.addSubview(contentStackView)
        titleStackView.addSubview(categoryIndicatorImgView)
        
        titleScrollView.drawSeparator(startPoint: CGPoint(x: 0, y: 45.5), endPoint: CGPoint(x: UIScreenWidth, y: 45.5))
        
        var i = 0
        var contentWidth: CGFloat = 0
        
        for title in titles {
            let button: UIButton = {
                let button = UIButton()
                button.setTitleColor(UIConstants.Color.body, for: .normal)
                button.titleLabel?.font = UIConstants.Font.body
                if titles[exist: 0] == title {
                    button.setTitleColor(UIConstants.Color.head, for: .normal)
                    button.titleLabel?.font = UIConstants.Font.h2
                }
                button.setTitle(title, for: .normal)
                button.addTarget(self, action: #selector(categoryBtnAction(sender:)), for: .touchUpInside)
                return button
            }()
            titleStackView.addArrangedSubview(button)
            
            if distribution == .fillEqually {
                button.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
                button.widthAnchor.constraint(equalToConstant: width/CGFloat(titles.count)).isActive = true
            } else if distribution == .fillProportionally {
                button.heightAnchor.constraint(equalToConstant: titleHeight).isActive = true
                
                let size = NSString(string: button.titleLabel?.text ?? "").boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [NSStringDrawingOptions.usesFontLeading] , attributes: [NSAttributedString.Key.font : button.titleLabel!.font], context: nil).size
                button.widthAnchor.constraint(equalToConstant: size.width+32).isActive = true
                contentWidth += size.width+32
            }
            buttons.append(button)

            i += 1
        }
        
        for childView in childViews {
            contentStackView.addArrangedSubview(childView)
            childView.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
            childView.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        self.childViews = childViews
        
        initConstraints()
    }
    
    fileprivate override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func didMoveToWindow() {
        guard let viewController = viewController else { return }
        
        if let gesture = viewController.navigationController?.view.gestureRecognizers?.first(where: { (gesture) -> Bool in
            return gesture.isKind(of: UIScreenEdgePanGestureRecognizer.self)
            
        }) {
            contentScrollView.panGestureRecognizer.require(toFail: gesture)
        }
    }
    
    fileprivate func initConstraints() {
        titleScrollView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(46)
        }
        contentScrollView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(titleScrollView.snp.bottom)
        }
        titleStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        if let button = buttons[exist: 0] {
            categoryIndicatorImgView.snp.makeConstraints { make in
                make.centerX.equalTo(button)
                make.height.equalTo(1.5)
                make.width.equalTo(29)
                make.bottom.equalTo(titleStackView)
            }
        }
        
    }
    
    @objc func categoryBtnAction(sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        
        categoryIndicatorImgView.snp.remakeConstraints { make in
            make.centerX.equalTo(sender)
            make.width.equalTo(29)
            make.height.equalTo(1.5)
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.35, animations: {
            self.titleStackView.layoutIfNeeded()
        })
        
        recoverCategoryStyle()
        
        sender.setTitleColor(UIConstants.Color.head, for: .normal)
        sender.titleLabel?.font = UIConstants.Font.h2
        
        if let delegate = delegate, let contentView = childViews[exist: index] {
            delegate.contentView(contentView, didScrollRowAt: index)
        }
        contentScrollView.setContentOffset(CGPoint(x: bounds.size.width*CGFloat(index), y: 0), animated: true)
        
        selectedIndex = index
        
        if let previous = buttons[exist: selectedIndex-1]  {
            let frame = titleScrollView.convert(previous.frame, from: previous.superview)
            if frame.origin.x < 0 {
                titleScrollView.scrollRectToVisible(previous.frame, animated: true)
            }
            
        }
        if let next = buttons[exist: selectedIndex+1], next.frame.origin.x+next.frame.size.width > bounds.size.width {
            let frame = titleScrollView.convert(next.frame, from: next.superview)
            if frame.origin.x+frame.size.width > bounds.size.width {
                titleScrollView.scrollRectToVisible(next.frame, animated: true)
            }
        }
        
    }
    
    fileprivate func recoverCategoryStyle() {
        for button in buttons {
            button.titleLabel?.font = UIConstants.Font.body
            button.setTitleColor(UIConstants.Color.body, for: .normal)
        }
        
    }
}

extension CategoryView: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        guard bounds.size != .zero else { return }
        guard scrollView == contentScrollView else { return }
        
        let index = Int(targetContentOffset.pointee.x/bounds.size.width)
        if index != selectedIndex {
            guard let sender = buttons[exist: index] else { return }
            categoryIndicatorImgView.snp.remakeConstraints { make in
                make.centerX.equalTo(sender)
                make.width.equalTo(29)
                make.height.equalTo(1.5)
                make.bottom.equalToSuperview()
            }
            
            UIView.animate(withDuration: 0.35, animations: {
                self.titleStackView.layoutIfNeeded()
            })
            
            recoverCategoryStyle()
            
            sender.setTitleColor(UIConstants.Color.head, for: .normal)
            sender.titleLabel?.font = UIConstants.Font.h2
            
            if let delegate = delegate, let contentView = childViews[exist: index] {
                delegate.contentView(contentView, didScrollRowAt: index)
            }
            
            selectedIndex = index
            
            titleScrollView.scrollRectToVisible(sender.frame, animated: true)
        }
    }
}

protocol CategoryDelegate: class {
    
    func contentView(_ contentView: UIView, didScrollRowAt index: Int)
}
