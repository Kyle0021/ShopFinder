//
//  MallCell.swift
//  ShopFinderApp
//
//  Created by Kyle Carlos Fernandez on 2019/09/18.
//  Copyright © 2019 Kyle. All rights reserved.
//

import UIKit

class MallCell: UITableViewCell {

    //UI Objects
    @IBOutlet var lblMallName: UILabel!
    @IBOutlet var lblShopCount: UILabel!
    @IBOutlet var mallImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
