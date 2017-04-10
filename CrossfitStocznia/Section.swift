//
//  Section.swift
//  CrossfitStocznia
//
//  Created by Jakub on 17.10.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import Foundation


class Section: NSObject {
    
    var sectionTitle: String
    var sectionDateAsType: Date
    var sectionTrainings: [Training] = []
    
    init(sectionTitle: String, sectionDateAsType: Date) {
        self.sectionTitle = sectionTitle
        self.sectionDateAsType = sectionDateAsType
    }
    
    func setSectionTrainings(sectionTrainings: [Training]) {
        self.sectionTrainings = sectionTrainings
        
    }
}
