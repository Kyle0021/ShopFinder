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

var jsonData = [NSDictionary]()
var selectedCityID: Int!
var mallScreenTitle: String!

var cityObject = [[String: Any]]()

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //UI objects
    @IBOutlet var cityColView: UICollectionView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var btnSearchByID: UIButton!
    @IBOutlet var btnRetrieveAll: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let flowLayout = cityColView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset.bottom = 40
        }
        
        cityColView.isHidden = true
        loadingView.isHidden = false
        
        btnSearchByID.layer.cornerRadius = 3.0
        btnRetrieveAll.layer.cornerRadius = 3.0
        
        // call method from framework
        // gets a custom built list of cities
        Requests().getCities(completionHandler: {citiesArr in
            cityObject = citiesArr
            self.cityColView.reloadData()
            self.cityColView.isHidden = false
            self.loadingView.isHidden = true
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated);
        super.viewWillDisappear(animated)
    }
    
    @IBAction func tappedSearch(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Search By City ID", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter a city ID"
        }
        let searchAction = UIAlertAction(title: "Search", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            cityObject = Requests().getParticularCityByID(strCityID: firstTextField.text! ) as! [[String : Any]]
            self.cityColView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
     
        alertController.addAction(searchAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
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
    @objc func tappedViewMalls(sender: UIButton) {
       
        selectedCityID = sender.tag

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
        shops = Requests().getListOfShopsInCity(cityID: selectedCityID)
    }
}

