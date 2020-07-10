//
//  DrinksTableViewController.swift
//  Cocktail DB
//
//  Created by MG on 10.07.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit
import AlamofireImage

class DrinksTableViewController: UITableViewController {
    
    var drinks: [Drink]?
    var titelsForSection = ["Ordinary Drink"]
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        getDrinksFromServer()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        titelsForSection.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        titelsForSection[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        134
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinks?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DrinkTableViewCell.self), for: indexPath) as! DrinkTableViewCell
        
        if let drinks = drinks {
            let drink = drinks[indexPath.row]
            cell.drinkName.text = drink.drinkName
            
            if let url = drink.urlImage {
                cell.drinkImage?.af.setImage(withURL: url)
            }
        }
        return cell
    }
}

//MARK: - Private

private extension DrinksTableViewController {
    
    func getDrinksFromServer() {
        ServerManager().getDrinks(success: { (drinks) in
            self.drinks = drinks
            self.tableView.reloadData()
        })
    }
    
}
