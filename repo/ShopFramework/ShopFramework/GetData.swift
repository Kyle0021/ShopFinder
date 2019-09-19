//
//  GetData.swift
//  ShopFramework
//
//  Created by Kyle Carlos Fernandez on 2019/09/17.
//  Copyright © 2019 Kyle. All rights reserved.
//

import Foundation

public class GetData
{
    public func getJson(completionHandler:@escaping (NSDictionary?, Error?) -> Void)
    {
        //location of data
        //NB: URL's like the one below might not be secured, you will need to add an entry in your plist file for App Transport Security Settings and Allow arbitory loads
        let URLString: String = "http://www.mocky.io/v2/5b7e8bc03000005c0084c210"
        let url = URL(string: URLString)
        
        //fetch data from URL
        URLSession.shared.dataTask(with: (url)!, completionHandler: {(data, response, error) -> Void in
            
            do {
                // convert json object
                guard let parsed = try JSONSerialization.jsonObject(with: data!, options: [])
                    as? [String: Any]
                    
                    else
                    {
                        print("error trying to convert data.")
                        return
                    }
                
                // sends back the parsed json object as a dictionary
                completionHandler(parsed as NSDictionary,nil)
 
            } catch  {
                print("error trying to convert data.")
                return
            }
            
        }).resume()
        }
}
