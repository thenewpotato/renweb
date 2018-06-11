//
//  ScheduleAssignmentsTableViewCell.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/11/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class ScheduleAssignmentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ViewShadow: UIView!
    @IBOutlet weak var ViewContainer: UIView!
    @IBOutlet weak var labelClassName: UILabel!
    @IBOutlet weak var labelAssignmentType: UILabel!
    @IBOutlet weak var labelAssignmentBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        let shadowPath = UIBezierPath(rect: cell.ViewContainer.bounds)
        cell.ViewShadow.layer.masksToBounds = false
        cell.ViewShadow.layer.shadowOffset = CGSize(width: CGFloat(5.0), height: CGFloat(10.0))
        cell.ViewShadow.layer.shadowColor = UIColor.black.cgColor
        cell.ViewShadow.layer.shadowOpacity = 0.1
        cell.ViewShadow.layer.shadowPath = shadowPath.cgPath
    }

}
