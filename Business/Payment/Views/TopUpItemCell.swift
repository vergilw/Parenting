//
//  TopUpItemCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/14.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class TopUpItemCell: UICollectionViewCell {
    
    lazy fileprivate var stackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .center
        view.axis = .vertical
        view.distribution = .fillProportionally
        view.spacing = 5
        return view
    }()
    
    lazy fileprivate var gainLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.primaryGreen
        label.text = "0"
        return label
    }()
    
    lazy fileprivate var costLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
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
        stackView.addArrangedSubview(gainLabel)
        stackView.addArrangedSubview(costLabel)
        
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
        if let gain = model.wallet_amount {
            gainLabel.text = String.integerFormatter.string(from: NSNumber(string: gain) ?? 0)
        }
        
        if let cost = model.final_price {
            costLabel.text = (String.integerFormatter.string(from: NSNumber(string: cost) ?? 0) ?? "") + "元"
        }
        
    }
    
    func setupExchange(model: RewardExchangeModel) {
        if let gain = model.coin_amount {
            gainLabel.text = String.integerFormatter.string(from: NSNumber(string: gain) ?? 0)
        }
        
        if let cost = model.wallet_amount {
            costLabel.text = (String.integerFormatter.string(from: NSNumber(string: cost) ?? 0) ?? "") + "氧育币"
        }
        
    }
    
    func setupWithdraw(model: WithdrawModel) {
        if let gain = model.cash_amount {
            gainLabel.text = String.integerFormatter.string(from: NSNumber(string: gain) ?? 0)
        }
        
        if let cost = model.coin_amount {
            costLabel.text = "兑" + (String.integerFormatter.string(from: NSNumber(string: cost) ?? 0) ?? "") + "金币"
        }
        
    }
}

