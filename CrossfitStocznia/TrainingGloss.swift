//
//  TrainingGloss.swift
//  CrossfitStocznia
//
//  Created by Jakub Ziemann on 15.05.2017.
//  Copyright © 2017 Jakub. All rights reserved.
//

import Foundation
import Gloss

class TrainingGloss: Decodable {
    
    let id: String?
    let date: String?
    let hour: String?
    let date_id: String?
    let intervals: Int?
    let css_class: String?
    let places: Int?
    let places_text: String?
    let title: String?
    let bg: String?
    let color: String?
    let orders : [OrderGloss]?
    let orders_2: [OrderGloss]?
    let orders_5: [OrderGloss]?
    
    required init?(json: JSON) {
        self.id = "id" <~~ json
        self.date = "date" <~~ json
        self.hour = "hour" <~~ json
        self.date_id = "date_id" <~~ json
        self.intervals = "intervals" <~~ json
        self.css_class = "css_class" <~~ json
        self.places = "places" <~~ json
        self.places_text = "places_text" <~~ json
        self.title = "title" <~~ json
        self.bg = "bg" <~~ json
        self.color = "color" <~~ json
        self.orders = "orders" <~~ json
        self.orders_2 = "orders_2" <~~ json
        self.orders_5 = "orders_5" <~~ json
        
    }
    
    
}
