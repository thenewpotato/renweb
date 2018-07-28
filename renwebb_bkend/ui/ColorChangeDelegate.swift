//
//  ColorChangeDelegate.swift
//  renwebb_bkend
//
//  Created by Tiger Wang on 7/28/18.
//  Copyright © 2018 Tiger Wang. All rights reserved.
//

import Foundation
import UIKit

protocol ColorChangeDelegate: class {
    func colorChanged(color: UIColor, name: String)
}
