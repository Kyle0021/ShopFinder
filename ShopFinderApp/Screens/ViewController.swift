//
//  ViewController.swift
//  ShopFinderApp
//
//  Created by Kyle Carlos Fernandez on 2019/09/16.
//  Copyright © 2019 Kyle. All rights reserved.
//

import UIKit
import Foundation
import ShopFramework

var selectedCityID: Int!
var mallScreenTitle: String!
//use to store city object received from framework
var cityObject = [[String: Any]]()

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //UI objects
    @IBOutlet var cityColView: UICollectionView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var btnSearchByID: UIButton!
    @IBOutlet var btnRetrieveAll: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // customise layout of collectionview
        if let flowLayout = cityColView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset.bottom = 40
        }
        
        //hide views - they will be unhidden once the datasources are ready
        cityColView.isHidden = true
        loadingView.isHidden = false
        
        //round button corners
        btnSearchByID.layer.cornerRadius = 3.0
        btnRetrieveAll.layer.cornerRadius = 3.0
        
        // call first method from framework
        // gets a custom built list of cities to plug into my UI
        Requests().getCities(completionHandler: {citiesArr in
            cityObject = citiesArr
            self.cityColView.reloadData()
            self.cityColView.isHidden = false
            self.loadingView.isHidden = true
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Hide navigationbar on first screen
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // make sure navigationbar is visible when entering the next screen
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    // search for a city particular city by ID
    // uses the alertcontroller with a textfield
    // id from textfield is passed into framework method
    @IBAction func tappedSearch(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Search By City ID", message: "Enter numeric values only.", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a city ID"
        }
        let searchAction = UIAlertAction(title: "Search", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            
            // won't continue if user didn't enter decimaldigits
            if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: firstTextField.text!)) {
                
                let errorController = UIAlertController(title: "", message: "Please enter numeric values only", preferredStyle: UIAlertController.Style.alert)
                
                errorController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(errorController, animated: true, completion: nil)
                
            }
            else{
                //framework method call
                //reload the collectionview and display new result
                cityObject = Requests().getParticularCityByID(strCityID: firstTextField.text! ) as! [[String : Any]]
                self.cityColView.reloadData()
            }
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // retrieves list of all cities
    @IBAction func tappedRetrieveAll(_ sender: Any) {
        
        // gets a custom built list of cities
        Requests().getCities(completionHandler: {citiesArr in
            cityObject = citiesArr
            self.cityColView.reloadData()
            self.cityColView.isHidden = false
            self.loadingView.isHidden = true
        })
    }
    
    // Collectionview methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cityObject.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //Reusable cell setup
        let cell = cityColView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CityCell
        cell.frame.size.width = collectionView.frame.size.width
        cell.frame.origin.x = 0
        
        //cell buttons customisation
        cell.btnViewMalls.layer.masksToBounds = true
        cell.btnViewShops.layer.masksToBounds = true
        cell.btnViewMalls.layer.cornerRadius = 3.0
        cell.btnViewShops.layer.cornerRadius = 3.0
        
        
        //set city label
        cell.lblCityName.text = ((cityObject[indexPath.row] as NSDictionary)["name"] as? String)?.uppercased()
        //set mall label
        cell.lblMallCount.text = String((((cityObject[indexPath.row] as NSDictionary)["mall count"] as? Int)!)) + " Malls"
        //set shop label
        cell.lblShopCount.text = String((((cityObject[indexPath.row] as NSDictionary)["shop count"] as? Int)!)) + " Shops"
        
        //set button targets
        cell.btnViewMalls.addTarget(self, action: #selector(tappedViewMalls), for: .touchUpInside)
        cell.btnViewShops.addTarget(self, action: #selector(tappedViewShops), for: .touchUpInside)
        cell.btnViewMalls.tag = ((cityObject[indexPath.row] as NSDictionary)["city id"] as? Int)!
        cell.btnViewShops.tag = ((cityObject[indexPath.row] as NSDictionary)["city id"] as? Int)!
        
        return cell
    }
    
    // user tapped the view malls button
    // will transition to malls screen
    @objc func tappedViewMalls(sender: UIButton) {
        
        //stores the selected city ID for future function calls to the framework
        selectedCityID = sender.tag
        
        // creates the title for the mall screen
        for city in cityObject
        {
            if city["city id"] as? Int == selectedCityID
            {
                mallScreenTitle = "Malls in " + (city["name"] as? String)!
            }
        }
    }
    
    // user tapped the view shops button - shows all the shops in a selected city
    @objc func tappedViewShops(sender: UIButton) {
        
        selectedCityID = sender.tag
        
        for city in cityObject
        {
            if city["city id"] as? Int == selectedCityID
            {
                shopsScreenTitles = "Shops in " + (city["name"] as? String)!
            }
        }
        // method to get all shops
        shops = Requests().getListOfShopsInCity(cityID: selectedCityID)
    }
}

