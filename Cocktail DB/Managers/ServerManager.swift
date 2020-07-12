//
//  ServerManager.swift
//  Cocktail DB
//
//  Created by MG on 10.07.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import Foundation
import Alamofire

struct ServerManager {
    
    let baseURL = "https://www.thecocktaildb.com/api/json/v1/1/"
    
    func getDrinks(params: [String : Any], success: @escaping ([Drink]) -> Void) {
        
        AF.request(baseURL + "filter.php?",
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
    
    func getFilters(success: @escaping ([String]) -> Void) {
         
        AF.request(baseURL + "list.php?",
                   method: .get,
                   parameters: ["c" : "list"],
                   encoding: URLEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        
                        guard let dictionary = value as? [String: Any], let objectsArray = dictionary["drinks"] as? [[String : Any]]  else { return }
                        var filtersArray = [String]()
                        for filtersDictionary in objectsArray {
                            
                            let filter = filtersDictionary as [String : Any]
                            if let filterValue = filter["strCategory"] as? String {
                                
                                filtersArray.append(filterValue)
                            }
                        }
                        success(filtersArray)
                    case .failure(let error):
                        print(error)
                    }
        }
        
    }
    
    func getRandomDrink(success: @escaping (Drink) -> Void) {
        
        AF.request(baseURL + "random.php",
                   method: .get,
                   encoding: URLEncoding.default).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        
                        guard let dictionary = value as? [String: Any], let objectsArray = dictionary["drinks"] as? [[String : Any]], let dict = objectsArray.first  else { return } 
                        let drink = Drink(dict: dict)
                        
                        success(drink)
                    case .failure(let error):
                        print(error)
                    }
        }
        
    }
    
}
