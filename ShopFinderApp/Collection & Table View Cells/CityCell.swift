//
//  CityCell.swift
//  ShopFinderApp
//
//  Created by Kyle Carlos Fernandez on 2019/09/17.
//  Copyright © 2019 Kyle. All rights reserved.
//

import UIKit

class CityCell: UICollectionViewCell {
    
    // All UI objects on the reusable city cell in the citycollectionview
    @IBOutlet var lblCityName: UILabel!
    @IBOutlet var lblMallCount: UILabel!
    @IBOutlet var lblShopCount: UILabel!
    @IBOutlet var btnViewMalls: UIButton!
    @IBOutlet var btnViewShops: UIButton!
}
