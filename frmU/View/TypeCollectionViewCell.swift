//
//  TypeCollectionViewCell.swift
//  frmU
//
//  Created by Grace Lei on 3/24/20.
//  Copyright © 2020 FRM. All rights reserved.
//

import UIKit

class TypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var typeBackground: UIView!
    
//    override var isSelected: Bool {
//      didSet {
//        typeBackground.backgroundColor = isSelected ? .systemBlue : .systemGreen
//      }
//    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let redView = UIView(frame: bounds)
        redView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        redView.layer.cornerRadius = 25
        redView.layer.borderWidth = 1
        redView.layer.borderColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        redView.layer.masksToBounds = false
        self.backgroundView = redView

        let blueView = UIView(frame: bounds)
        blueView.layer.cornerRadius = 25
        blueView.layer.borderWidth = 1
        blueView.layer.borderColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        blueView.layer.masksToBounds = false
        blueView.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        self.selectedBackgroundView = blueView
    }
    
}
