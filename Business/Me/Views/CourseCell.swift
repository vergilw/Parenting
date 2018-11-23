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
    }
    
    lazy fileprivate var displayMode: CellDisplayMode = .default
    
    var actionBlock: (()->())?
    
    lazy fileprivate var panelView: UIView = {
        let view = UIView()
        view.drawRoundBg(roundedRect: CGRect(origin: .zero, size: CGSize(width: UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-10, height: 132)), cornerRadius: 4)
        return view
    }()
    
    lazy fileprivate var shadowImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "me_coursePreviewShadow")
        return imgView
    }()
    
    lazy fileprivate var previewImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
//        imgView.clipsToBounds = true
        let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: 160*2, height: 90*2))
        imgView.kf.setImage(with: URL(string: "http://cloud.1314-edu.com/yVstTMQcm6uYCt5an9HpPxgJ"), options: [.processor(processor)])
        
        return imgView
    }()
    
    lazy fileprivate var avatarImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    
    lazy fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIConstants.Font.foot
        label.textColor = UIConstants.Color.foot
        label.text = "Gcide丨全职妈妈"
        return label
    }()
    
    lazy fileprivate var titleLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIConstants.Color.head
        label.numberOfLines = 2
        label.preferredMaxLayoutWidth = UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-160-24
        label.setParagraphText("如何规划幼儿英引引导成长的历...")
        
        return label
    }()
    
    lazy fileprivate var priceLabel: ParagraphLabel = {
        let label = ParagraphLabel()
        label.font = UIConstants.Font.h2
        label.textColor = UIColor("#ef5226")
        label.text = "¥0.0"
        return label
    }()
    
    lazy fileprivate var actionBtn: ActionButton = {
        let button = ActionButton()
        button.setIndicatorStyle(style: UIActivityIndicatorView.Style.gray)
        button.setImage(UIImage(named: "course_favoriteSelected")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.isHidden = true
        button.addTarget(self, action: #selector(actionBtnAction), for: .touchUpInside)
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
        contentView.backgroundColor = UIConstants.Color.background
        
        contentView.addSubview(panelView)
        panelView.addSubviews([shadowImgView, previewImgView, avatarImgView, nameLabel, titleLabel, priceLabel, actionBtn])
        
        panelView.snp.makeConstraints { make in
            make.leading.equalTo(UIConstants.Margin.leading+10)
            make.trailing.equalTo(-UIConstants.Margin.trailing)
            make.top.equalTo(20)
            make.bottom.equalTo(-20)
        }
        shadowImgView.snp.makeConstraints { make in
            make.centerX.equalTo(previewImgView)
            make.top.equalTo(previewImgView.snp.top).offset(-3.5)
        }
        previewImgView.snp.makeConstraints { make in
            make.leading.equalTo(-10)
            make.top.equalTo(-10)
            make.width.equalTo(160)
            make.height.equalTo(90)
        }
        avatarImgView.snp.makeConstraints { make in
            make.leading.equalTo(16)
            make.top.equalTo(previewImgView.snp.bottom).offset(12)
            make.size.equalTo(CGSize(width: 22, height: 22))
        }
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImgView.snp.trailing).offset(4)
            make.centerY.equalTo(avatarImgView)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(previewImgView.snp.trailing).offset(12)
            make.trailing.equalTo(-12)
            make.top.equalTo(12)
        }
        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(-12)
            make.centerY.equalTo(avatarImgView)
        }
        actionBtn.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.size.equalTo(CGSize(width: 52, height: 62))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup(mode: CellDisplayMode, model: CourseModel? = nil) {
        if mode != displayMode {
            if mode == .default {
                actionBtn.isHidden = true
                
                priceLabel.snp.remakeConstraints { make in
                    make.trailing.equalTo(-12)
                    make.centerY.equalTo(avatarImgView)
                }
                
            } else if mode == .favirotes {
                actionBtn.isHidden = false
                
                priceLabel.snp.remakeConstraints { make in
                    make.leading.equalTo(previewImgView.snp.trailing).offset(12)
                    make.centerY.equalTo(avatarImgView)
                }
            } else if mode == .owned {
                actionBtn.isHidden = true
                
                priceLabel.snp.remakeConstraints { make in
                    make.trailing.equalTo(-12)
                    make.centerY.equalTo(avatarImgView)
                }
            }
            displayMode = mode
        }
        
        
        if mode == .default {
            priceLabel.textColor = UIColor("#ef5226")
            priceLabel.font = UIConstants.Font.h2
            if let price = model?.price {
                priceLabel.setPriceText("¥"+String(price), symbolFont: UIConstants.Font.body)
            }
            
            if let URLString = model?.cover_attribute?.service_url {
                let width = (UIScreenWidth-UIConstants.Margin.leading-UIConstants.Margin.trailing-12)/2
                let processor = RoundCornerImageProcessor(cornerRadius: 8, targetSize: CGSize(width: width*2, height: width/16.0*9*2))
                previewImgView.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
            }
            
            if let URLString = model?.teacher?.headshot_attribute?.service_url {
                let processor = RoundCornerImageProcessor(cornerRadius: 22, targetSize: CGSize(width: 44, height: 44))
                avatarImgView.kf.setImage(with: URL(string: URLString), options: [.processor(processor)])
            }
            
            titleLabel.setParagraphText(model?.title ?? "", isMultiline: true)
            
            nameLabel.text = model?.teacher?.name ?? ""
            if let tags = model?.teacher?.tags, tags.count > 0 {
                let tagString = tags.joined(separator: " | ")
                nameLabel.text = nameLabel.text?.appendingFormat(" : %@", tagString)
            }
            
        } else if mode == .favirotes {
            priceLabel.textColor = UIColor("#ef5226")
            priceLabel.font = UIConstants.Font.h2
            priceLabel.setPriceText("¥39.8", symbolFont: UIConstants.Font.body)
            
        } else if mode == .owned {
            priceLabel.textColor = UIConstants.Color.primaryGreen
            priceLabel.font = UIConstants.Font.body
            priceLabel.text = "开始学习"
        }
        
    }
    
    @objc func actionBtnAction() {
        actionBtn.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
            
            self.actionBtn.stopAnimating()
            self.actionBtn.setImage(UIImage(named: "course_favoriteNormal")?.withRenderingMode(.alwaysOriginal), for: .normal)
            HUDService.sharedInstance.show(string: "成功取消收藏")
        }
    }
}
