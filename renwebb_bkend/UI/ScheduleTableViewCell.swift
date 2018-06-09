//
//  ScheduleTableViewCell.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/7/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var ViewContainer: UIView!
    @IBOutlet weak var ViewShadow: UIView!
    @IBOutlet weak var LabelClassName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
