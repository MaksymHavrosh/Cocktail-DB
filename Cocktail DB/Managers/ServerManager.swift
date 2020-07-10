//
//  ServerManager.swift
//  Cocktail DB
//
//  Created by MG on 10.07.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import Foundation
import Alamofire

class ServerManager {
    
    func getDrinks(success: @escaping ([Drink]) -> Void ) {
        let params: [String : Any] = ["c" : "Ordinary Drink"]
        
        AF.request("https://www.thecocktaildb.com/api/json/v1/1/filter.php?",
                   method: .get,
                   parameters: params,
                   encoding: URLEncoding.default).responseJSON { (response) in
                    
                    switch response.result {
                    case .success(let value):
                        
                        guard let dictionary = value as? [String: Any], let objectsArray = dictionary["drinks"] as? [[String : Any]]  else { return }
                        var drinksArray = [Drink]()
                        
                        for drinkDictionary in objectsArray {
                            let drink = Drink(dict: drinkDictionary)
                            drinksArray.append(drink)
                        }
                        
                        success(drinksArray)
                        
                    case .failure(let error):
                        print(error)
                    }
        }
    }

}
