//
//  TopUpItemCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class TopUpItemCell: UICollectionViewCell {
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.primaryGreen
        label.text = "0"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        layer.cornerRadius = 5
        layer.borderColor = UIConstants.Color.primaryGreen.cgColor
        layer.borderWidth = 0.5
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(model: AdvanceModel) {
        titleLabel.text = model.name
    }
}

/*
 lazy fileprivate var stackView: UIStackView = {
 let view = UIStackView()
 view.alignment = .center
 view.axis = .vertical
 view.distribution = .fillProportionally
 return view
 }()
 
 lazy fileprivate var costLabel: UILabel = {
 let label = UILabel()
 label.font = UIConstants.Font.h2
 label.textColor = UIConstants.Color.head
 label.text = "0"
 return label
 }()
 
 lazy fileprivate var gainLabel: UILabel = {
 let label = UILabel()
 label.font = UIConstants.Font.h2
 label.textColor = UIConstants.Color.primaryGreen
 label.text = "0"
 return label
 }()
 
 override init(frame: CGRect) {
 super.init(frame: .zero)
 
 layer.cornerRadius = 5
 layer.borderColor = UIConstants.Color.primaryGreen.cgColor
 layer.borderWidth = 0.5
 
 contentView.addSubview(stackView)
 stackView.addArrangedSubview(costLabel)
 stackView.addArrangedSubview(gainLabel)
 
 stackView.snp.makeConstraints { make in
 make.center.equalToSuperview()
 }
 
 costLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
 gainLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
 }
 
 required init?(coder aDecoder: NSCoder) {
 fatalError()
 }
 
 func setup(model: AdvanceModel) {
 costLabel.text = model.final_price
 gainLabel.text = model.wallet_amount
 }
 */
