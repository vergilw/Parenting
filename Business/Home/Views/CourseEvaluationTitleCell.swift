//
//  CourseEvaluationTitleCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/26.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseEvaluationTitleCell: UITableViewCell {

    public var evaluationBlock: ((ActionButton)->())?
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.text = "留言"
        return label
    }()
    
    lazy fileprivate var actionBtn: ActionButton = {
        let button = ActionButton()
        button.setTitleColor(UIConstants.Color.primaryGreen, for: .normal)
        button.titleLabel?.font = UIConstants.Font.body
        button.setTitle("我要评价", for: .normal)
        button.addTarget(self, action: #selector(evaluationBtnAction), for: .touchUpInside)
        return button
    }()
    
    lazy fileprivate var animationActionBtn: UIButton = {
        let button = UIButton()
        
        let img = YYImage(named: "course_commentRewardAnimation")!
        let imgView = YYAnimatedImageView(image: img)
        button.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 77.5, height: 20))
        }
        
        button.addTarget(self, action: #selector(evaluationBtnAction), for: .touchUpInside)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.layoutMargins = UIEdgeInsets(top: 16, left: 25, bottom: 16, right: 25)
        
        contentView.addSubviews([titleLabel, actionBtn, animationActionBtn])
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(25)
            make.top.equalTo(32)
            make.bottom.equalTo(-32)
        }
        actionBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.width.equalTo(60+contentView.layoutMargins.right*2)
            make.height.equalTo(44)
        }
        animationActionBtn.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.width.equalTo(77.5+contentView.layoutMargins.right*2)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(isEvaluate: Bool, isAnimation: Bool = false) {
        
        if isEvaluate {
            actionBtn.isHidden = false
            animationActionBtn.isHidden = true
            actionBtn.setTitle("我的评价", for: .normal)
        } else {
            if isAnimation {
                actionBtn.isHidden = true
                animationActionBtn.isHidden = false
            } else {
                actionBtn.isHidden = false
                animationActionBtn.isHidden = true
                actionBtn.setTitle("我要评价", for: .normal)
            }
        }
    }
    
    @objc func evaluationBtnAction() {
        if let block = evaluationBlock {
            block(actionBtn)
        }
    }
}
