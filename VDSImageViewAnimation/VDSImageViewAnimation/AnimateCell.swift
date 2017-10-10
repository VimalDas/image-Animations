//
//  AnimateCell.swift
//  VDSImageViewAnimation
//
//  Created by Admin on 10/10/17.
//  Copyright © 2017 VimalDas. All rights reserved.
//

import UIKit

class AnimateCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var imageTitle: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
