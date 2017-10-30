//
//  MainTableViewCell.swift
//  Ortaklist
//
//  Created by MacMini on 6.10.2017.
//  Copyright © 2017 Ortakfikir. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell,BEMCheckBoxDelegate {


   
    @IBOutlet weak var arkaPlan: UILabel!
    @IBOutlet weak var checkBox: BEMCheckBox!
   
    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        print("asd",checkBox.tag)
    }
    
    
}

