//
//  LoadingTableViewCell.swift
//  Upgrade Ticket
//
//  Created by David Wibisono on 9/4/16.
//  Copyright © 2016 David Wibisono. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        indicator.startAnimating()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
