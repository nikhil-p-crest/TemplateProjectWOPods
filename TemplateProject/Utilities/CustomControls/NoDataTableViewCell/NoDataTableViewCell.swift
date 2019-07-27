//
//  NoDataTableViewCell.swift
//  QLessKafe
//
//  Created by Mac22 on 13/03/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class NoDataTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMainContainer: UIView!
    @IBOutlet weak var labelNoDataMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNoDataMessage(_ message: String = "Constant.NoDataMessage.defaultMessage") {
        self.labelNoDataMessage.text = message
    }
    
}
