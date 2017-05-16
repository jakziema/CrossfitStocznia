//
//  SearchViewController.swift
//  CrossfitStocznia
//
//  Created by Jakub Ziemann on 16.05.2017.
//  Copyright © 2017 Jakub. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}



