//
//  DateChangeViewController.swift
//  Homepwner
//
//  Created by Dylan Bruschi on 2/23/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class DateChangeViewController: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        // "Save" changes to item
        let date = datePicker.date
        item.dateCreated = date as NSDate
        
  
    }
    
}
