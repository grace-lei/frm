//
//  FriendTableViewCell.swift
//  frmU
//
//  Created by Grace Lei on 3/27/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var friendProfileImage: UIImageView!
    
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    
}
