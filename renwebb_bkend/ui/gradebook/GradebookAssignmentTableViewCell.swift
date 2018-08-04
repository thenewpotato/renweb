//
//  GradebookAssignmentTableViewCell.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/13/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class GradebookAssignmentTableViewCell: UITableViewCell {
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var labelAssignmentDate: UILabel!
    @IBOutlet weak var labelAssignmentPts: UILabel!
    @IBOutlet weak var labelAssignmentPercentage: UILabel!
    @IBOutlet weak var labelAssignmentStatus: UILabel!
    @IBOutlet weak var labelAssignmentName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        // Shadow implementation
        let shadowPath = UIBezierPath(rect: viewShadow.bounds)
        viewShadow.layer.masksToBounds = false
        viewShadow.layer.shadowOffset = CGSize(width: CGFloat(3.0), height: CGFloat(5.0))
        viewShadow.layer.shadowColor = UIColor.black.cgColor
        viewShadow.layer.shadowOpacity = 0.1
        viewShadow.layer.shadowPath = shadowPath.cgPath
    }

}
