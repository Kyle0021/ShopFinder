//
//  Requests.swift
//  ShopFramework
//
//  Created by Kyle Carlos Fernandez on 2019/09/18.
//  Copyright © 2019 Kyle. All rights reserved.
//

import Foundation

public class Requests
{
    public init() {}
    
    public var jsonData = [NSDictionary]()
    // used to store the all the data received. Only need to do one call because it is stored.
    var userDefault = UserDefaults.standard
    
    // retrieves a list of all the cities
    //As a developer, I would like to request a list of cities
    public func getCities(completionHandler: @escaping ([[String:Any]]) -> Void)
    {
        if !Reachability.isConnectedToNetwork(){
            
            //There is no internet connection available
            //Pulls the stored data, which is the latest data from the last online session
            //Bonus: As a developer, I would like to request the last valid data when offline.
            print("No available network")
            if self.userDefault.value(forKey: "cities") != nil
            {
                self.jsonData = self.userDefault.value(forKey: "cities") as! [NSDictionary]
                var cityObject = [[String: Any]]()
                cityObject = self.buildCityObject(data: self.jsonData) as! [[String : Any]]
                completionHandler(cityObject)
                completionHandler(cityObject)
            }
        }
        else
        {
            //"Internet Connection Available
            // Retrieve the data using the GetData class
             print("available network")
            GetData().getJson(completionHandler: {Json,error in
                DispatchQueue.main.sync{
                    
                    self.userDefault.setValue(Json?["cities"] as! [NSDictionary], forKey: "cities")
                    self.jsonData = self.userDefault.value(forKey: "cities") as! [NSDictionary]
                    var cityObject = [[String: Any]]()
                    cityObject = self.buildCityObject(data: self.jsonData) as! [[String : Any]]
                    completionHandler(cityObject)
                }
            })
        }
    }
    
    // function that builds custom list of cities to fit my UI
    func buildCityObject(data: [NSDictionary]) -> [NSDictionary]
    {
        var cityObject = [[String: Any]]()
        
        for city in data
        {
            let malls = (city["malls"] as! [NSDictionary])
            
            var totalShops = 0
            for mall in malls
            {
                totalShops = totalShops + (mall["shops"] as! [NSDictionary]).count
            }
            
            var cityDict = [String:Any]()
            cityDict.updateValue(city["name"] as! String, forKey: "name")
            cityDict.updateValue(malls.count, forKey: "mall count")
            cityDict.updateValue(totalShops, forKey: "shop count")
            cityDict.updateValue(city["id"] as! Int, forKey: "city id")
            
            cityObject.append(cityDict)
            cityDict = [String:Any]()
        }
        
        return cityObject as [NSDictionary]
    }
    
    //retrieves all malls in selected city by cityID
    //As a developer, I would like to request a list of malls in a city.
    public func getMallListByCityID(cityID: Int) -> [NSDictionary]
    {
        var malls = [NSDictionary]()
        
        for city in self.userDefault.value(forKey: "cities") as! [NSDictionary]
        {
            if city["id"] as? Int == cityID
            {
                malls = city["malls"] as! [NSDictionary]
            }
        }
        
//        print(malls)
        return malls
    }
    
    // retrieves shops in selected mall by using the city ID and MallID
    // As a developer, I would like to request a list of shops in a mall.
    public func getShopListByMallID(cityID: Int, mallID: Int) -> [NSDictionary]
    {
        var malls = [NSDictionary]()
        var shops = [NSDictionary]()
        
        for city in self.userDefault.value(forKey: "cities") as! [NSDictionary]
        {
            if city["id"] as? Int == cityID
            {
                malls = city["malls"] as! [NSDictionary]
                
                for mall in malls
                {
                    if mall["id"] as? Int == mallID
                    {
                        shops = mall["shops"] as! [NSDictionary]
                    }
                }
            }
        }
        
//        print(shops)
        return shops
    }
    
    // Retrieves a list of the all the shops in a city, using cityID
    //Bonus: As a developer, I would like to request a list of shops in a city.
    public func getListOfShopsInCity(cityID: Int) -> [NSDictionary]
    {
        var malls = [NSDictionary]()
        var shops = [NSDictionary]()
        
        for city in self.userDefault.value(forKey: "cities") as! [NSDictionary]
        {
            if city["id"] as? Int == cityID
            {
                malls = city["malls"] as! [NSDictionary]
                
                for mall in malls
                {
                    let mallsToLoop = mall["shops"] as! [NSDictionary]
                    
                    for shop in mallsToLoop
                    {
                        shops.append(shop)
                    }
                }
            }
        }
        
//        print(shops)
        return shops
    }
    
    //retrieves a city by ID
    //As a developer, I would like to request a particular city
    public func getParticularCityByID(strCityID: String) -> [NSDictionary]
    {
        var cityObject = [[String: Any]]()
        let cityID: Int = Int(strCityID)!
        
        for city in self.userDefault.value(forKey: "cities") as! [NSDictionary]
        {
            if city["id"] as? Int == cityID
            {
                let malls = (city["malls"] as! [NSDictionary])
                    
                var totalShops = 0
                for mall in malls
                {
                    totalShops = totalShops + (mall["shops"] as! [NSDictionary]).count
                }
                    
                var cityDict = [String:Any]()
                cityDict.updateValue(city["name"] as! String, forKey: "name")
                cityDict.updateValue(malls.count, forKey: "mall count")
                cityDict.updateValue(totalShops, forKey: "shop count")
                cityDict.updateValue(city["id"] as! Int, forKey: "city id")
                    
                cityObject.append(cityDict)
            }
        }
        
        return cityObject as [NSDictionary]
    }
    
    //retrieves a mall by ID
    //As a developer, I would like to request a particular mall in a city.
    public func getParticularMallByID(cityID: Int, strMallID: String) -> [NSDictionary]
    {
        let mallID: Int = Int(strMallID)!
        var malls = [NSDictionary]()
        
        print(malls)
        
        for city in self.userDefault.value(forKey: "cities") as! [NSDictionary]
        {
            if city["id"] as? Int == cityID
            {
                malls = city["malls"] as! [NSDictionary]
                
                for mall in malls
                {
                    if mall["id"] as? Int == mallID
                    {
                        malls.removeAll()
                        malls.append(mall)
                    }
                }
            }
        }
        return malls
    }

    //retrieves a mall by ID
    //As a developer, I would like to request a particular shop in a mall.
    public func getParticularShopByID(cityID: Int, mallID: Int, strShopID: String ) -> [NSDictionary]
    {
        var malls = [NSDictionary]()
        var shops = [NSDictionary]()
        let shopID: Int = Int(strShopID)!
        
        for city in self.userDefault.value(forKey: "cities") as! [NSDictionary]
        {
            if city["id"] as? Int == cityID
            {
                malls = city["malls"] as! [NSDictionary]
                
                for mall in malls
                {
                    if mall["id"] as? Int == mallID
                    {
                        shops = mall["shops"] as! [NSDictionary]
                        
                        for shop in shops
                        {
                            if shop["id"] as! Int == shopID
                            {
                                shops.removeAll()
                                shops.append(shop)
                            }
                         }
                    }
                }
            }
        }
        
        return shops
    }
   
}
