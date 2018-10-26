//
//  CourseEvaluationCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/10/26.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class CourseEvaluationCell: UITableViewCell {

    lazy fileprivate var teacherAvatarImgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 35, height: 35)))
        imgView.contentMode = .scaleToFill
        imgView.image = UIImage(named: "public_avatarPlaceholder")
        imgView.layer.cornerRadius = 15
        imgView.clipsToBounds = true
        return imgView
    }()
    
    lazy fileprivate var subProfileView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var teacherNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIColor("#101010")
        return label
    }()
    
    lazy var teacherTagLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor("#777")
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
