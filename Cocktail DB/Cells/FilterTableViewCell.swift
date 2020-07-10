//
//  FilterTableViewCell.swift
//  Cocktail DB
//
//  Created by MG on 10.07.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterName: UILabel!
    @IBOutlet weak var checkbox: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
