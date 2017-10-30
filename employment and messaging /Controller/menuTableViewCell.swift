//
//  menuTableViewCell.swift
//  Ortaklist
//
//  Created by MacMini on 25.09.2017.
//  Copyright © 2017 Ortakfikir. All rights reserved.
//

import UIKit

class menuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var menuIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
