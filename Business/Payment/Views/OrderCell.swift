//
//  OrderCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/16.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class OrderCell: UITableViewCell {

    lazy fileprivate var orderMode: DOrdersViewController.DOrdersMode = .nonpayment
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "public_coursePlaceholder")
        imgView.layer.cornerRadius = 4
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var rewardMarkImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_rewardMark")
        imgView.isHidden = true
        return imgView
    }()
    
    lazy fileprivate var footnoteLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot3
        label.textColor = .white
        return label
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        //        label.setContentHuggingPriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        //        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.horizontal)
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    lazy fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.h3
        label.textColor = UIConstants.Color.head
        return label
    }()
    
    fileprivate lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.caption1
        label.textColor = UIConstants.Color.body
        return label
    }()
    
    lazy fileprivate var priceLabel: PriceLabel = {
        let label = PriceLabel()
        label.setContentCompressionResistancePriority(UILayoutPriority.required, for: NSLayoutConstraint.Axis.horizontal)
        label.font = UIConstants.Font.h3
        label.textColor = UIColor("#ef5226")
        return label
    }()
    
    fileprivate lazy var sectionCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot3
        label.textColor = UIConstants.Color.body
        label.backgroundColor = UIConstants.Color.background
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        return label
    }()
    
    fileprivate lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor("#ecedef")
        view.layer.borderColor = UIColor("#ecedef").cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        return view
    }()
    
    fileprivate lazy var actionBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIConstants.Color.primaryOrange
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIConstants.Font.foot1
        button.setTitle("去支付", for: .normal)
        button.layer.cornerRadius = 12.5
        button.clipsToBounds = true
        button.isUserInteractionEnabled = false
        return button
    }()
    
    fileprivate lazy var timeImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "course_timeDuration")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    fileprivate lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot2
        label.textColor = UIConstants.Color.foot
        return label
    }()
    
    fileprivate lazy var orderNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "PingFangSC-Medium", size: 11)!
        label.textColor = UIConstants.Color.head
        return label
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
        
        contentView.addSubviews([previewImgView, rewardMarkImgView, nameLabel, titleLabel, subtitleLabel, priceLabel, sectionCountLabel, bottomView])
        bottomView.addSubviews([timeImgView, timeLabel, orderNumberLabel, actionBtn])
        
        initPreviewFooterView()
        
        initConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    fileprivate func initPreviewFooterView() {
        let stackView: UIStackView = {
            let view = UIStackView()
            view.alignment = .center
            view.axis = .horizontal
            view.distribution = .fillProportionally
            view.spacing = 3
            return view
        }()
        
        let bgImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)
            imgView.layer.cornerRadius = 7.5
            imgView.clipsToBounds = true
            return imgView
        }()
        
        let iconImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "course_usersCountMark")
            return imgView
        }()
        
        stackView.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: -8, bottom: 0, right: -8))
        }
        
        stackView.addArrangedSubview(iconImgView)
        stackView.addArrangedSubview(footnoteLabel)
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(previewImgView.snp.trailing).offset(-5-8)
            make.bottom.equalTo(previewImgView.snp.bottom).offset(-5)
            make.height.equalTo(15)
        }
    }
    
    fileprivate func initConstraints() {
        
        previewImgView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.top.equalTo(15)
            let imgHeight: CGFloat = 82
            make.width.equalTo(imgHeight/9.0*12)
            make.height.equalTo(imgHeight)
        }
        rewardMarkImgView.snp.makeConstraints { make in
            make.leading.equalTo(previewImgView)
            make.top.equalTo(previewImgView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(previewImgView.snp.trailing).offset(15)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(previewImgView).offset(4.5)
            make.height.equalTo(15)
        }
        subtitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(previewImgView.snp.trailing).offset(15)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.height.equalTo(15)
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(subtitleLabel.snp.bottom).offset(8)
            make.trailing.lessThanOrEqualTo(-UIConstants.Margin.trailing)
            make.height.equalTo(11)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.lastBaseline.equalTo(previewImgView.snp.bottom)
        }
        sectionCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.bottom.equalTo(previewImgView)
            make.height.equalTo(18)
        }
        
        bottomView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(previewImgView.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        timeImgView.snp.makeConstraints { make in
            make.leading.equalTo(10)
            make.centerY.equalToSuperview()
        }
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(timeImgView.snp.trailing).offset(5)
            make.centerY.equalToSuperview()
        }
        orderNumberLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-24)
            make.centerY.equalToSuperview()
        }
        actionBtn.snp.makeConstraints { make in
            make.trailing.equalTo(-5)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 75, height: 25))
        }
    }
    
    func setup(mode: DOrdersViewController.DOrdersMode, model: OrderModel) {
        if mode != orderMode {
            if mode == .nonpayment {
                actionBtn.isHidden = false
                orderNumberLabel.isHidden = true
                
            } else {
                actionBtn.isHidden = true
                orderNumberLabel.isHidden = false
            }
            orderMode = mode
        }
        
        titleLabel.text = model.order_items?[exist: 0]?.course?.title
        
        if let URLString = model.order_items?[exist: 0]?.course?.cover_attribute?.service_url {
            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: 160*2, height: 160/16.0*9*2))
            previewImgView.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
        }
        
        if let price = model.amount {
            priceLabel.setPriceText(text: price, discount: model.market_price)
        }
        
        subtitleLabel.text = model.order_items?[exist: 0]?.course?.subhead
        
        nameLabel.text = model.order_items?[exist: 0]?.course?.teacher?.name ?? ""
        if let tags = model.order_items?[exist: 0]?.course?.teacher?.tags, tags.count > 0 {
            let tagString = tags.joined(separator: " | ")
            nameLabel.text = nameLabel.text?.appendingFormat(" : %@", tagString)
        }
        
        if let count = model.order_items?[exist: 0]?.course?.students_count {
            footnoteLabel.text = String(count).simplifiedNumber()
        }
        
        if mode == .nonpayment {
            
        } else if mode == .payment {
            let orderString: String = "订单号：" + (model.uuid ?? "")
//            orderNumberLabel.setSymbolText(orderString, symbolText: "订单号：", symbolAttributes: [NSAttributedString.Key.foregroundColor : UIConstants.Color.body])
            
            let attributedString = NSMutableAttributedString(string: orderString)
            attributedString.addAttributes([NSAttributedString.Key.foregroundColor: UIConstants.Color.foot, NSAttributedString.Key.font: UIConstants.Font.foot2], range: NSString(string: orderString).range(of: "订单号："))
            orderNumberLabel.attributedText = attributedString
        }
        
        timeLabel.text = (model.created_at?.string(format: "yyyy.MM.dd HH:mm"))
    }
}
