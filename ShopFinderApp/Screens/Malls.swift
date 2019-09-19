//
//  Malls.swift
//  ShopFinderApp
//
//  Created by Kyle Carlos Fernandez on 2019/09/17.
//  Copyright © 2019 Kyle. All rights reserved.
//

import UIKit
import ShopFramework

var selectedMallID: Int!
var shopsScreenTitles: String!

class Malls: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // UI Objects
    @IBOutlet var mallTableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var btnMallByID: UIButton!
    @IBOutlet var btnRetrieveAll: UIButton!
    
    // used to store the mall array of dictionaries that is returned from framework
    var malls = [NSDictionary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customise navigation bar
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = UIColor.init(rgb: 0x0A2343)
        navigationController?.navigationBar.tintColor = UIColor.init(rgb: 0xFC6917)
        
        // round button corners
        btnMallByID.layer.cornerRadius = 3.0
        btnRetrieveAll.layer.cornerRadius = 3.0
        
        //set the title of the screen - navbar
        self.title = mallScreenTitle
        
        //get the list of malls from the city that was selected
        malls = Requests().getMallListByCityID(cityID: selectedCityID)
        
    }
    
    // search for a mall by ID
    // uses the alertcontroller with a textfield
    // id from textfield is passed into framework method
    @IBAction func tappedRetrieveByID(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Search By Mall ID", message: "Enter numeric values only.", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a Mall ID"
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
                self.malls = Requests().getParticularMallByID(cityID: selectedCityID, strMallID: firstTextField.text!)
                self.mallTableView.reloadData()
                
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // retrieves list of all malls
    @IBAction func tappedRetrieveAll(_ sender: Any) {
        //framework call for all malls from the city that was selected
        malls = Requests().getMallListByCityID(cityID: selectedCityID)
        mallTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return malls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Reusable cell setup
        let cell = mallTableView?.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MallCell
        cell.frame.size.width = mallTableView.frame.size.width
        cell.frame.origin.x = 0
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.init(rgb: 0xEDF4FF)
        cell.selectedBackgroundView = bgColorView
        
        // set mall label
        cell.lblMallName.text = ((malls[indexPath.row] as NSDictionary)["name"] as? String)?.uppercased()
        
        // set shop count
        let shopsAtIndexPath = (malls[indexPath.row] as NSDictionary)["shops"] as? [NSDictionary]
        cell.lblShopCount.text = String(shopsAtIndexPath!.count) + " Shops"
        
        // setup imageview
        cell.mallImgView?.layer.cornerRadius = 3.0
        
        return cell
        
    }
    
    // move to next screen when user clicks on table row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedMallID = (((malls[indexPath.row] as NSDictionary)["id"] as? Int))!
        // set screen title for shop screen
        shopsScreenTitles = "Shops in " + (((malls[indexPath.row] as NSDictionary)["name"] as? String))!
        
        performSegue(withIdentifier: "GoToShops", sender: self)
        
    }
}
