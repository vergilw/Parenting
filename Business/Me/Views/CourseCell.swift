//
//  CourseCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/11/15.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit
import Kingfisher

class CourseCell: UITableViewCell {

    enum CellDisplayMode {
        case `default`
        case favirotes
        case owned
        case reward
    }
    
    lazy fileprivate var displayMode: CellDisplayMode = .default
    
    fileprivate lazy var isEditable: Bool = false
    
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
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-CourseCell.previewImgWidth()-24
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
    
    fileprivate lazy var studyStatusLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot1
        label.textColor = UIConstants.Color.primaryGreen
        label.layer.borderColor = UIConstants.Color.primaryGreen.cgColor
        label.layer.borderWidth = 0.5
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()
    
    lazy fileprivate var rewardFootnoteView: UIView = {
        let contentview = UIView()
        contentview.isHidden = true
        
        let bgImgView: UIImageView = {
            let imgView = UIImageView()
            imgView.backgroundColor = UIConstants.Color.primaryOrange.withAlphaComponent(0.13)
            imgView.layer.cornerRadius = 10
            imgView.clipsToBounds = true
            return imgView
        }()
        
        contentview.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        
        let view = UIStackView()
        view.alignment = .center
        view.axis = .horizontal
        view.distribution = .fillProportionally
        view.spacing = 3
        
        let imgView: UIImageView = {
            let imgView = UIImageView()
            imgView.image = UIImage(named: "payment_coinIcon")
            return imgView
        }()
        
        let label: UILabel = {
            let label = UILabel()
            label.font = UIConstants.Font.foot1
            label.textColor = UIConstants.Color.primaryOrange
            label.text = "前往分享 "
            return label
        }()
        
        view.addArrangedSubview(imgView)
        view.addArrangedSubview(label)
        
        contentview.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        return contentview
    }()
    
