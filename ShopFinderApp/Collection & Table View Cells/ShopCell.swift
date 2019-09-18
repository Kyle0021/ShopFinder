//
//  ShopCell.swift
//  ShopFinderApp
//
//  Created by Kyle Carlos Fernandez on 2019/09/18.
//  Copyright © 2019 Kyle. All rights reserved.
//

import UIKit

class ShopCell: UITableViewCell {

    //UI objects
    @IBOutlet var lblShopName: UILabel!
    @IBOutlet var shopImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
