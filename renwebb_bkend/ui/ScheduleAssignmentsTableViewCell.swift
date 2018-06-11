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
        // Migrated from ScheduleAssignmentsTableViewController, shadow would misplace to 130 height boundaries in original tableView method. layoutSubviews is called AFTER auto-layout takes palce, thus after reshaping ViewShadow's boundaries
        let shadowPath = UIBezierPath(rect: ViewShadow.bounds)
        ViewShadow.layer.masksToBounds = false
        ViewShadow.layer.shadowOffset = CGSize(width: CGFloat(5.0), height: CGFloat(10.0))
        ViewShadow.layer.shadowColor = UIColor.black.cgColor
        ViewShadow.layer.shadowOpacity = 0.1
        ViewShadow.layer.shadowPath = shadowPath.cgPath
    }

}
