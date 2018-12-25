//
//  RewardRankingModel.swift
//  parenting
//
//  Created by Vergil.Wang on 2018/12/25.
//  Copyright © 2018 zheng-chain. All rights reserved.
//

import HandyJSON

class RewardRankingModel: HandyJSON {
    
    var id: Int?
    var income_amount: String?
    var user: UserModel?
    
    required init() { }
    
}
