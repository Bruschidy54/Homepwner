//
//  ItemTextField.swift
//  Homepwner
//
//  Created by Dylan Bruschi on 2/23/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class ItemTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        let myColor: UIColor = UIColor.blue
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 1.0
        
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        let myColor: UIColor = UIColor.black
        self.layer.borderColor = myColor.cgColor
        self.layer.borderWidth = 0.0
        
        return super.resignFirstResponder()
    }
}
