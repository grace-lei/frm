//
//  EventsHostedTableViewCell.swift
//  frmU
//
//  Created by Grace Lei on 3/25/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class EventsHostedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var partyNameLabel: UILabel!
    
    @IBOutlet weak var partyTimeLabel: UILabel!
    
    @IBAction func finalizeButtonPressed(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
