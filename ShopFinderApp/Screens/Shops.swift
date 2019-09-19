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
    @IBOutlet var tableViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customise navigation bar
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0x0A2343)
        navigationController?.navigationBar.tintColor = UIColor.init(rgb: 0xFC6917)
        
        // round button corners
        btnRetrieveByID.layer.cornerRadius = 3.0
        btnRetrieveAll.layer.cornerRadius = 3.0
        
        // if shops array is empty then call getShopList based on the mall that was selected
        // make sure button to search particular shop in a mall is visible
        if shops.count == 0
        {
            btnRetrieveByID.isEnabled = true
            btnRetrieveAll.isEnabled = true
            btnRetrieveByID.backgroundColor = UIColor.init(rgb: 0x126FBE)
            btnRetrieveAll.backgroundColor = UIColor.init(rgb: 0xFC6917)
            shops = Requests().getShopListByMallID(cityID: selectedCityID, mallID: selectedMallID)
            tableViewTopConstraint.constant = 73
            
        }
            // user click button on the first screen to view all shops in particular city
            // shops array is already loaded with the information
            // hide the search button to search a particular shop in a mall
        else
        {
            btnRetrieveByID.isEnabled = false
            btnRetrieveAll.isEnabled = false
            btnRetrieveByID.backgroundColor = UIColor.lightGray
            btnRetrieveAll.backgroundColor = UIColor.lightGray
            tableViewTopConstraint.constant = 0
        }
        
        //set the title of the screen - navbar
        self.title = shopsScreenTitles
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //make sure nav bar is visible
        self.navigationController?.setNavigationBarHidden(false, animated: false);
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // clears the shops array of dictionaries when leaving - prevents appending of new data to old.
        shops = [NSDictionary]()
    }
    
    // search for a shop by ID
    // uses the alertcontroller with a textfield
    // id from textfield is passed into framework method
    @IBAction func tappedRetrieveShopByID(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Search By Shop ID", message: "Please enter numeric values only", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a Shop ID"
        }
        let searchAction = UIAlertAction(title: "Search", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            // won't continue if user didn't enter decimal digits
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: firstTextField.text!)) {
                
                let errorController = UIAlertController(title: "", message: "Please enter numeric values only", preferredStyle: UIAlertController.Style.alert)
                
                errorController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(errorController, animated: true, completion: nil)
                
            }
            else{
                shops = Requests().getParticularShopByID(cityID: selectedCityID, mallID: selectedMallID, strShopID: firstTextField.text!)
                
                self.shopTableView.reloadData()
            }
            
            
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // retries all shops in the mall
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
