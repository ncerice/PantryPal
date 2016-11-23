//
//  CustomHeaderCell.swift
//  Pantry Pal
//
//  Created by Nathan Cerice on 11/22/16.
//  Copyright © 2016 407. All rights reserved.
//

import UIKit

class CustomHeaderCell: UITableViewCell {

    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var storeDateLabel: UILabel!
    
    
    @IBOutlet weak var storeNameLabel: UILabel!
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        print("SECTION DELETE PRESSED")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
