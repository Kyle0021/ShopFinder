//
//  Shops.swift
//  ShopFinderApp
//
//  Created by Kyle Carlos Fernandez on 2019/09/18.
//  Copyright © 2019 Kyle. All rights reserved.
//

import UIKit
import Foundation
import ShopFramework

var shopScreenTitle: String!
var shops = [NSDictionary]()

class Shops: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // UI Objects
    @IBOutlet var shopTableView: UITableView!
    @IBOutlet var btnRetrieveByID: UIButton!
    @IBOutlet var btnRetrieveAll: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // customise navigation bar
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0x0A2343)
        navigationController?.navigationBar.tintColor = UIColor.init(rgb: 0xFC6917)
        
        btnRetrieveByID.layer.cornerRadius = 3.0
        btnRetrieveAll.layer.cornerRadius = 3.0
        
        if shops.count == 0
        {
            btnRetrieveByID.isEnabled = true
            btnRetrieveAll.isEnabled = true
            btnRetrieveByID.backgroundColor = UIColor.init(rgb: 0x126FBE)
            btnRetrieveAll.backgroundColor = UIColor.init(rgb: 0xFC6917)
            shops = Requests().getShopListByMallID(cityID: selectedCityID, mallID: selectedMallID)
        }
        else
        {
            btnRetrieveByID.isEnabled = false
            btnRetrieveAll.isEnabled = false
            btnRetrieveByID.backgroundColor = UIColor.lightGray
            btnRetrieveAll.backgroundColor = UIColor.lightGray
        }
        
        //set the title of the screen - navbar
        self.title = shopsScreenTitles
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
      
        shops = [NSDictionary]()
    }
    
    @IBAction func tappedRetrieveShopByID(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Search By Shop ID", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a Shop ID"
        }
        let searchAction = UIAlertAction(title: "Search", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            shops = Requests().getParticularShopByID(cityID: selectedCityID, mallID: selectedMallID, strShopID: firstTextField.text!)
            
            self.shopTableView.reloadData()
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func tappedRetrieveAll(_ sender: Any) {
        
        shops = Requests().getShopListByMallID(cityID: selectedCityID, mallID: selectedMallID)
        self.shopTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Reusable cell setup
        let cell = shopTableView?.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopCell
        cell.frame.size.width = shopTableView.frame.size.width
        cell.frame.origin.x = 0
        
        // set mall label
        cell.lblShopName.text = ((shops[indexPath.row] as NSDictionary)["name"] as? String)?.uppercased()
        
        // setup imageview
        cell.shopImgView?.layer.cornerRadius = 3.0
        
        return cell
        
    }
}
