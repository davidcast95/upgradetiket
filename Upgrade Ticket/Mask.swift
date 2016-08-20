//
//  Mask.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 6/12/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class Mask: UIView {

    func FitToScreen(screen:CGRect) {
        self.frame = screen
        Hide()
    }
    
    func Show() {
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
    }
    
    func Hide() {
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0)
    }
    

}
