//
//  CustomOverlayView.swift
//  Homepwner
//
//  Created by Dylan Bruschi on 2/24/17.
//  Copyright © 2017 Dylan Bruschi. All rights reserved.
//

import UIKit

class CustomOverlayView: UIView {

    @IBOutlet var crosshairView: UIView!
    
    override init (frame: CGRect){
        super.init(frame: frame)
        
        let myColor: UIColor = UIColor.yellow
        crosshairView.layer.borderColor = myColor.cgColor
        crosshairView.layer.borderWidth = 1.0
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
