//
//  GradebookCategoriesTableViewCell.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 6/12/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import UIKit

class GradebookCategoriesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ViewShadow: UIView!
    @IBOutlet weak var ViewContainer: UIView!
    @IBOutlet weak var labelClassName: UILabel!
    @IBOutlet weak var labelCategoryName: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var labelCategoryAverage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
