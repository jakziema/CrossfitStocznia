//
//  TrainingTableViewCell.swift
//  CrossfitStocznia
//
//  Created by Jakub on 18.05.2016.
//  Copyright © 2016 Jakub. All rights reserved.
//

import UIKit

class TrainingTableViewCell: UITableViewCell {
  
  @IBOutlet weak var trainingNameLabel: UILabel!
  @IBOutlet weak var placesLeftLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
