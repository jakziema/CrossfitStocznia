//
//  Training.swift
//  CrossfitStocznia
//
//  Created by Jakub on 18.05.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import Foundation

class Training {
    
    var title: String = ""
    var titleWithName: String = ""
    var coachName: String = ""
    var date: String = ""
    var dateID: String = ""
    var hour : String = ""
    var placesLeft: Int = 0
    var bgColor: String = ""
    var nameOfTheWeek: String = ""
    var id = ""
    var dateAsDateType: Date = Date()
    var booked: Bool = false
    var orders = [Order]()
    var cancelledOrders = [Order]()
    
    
    
}
