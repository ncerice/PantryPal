//
//  PantryTableViewCell.swift
//  Pantry Pal
//
//  Created by Nathan Cerice on 11/20/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit

class PantryTableViewCell: UITableViewCell {

    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
