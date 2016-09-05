//
//  FlightTableViewCell.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 5/29/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class FlightTableViewCell: UITableViewCell {

    @IBOutlet weak var airlinesLogo: UIImageView!
    @IBOutlet weak var airlinesLabel: UILabel!
    @IBOutlet weak var flightTimeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var transitFlag: UILabel!
    @IBOutlet weak var transitLabel: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        transitFlag.layer.cornerRadius = 4
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
