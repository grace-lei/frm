//
//  FinalizeDateTableViewCell.swift
//  frmU
//
//  Created by Lingyue Zhu on 4/30/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class FinalizeDateTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myDate: UILabel!
    
    @IBOutlet weak var numPeople: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
