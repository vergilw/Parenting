//
//  PresentationManager.swift
//  parenting
//
//  Created by Vergil.Wang on 2019/1/10.
//  Copyright © 2019 zheng-chain. All rights reserved.
//

import UIKit

class PresentationManager: UIPresentationController {

    lazy var layoutHeight: CGFloat = 440
    
    var dismissHandler: (()->Void)?
    
    lazy fileprivate var dismissBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0, alpha: 0.3)
        button.alpha = 0.0
        button.addTarget(self, action: #selector(dismissBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var panGesture: UIPanGestureRecognizer = {
        let view = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(sender:)))
        
        return view
    }()
    
    lazy fileprivate var presentedFrame: CGRect = .zero
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return CGRect(origin: CGPoint(x: 0, y: UIScreenHeight-layoutHeight), size: CGSize(width: UIScreenWidth, height: layoutHeight))
    }
    
    override func presentationTransitionWillBegin() {
        containerView?.addSubview(dismissBtn)
        dismissBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25) {
            self.dismissBtn.alpha = 1.0
        }
        
        containerView?.addGestureRecognizer(panGesture)
    }
    
    override func dismissalTransitionWillBegin() {
        UIView.animate(withDuration: 0.25, animations: {
            self.dismissBtn.alpha = 0.0
        }) { (bool) in
            self.dismissBtn.removeFromSuperview()
        }
        
        containerView?.removeGestureRecognizer(panGesture)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if let closure = dismissHandler, completed == true {
            closure()
        }
    }
    
    @objc func dismissBtnAction() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    
    @objc func panGestureAction(sender: UIPanGestureRecognizer) {
        
        if sender.state == .began {
            presentedFrame = presentedViewController.view.frame
        } else if sender.state == .changed {
            let amount = sender.translation(in: presentedViewController.view)
            guard amount.y > 0 else {
                presentedViewController.view.center = CGPoint(x: presentedFrame.midX, y: presentedFrame.midY)
                return
            }
            presentedViewController.view.center = CGPoint(x: presentedFrame.midX, y: presentedFrame.midY + amount.y)
        } else if sender.state == .ended {
            let amount = sender.translation(in: presentedViewController.view)
            if amount.y > 100/*frameOfPresentedViewInContainerView.height/2*/ {
                presentingViewController.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.25,
                               animations: {
                                self.presentedViewController.view.frame = self.presentedFrame
                }, completion: nil)
            }
        }
        
    }
}
