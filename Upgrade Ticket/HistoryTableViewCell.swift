//
//  HistoryTableViewCell.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 8/11/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var flightNumber: UILabel!
    @IBOutlet weak var typeText: UILabel!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var flightTime: UILabel!
    @IBOutlet weak var total: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
