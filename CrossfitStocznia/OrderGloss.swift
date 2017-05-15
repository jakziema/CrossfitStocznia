//
//  OrderGloss.swift
//  CrossfitStocznia
//
//  Created by Jakub Ziemann on 15.05.2017.
//  Copyright © 2017 Jakub. All rights reserved.
//

import Foundation
import Gloss

class OrderGloss: Decodable {
    
    let id: String?
    let user_id: String?
    let info: String?
    let status: String?
    let intervals: Int?
    
    
    required init?(json: JSON) {
        self.id = "id" <~~ json
        self.user_id = "user_id" <~~ json
        self.info = "info" <~~ json
        self.status  = "status" <~~ json
        self.intervals = "intervals" <~~ json
    }
}
