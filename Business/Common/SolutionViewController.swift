//
//  SolutionViewController.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/26.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class SolutionViewController: BaseViewController {

    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        if #available(iOS 11, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        return scrollView
    }()
    
    lazy fileprivate var title1Label: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.setParagraphText("1. 请检查网络权限是否打开")
        return label
    }()
    
    lazy fileprivate var paragraph1Label: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
//        label.setParagraphText("a. 因iOS系统原因，首次使用APP时需要打开网络权限。\nb. 如果你第一次打开氧育APP，弹出下图所示对话框，请点击\"允许\"")
        setParagraphText(label: label, text: "a. 因iOS系统原因，首次使用APP时需要打开网络权限。\nb. 如果你第一次打开氧育APP，弹出下图所示对话框，请点击\"允许\"")
        return label
    }()
    
    lazy fileprivate var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_grantView")
        return imgView
    }()
    
    lazy fileprivate var paragraph2Label: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        label.setParagraphText("c. 如果您未遇到上述对话框，或者选择了不允许：")
        return label
    }()
    
    lazy fileprivate var subparagraph1Label: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-16
        setParagraphText(label: label, text: "i. 打开【设置】-往下滑动找到【氧育】-点击进入-点击进入【无线数据】-勾选【WLAN与蜂窝移动网】\nii. 打开【设置】-往下滑动找到【氧育】-点击进入-选择【蜂窝移动数据】按钮变绿即可\niii. 打开【设置】-【蜂窝移动网络】-找到【氧育】-【使用无线局域网与蜂窝移动的应用】-勾选【无线局域网与蜂窝移动数据】即可\niv. 如果您未能根据上述三条解决问题，请重启手机，打开氧育APP后，再次进入【设置】重复上述操作")
        return label
    }()
    
    lazy fileprivate var title2Label: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.setParagraphText("2. 请检查手机的网络情况")
        return label
    }()
    
    lazy fileprivate var paragraph3Label: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.body
        label.textColor = UIConstants.Color.body
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing
        label.setParagraphText("请查看您本地的无线网络WiFi是否连接，或手机信号、移动网络是否开启，信号太差时也可能导致网络异常。")
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "解决方案"
        
        initContentView()
        initConstraints()
        addNotificationObservers()
    }
    
    // MARK: - ============= Initialize View =============
    fileprivate func initContentView() {
        view.addSubview(scrollView)
        scrollView.addSubviews([title1Label, paragraph1Label, imgView, paragraph2Label, subparagraph1Label, title2Label, paragraph3Label])
    }
    
    // MARK: - ============= Constraints =============
    fileprivate func initConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        title1Label.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(25)
        }
        paragraph1Label.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(title1Label.snp.bottom).offset(10)
            make.width.equalTo(UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing)
        }
        imgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(paragraph1Label.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 255, height: 276.5))
        }
        paragraph2Label.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(imgView.snp.bottom).offset(10+12)
        }
        subparagraph1Label.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+16)
            make.trailing.lessThanOrEqualTo(-16)
            make.top.equalTo(paragraph2Label.snp.bottom).offset(10)
        }
        title2Label.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(subparagraph1Label.snp.bottom).offset(32)
        }
        paragraph3Label.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(title2Label.snp.bottom).offset(10)
            if #available(iOS 11, *) {
                make.bottom.equalTo(-25-(UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
            } else {
                make.bottom.equalTo(-25)
            }
        }
    }
    
    // MARK: - ============= Notification =============
    fileprivate func addNotificationObservers() {
        
    }
    
    // MARK: - ============= Request =============
    
    // MARK: - ============= Reload =============
    @objc func reload() {
        
    }
    
    func setParagraphText(label: UILabel, text: String) {
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraph = NSMutableParagraphStyle()
        
        let lineHeight: CGFloat = UIConstants.ParagraphLineHeight.body
        paragraph.maximumLineHeight = lineHeight
        paragraph.minimumLineHeight = lineHeight
        paragraph.paragraphSpacing = 12
        
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.baselineOffset: (lineHeight-label.font.lineHeight)/4+1.25, NSAttributedString.Key.font: label.font], range: NSRange(location: 0, length: attributedString.length))
        label.attributedText = attributedString
    }
    
    // MARK: - ============= Action =============

}