    fileprivate lazy var deleteBtn: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "video_videoDelete")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIConstants.Color.primaryRed
        button.addTarget(self, action: #selector(deleteBtnAction), for: .touchUpInside)
        button.drawSeparator(startPoint: CGPoint(x: 0, y: 27), endPoint: CGPoint(x: 0, y: 87))
        return button
    }()
    
    var deleteClosure: (()->Void)?
    
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
        
        addSubview(deleteBtn)
        contentView.addSubviews([previewImgView, rewardMarkImgView, nameLabel, titleLabel, subtitleLabel, priceLabel, sectionCountLabel, studyStatusLabel, rewardFootnoteView])
        
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
            make.top.equalTo(previewImgView).offset(4)
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
            make.lastBaseline.equalTo(previewImgView.snp.bottom).offset(-1)
        }
        sectionCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.bottom.equalTo(previewImgView)
            make.height.equalTo(18)
        }
        studyStatusLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.bottom.equalTo(previewImgView)
            make.size.equalTo(CGSize(width: 70, height: 25))
        }
        rewardFootnoteView.snp.makeConstraints { make in
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.bottom.equalTo(previewImgView)
            make.height.equalTo(20)
            make.width.equalTo(77.5)
        }
        deleteBtn.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(contentView.snp.trailing)
            make.width.equalTo(60)
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
        
        self.isEditable = editing
        UIView.animate(withDuration: 0.25) {
            if self.isEditable {
                self.contentView.center.x = UIScreenWidth/2 - 60
            } else {
                self.contentView.center.x = UIScreenWidth/2
            }
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if isEditable {
            contentView.center.x = UIScreenWidth/2 - 60
        } else {
            contentView.center.x = UIScreenWidth/2
        }
        
    }
    
    func setup(mode: CellDisplayMode, model: CourseModel? = nil) {
        if mode != displayMode {
            if mode == .default {
                priceLabel.isHidden = false
                rewardFootnoteView.isHidden = true
                studyStatusLabel.isHidden = true
                
//                priceLabel.snp.remakeConstraints { make in
//                    make.trailing.equalTo(-12)
//                    make.centerY.equalTo(avatarImgView)
//                }
//                nameLabel.snp.remakeConstraints { make in
//                    make.leading.equalTo(avatarImgView.snp.trailing).offset(4)
//                    make.centerY.equalTo(avatarImgView)
//                    make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-12).priority(.high)
//                    make.trailing.lessThanOrEqualTo(previewImgView.snp.trailing).offset(0).priority(.required)
//                }
                
            } else if mode == .favirotes {
                priceLabel.isHidden = false
                rewardFootnoteView.isHidden = true
                studyStatusLabel.isHidden = true
                
//                priceLabel.snp.remakeConstraints { make in
//                    make.trailing.lessThanOrEqualTo(actionBtn.snp.leading).priority(.required)
//                    make.leading.equalTo(previewImgView.snp.trailing).offset(12).priority(.low)
//                    make.centerY.equalTo(avatarImgView)
//                }
//                nameLabel.snp.remakeConstraints { make in
//                    make.leading.equalTo(avatarImgView.snp.trailing).offset(4)
//                    make.centerY.equalTo(avatarImgView)
//                    make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-12).priority(.high)
//                    make.trailing.lessThanOrEqualTo(previewImgView.snp.trailing).offset(0).priority(.required)
//                }
                
            } else if mode == .owned {
                priceLabel.isHidden = false
                rewardFootnoteView.isHidden = true
                sectionCountLabel.isHidden = true
                studyStatusLabel.isHidden = false
                
//                priceLabel.snp.remakeConstraints { make in
//                    make.trailing.equalTo(-12)
//                    make.centerY.equalTo(avatarImgView)
//                }
//                nameLabel.snp.remakeConstraints { make in
//                    make.leading.equalTo(avatarImgView.snp.trailing).offset(4)
//                    make.centerY.equalTo(avatarImgView)
//                    make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-12).priority(.high)
//                    make.trailing.lessThanOrEqualTo(previewImgView.snp.trailing).offset(0).priority(.required)
//                }
            } else if mode == .reward {
                priceLabel.isHidden = false
                rewardFootnoteView.isHidden = false
                sectionCountLabel.isHidden = true
                studyStatusLabel.isHidden = true
                
            }
            displayMode = mode
        }
        
        
        if mode == .owned {
            if model?.is_finished_course == true {
                studyStatusLabel.text = "已学完"
                studyStatusLabel.textColor = UIConstants.Color.head
                studyStatusLabel.layer.borderColor = UIConstants.Color.separator.cgColor
            } else if model?.lastest_play_catalogue != nil {
                studyStatusLabel.text = "继续学习"
                studyStatusLabel.textColor = UIConstants.Color.primaryOrange
                studyStatusLabel.layer.borderColor = UIConstants.Color.primaryOrange.cgColor
            } else {
                studyStatusLabel.text = "开始学习"
                studyStatusLabel.textColor = UIConstants.Color.primaryGreen
                studyStatusLabel.layer.borderColor = UIConstants.Color.primaryGreen.cgColor
            }
        }
        
        
        if let price = model?.price {
            priceLabel.setPriceText(text: String(price), discount: model?.market_price)
        }
        
        if model?.rewardable == true {
            rewardMarkImgView.isHidden = false
        } else {
            rewardMarkImgView.isHidden = true
        }
    
        
        if let URLString = model?.cover_attribute?.service_url {
//            let imgHeight: CGFloat = 82
//            let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: imgHeight/9.0*16*2, height: imgHeight*2))
//            let resizeProcessor = ResizingImageProcessor(referenceSize: CGSize(width: imgHeight/9.0*12*2, height: imgHeight*2), mode: .aspectFill)
            previewImgView.kf.setImage(with: URL(string: URLString), placeholder: UIImage(named: "public_coursePlaceholder"), options: nil)
        }
        
        titleLabel.text = model?.title
        
        subtitleLabel.text = model?.subhead
        
        nameLabel.text = model?.teacher?.name ?? ""
        if let tags = model?.teacher?.tags, tags.count > 0 {
            let tagString = tags.joined(separator: " | ")
            nameLabel.text = nameLabel.text?.appendingFormat(" : %@", tagString)
        }
        
        if let count = model?.students_count {
            footnoteLabel.text = String(count).simplifiedNumber()
        }
        
        if let count = model?.course_catalogues_count {
            sectionCountLabel.text = "   \(count)课时   "
        }
    }
    
    fileprivate class func previewImgWidth() -> CGFloat {
        let titleWidth: CGFloat = UIScreenWidth - UIConstants.Margin.leading - UIConstants.Margin.trailing - 24 - 160
        let offset: CGFloat = (titleWidth + 1).truncatingRemainder(dividingBy: 17+1)
        let imgWidth: CGFloat = 160+offset-1
        return imgWidth
    }
    
    class func cellHeight() -> CGFloat {
        return 10 + 4.5 + previewImgWidth()/16.0*9 + 12 + 22 + 20 + 20
    }
    
    @objc fileprivate func deleteBtnAction() {
        if let closure = deleteClosure {
            closure()
        }
    }
}
