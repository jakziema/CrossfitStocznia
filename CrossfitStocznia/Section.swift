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
  var sectionTrainings: [Training]
  
  init(sectionTitle: String, sectionTrainings: [Training]) {
    self.sectionTitle = sectionTitle
    self.sectionTrainings = sectionTrainings
  }
}
