//
//  DefaultUITextField.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/26/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class DefaultUITextField: UITextField {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        self.layer.cornerRadius = 2
        self.font = UIFont(name: "Futura", size: 14)
        self.textColor = UIColor.blackColor()
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName : UIColor.grayColor()])
    }
    
    
}
