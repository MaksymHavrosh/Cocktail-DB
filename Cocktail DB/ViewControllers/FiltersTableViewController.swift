//
//  FiltersTableViewController.swift
//  Cocktail DB
//
//  Created by MG on 10.07.2020.
//  Copyright © 2020 MG. All rights reserved.
//

import UIKit

class FiltersTableViewController: UITableViewController {
    
    private let filters = ["Ordinary Drink", "Cocktail", "Milk / Float / Shake", "Other / Unknown", "Cocoa", "Shot", "Coffee / Tea", "Homemade Liqueur", "Beer", "Punch / Party Drink"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        55
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < filters.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FilterTableViewCell.self), for: indexPath) as! FilterTableViewCell
            cell.filterName.text = filters[indexPath.row]
            return cell
            
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "ApplyCell")
            cell.textLabel?.text = "APPLY"
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = .boldSystemFont(ofSize: 18)
            cell.textLabel?.textAlignment = .center
            cell.backgroundColor = .black
            
            return cell
        }
    }

}
