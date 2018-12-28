//
//  DetailsNotDataCell.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/28.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import UIKit

class DetailsNotDataCell: UITableViewCell {

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
        
        let HUD = ResultView()
        HUD.titleLabel.setParagraphText("还没有金币明细哟")
        HUD.solutionBtn.removeFromSuperview()
        HUD.mode = .noData
        contentView.addSubview(HUD)
        
        HUD.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
