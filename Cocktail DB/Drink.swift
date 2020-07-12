//
//  Drink.swift
//  Cocktail DB
//
//  Created by MG on 10.07.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import Foundation

struct Drink {
    
    let idDrink: String
    let drinkName: String
    var urlImage: URL?
    var description: String?
    
    
    init(dict: [String : Any]) {
        
        self.drinkName = dict["strDrink"] as? String ?? "No id"
        self.idDrink = dict["idDrink"] as? String ?? "No name"
        self.urlImage = URL(string: dict["strDrinkThumb"] as? String ?? "No URL")
        self.description = dict["strInstructions"] as? String
    }
}
