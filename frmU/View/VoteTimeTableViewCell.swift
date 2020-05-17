//
//  VoteTimeTableViewCell.swift
//  frmU
//
//  Created by Grace Lei on 3/27/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class VoteTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var possibleTime: UILabel!
    
    
    @IBOutlet weak var currentVote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
