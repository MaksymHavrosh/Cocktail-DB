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
    
    private let heigthForRow: CGFloat = 134
    
    private var drinks: [Drink]?
    private var drinksForScreen = [Drink]()
    private let limitDrinksOnScreen = 15
    
    private var titelsForSection = ["Ordinary Drink"]
    
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
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        heigthForRow
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        heigthForRow
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        drinksForScreen.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DrinkTableViewCell.self), for: indexPath) as! DrinkTableViewCell
        let drink = drinksForScreen[indexPath.row]
        cell.drinkName.text = drink.drinkName
        
        if let url = drink.urlImage {
            cell.drinkImage?.af.setImage(withURL: url)
        }
        return cell
    }
}

//MARK: - UITableViewDelegate

extension DrinksTableViewController {
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItemOnScreen = drinksForScreen.count - 1
        if indexPath.row == lastItemOnScreen, !drinks!.isEmpty {
            loadMoreData()
        }
    }
}

//MARK: - Private

private extension DrinksTableViewController {
    
    func getDrinksFromServer() {
        ServerManager().getDrinks(params: ["c" : "Ordinary Drink"], success: { (drinks) in
            self.drinks = drinks
            self.loadMoreData()
        })
    }
    
    func loadMoreData() {
        if let drinks = drinks {
            let numberOfRepetitions = drinks.count >= limitDrinksOnScreen ? limitDrinksOnScreen : drinks.count
            
            for i in 0..<numberOfRepetitions {
                drinksForScreen.append(drinks[i])
                self.drinks?.remove(at: 0)
            }
        }
        tableView.reloadData()
    }
}
